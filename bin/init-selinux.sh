#!/bin/bash

sed -i 's/^SELINUX=enforcing/SELINUX=permissive/' /etc/sysconfig/selinux

setenforce 0
