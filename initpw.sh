#!/usr/bin/env bash

link=http://www.debug-pro.com/epita/prog/s4/$(wget -qO- http://www.debug-pro.com/epita/prog/s4/ | grep "pw_0$1" | sed 's/^[^\"]*\"//g' | sed 's/\"[^\"]*$//')

echo ${link}
