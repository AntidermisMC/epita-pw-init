#!/usr/bin/env bash

get_user_info(){
    if test -f ".initpwconf" ; then
        name=$(sed -n '1p' .initpwconf)
        family_name=$(sed -n '2p' .initpwconf)
        login=$(echo "${name}.${family_name}" | sed 's/\(.*\)/\L\1/')
    elif 1 ; then
        echo "File doesn't exist."
        exit 1
    fi
}

make_authors(){
    echo "${name}
${family_name}
${login}
${login}@epita.fr" > "$1AUTHORS"
}

link=http://www.debug-pro.com/epita/prog/s4/$(wget -qO- http://www.debug-pro.com/epita/prog/s4/ | grep "pw_0$1" | sed 's/^[^\"]*\"//g' | sed 's/\"[^\"]*$//')
title=${link[*]//*pw\//}
title=${title[*]//\/index.html}
mkdir "${title}"
get_user_info
make_authors "${title}/"

wget -qO- "${link}" > tmp

