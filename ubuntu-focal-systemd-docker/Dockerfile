# Sample container image with Ubuntu Focal + Systemd + Sshd + Docker.
#
# Usage:
#
# $ docker run --runtime=sysbox-runc -it --rm -P --name=syscont nestybox/ubuntu-focal-systemd-docker
#
# This will run systemd and prompt for a user login; the default
# user/password in this image is "admin/admin". Once you log in you
# can run Docker inside as usual. You can also ssh into the image:
#
# $ ssh admin@<host-ip> -p <host-port>
#
# where <host-port> is chosen by Docker and mapped into the system container's sshd port.
#

FROM nestybox/ubuntu-focal-systemd:latest

# Docker install and tooling
RUN mkdir /usr/share/man/man1/
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt install -y tzdata
RUN apt-get update && apt-get install --no-install-recommends -y      \
       apt-transport-https                                            \
       ca-certificates                                                \
       curl                                                           \
       gnupg-agent                                                    \
       software-properties-common                                     \
       openjdk-8-jdk \
       openjdk-11-jdk \
       openjdk-14-jdk \
       tmux \ 
       jq \ 
       git \
       htop \
       #nginx \
       kafkacat \
       wget &&                                  \
                                                                      \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg           \
         | apt-key add - &&                                           \
	                                                              \
    apt-key fingerprint 0EBFCD88 &&                                   \
                                                                      \
    add-apt-repository                                                \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu     \
       $(lsb_release -cs)                                             \
       stable" &&                                                     \
                                                                      \
    apt-get update && apt-get install --no-install-recommends -y      \
       docker-ce docker-ce-cli docker-compose containerd.io &&                       \
                                                                      \
    # Housekeeping
    apt-get clean -y &&                                               \
    rm -rf                                                            \
       /var/cache/debconf/*                                           \
       /var/lib/apt/lists/*                                           \
       /var/log/*                                                     \
       /tmp/*                                                         \
       /var/tmp/*                                                     \
       /usr/share/doc/*                                               \
       /usr/share/man/*                                               \
       /usr/share/local/* &&                                          \
                                                                      \
    # Add user "admin" to the Docker group
    usermod -a -G docker admin

# Sshd install
RUN apt-get update && apt-get install --no-install-recommends -y      \
            openssh-server &&                                         \
    mkdir /home/admin/.ssh &&                                         \
    chown admin:admin /home/admin/.ssh

# Install code-server
RUN wget https://github.com/cdr/code-server/releases/download/v3.9.3/code-server_3.9.3_amd64.deb
RUN apt-get install ./code-server_3.9.3_amd64.deb -y
COPY code-server.service /lib/systemd/system/code-server.service
RUN systemctl enable code-server
RUN code-server --install-extension Pivotal.vscode-boot-dev-pack --extensions-dir /usr/lib/code-server/lib/vscode/extensions
RUN code-server --install-extension vscjava.vscode-java-pack --extensions-dir /usr/lib/code-server/lib/vscode/extensions
RUN code-server --install-extension dgileadi.java-decompiler --extensions-dir /usr/lib/code-server/lib/vscode/extensions
RUN code-server --install-extension humao.rest-client --extensions-dir /usr/lib/code-server/lib/vscode/extensions
RUN code-server --install-extension auchenberg.vscode-browser-preview --extensions-dir /usr/lib/code-server/lib/vscode/extensions

# install chrome
RUN wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
RUN apt install ./google-chrome-stable_current_amd64.deb -y

# nginx config
#COPY code-server.conf /etc/nginx/sites-available/code-server.conf
#RUN  ln -s /etc/nginx/sites-available/code-server.conf /etc/nginx/sites-enabled/code-server.conf

# caddy web proxy
#RUN echo "deb [trusted=yes] https://apt.fury.io/caddy/ /" | sudo tee -a /etc/apt/sources.list.d/caddy-fury.list
#RUN apt update && apt install caddy -y
#COPY Caddyfile /etc/caddy/Caddyfile

# tmux config
COPY .tmux.conf ~/.tmux.conf
COPY .tmux.conf /home/admin/.tmux.conf

# create development dir and clone projects
RUN mkdir ~/development
RUN cd ~/development && git clone https://github.com/confluentinc/cp-all-in-one.git
RUN cd ~/development && git clone https://github.com/predic8/apache-kafka-demos
RUN cd ~/development && wget https://downloads.apache.org/kafka/2.8.0/kafka_2.12-2.8.0.tgz && tar -xvf kafka_2.12-2.8.0.tgz

RUN mkdir /home/admin/development
RUN cd /home/admin/development && git clone https://github.com/confluentinc/cp-all-in-one.git
RUN cd /home/admin/development && git clone https://github.com/predic8/apache-kafka-demos
RUN cd /home/admin/development && wget https://downloads.apache.org/kafka/2.8.0/kafka_2.12-2.8.0.tgz && tar -xvf kafka_2.12-2.8.0.tgz


EXPOSE 22

# Set systemd as entrypoint.
ENTRYPOINT [ "/sbin/init", "--log-level=err" ]
#RUN systemctl daemon-reload