#!/usr/bin/env bash

get_user_info(){
    if test -f "${HOME}/.initpwconf" ; then
        echo "We're fine !!!"
        name=$(sed -n '1p' "${HOME}/.initpwconf")
        family_name=$(sed -n '2p' "${HOME}/.initpwconf")
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

init_git(){
    gitcmd=$(grep "git clone" < tmp)
    gitcmd="${gitcmd[*]/*git clone/git clone}"
    gitcmd="${gitcmd[*]/john.smith/${login}}"
    ${gitcmd}
}

setup(){
    get_user_info
    link=http://www.debug-pro.com/epita/prog/s4/$(wget -qO- http://www.debug-pro.com/epita/prog/s4/ | grep "pw_0$1" | sed 's/^[^\"]*\"//g' | sed 's/\"[^\"]*$//')
    title=${link[*]//*pw\//}
    title=${title[*]//\/index.html}
    wget -qO- "${link}" > tmp
    init_git
    cd "tp0$1-${login}" || exit 1
    mkdir "${title}"
    make_authors "${title}/"
}

print_help_basic(){
    echo "usage: initpw [OPTIONS] [number]"
}

parse_args(){
    for i in "$@"
    do
        case $i in
            -h)
                print_help_basic
                exit 0
                shift
                ;;
            --help)
                print_help_full
                exit 0
                shift
                ;;
            *)
                ;;
        esac
    done
}

parse_args "$@"
setup "$1"
