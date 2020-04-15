#!/usr/bin/env bash

wget -qO- http://www.debug-pro.com/epita/prog/s4/ | grep "pw_0$1"
