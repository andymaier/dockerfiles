docker run --runtime=sysbox-runc \
   --rm \
   -it \
   -p 8080:8080 \
   -p 90:80 \
   -p 24:22 \
   --hostname nestybox \
   --name nestybox \
   -l traefik.backend=code-server \
   -l traefik.frontend.rule=Host:code-server.ocp4.de \
   -l traefik.docker.network=web \
   -l traefik.port=8080 \
   --network web \
   nestybox-ubuntu
