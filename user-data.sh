#!/bin/bash
echo "Infrastructure as Code: The New Normal" > index.html
nohup busybox httpd -fp 80 &