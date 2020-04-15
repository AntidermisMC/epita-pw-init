#!/usr/bin/env bash
if test -f ".initpwconf" ; then
    echo "File exists."
else
    echo "File doesn't exist."
fi

get_user_info(){
    name=$(sed -n '1p' .initpwconf)
    family_name=$(sed -n '2p' .initpwconf)
    login=$(echo "${name}.${family_name}" | sed 's/\(.*\)/\L\1/')
}

link=http://www.debug-pro.com/epita/prog/s4/$(wget -qO- http://www.debug-pro.com/epita/prog/s4/ | grep "pw_0$1" | sed 's/^[^\"]*\"//g' | sed 's/\"[^\"]*$//')

wget -qO- "${link}" > tmp

make_authors(){
    echo "${name}
${family_name}
${login}
${login}@epita.fr" > AUTHORS
}
