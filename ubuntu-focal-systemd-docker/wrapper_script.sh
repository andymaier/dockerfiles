#!/bin/bash
  
# turn on bash's job control
set -m
  
# Start the primary process and put it in the background
export PASSWORD=admin
code-server --bind-addr 0.0.0.0:8080 &


# Start the helper process
/sbin/init --log-level=err
  
# the my_helper_process might need to know how to wait on the
# primary process to start before it does its work and returns
  
  
# now we bring the primary process back into the foreground
# and leave it there
fg %1