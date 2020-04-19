#!/usr/bin/env bash

CFG_FILE=".initpwconf"

get_user_info(){
    if test -f "${HOME}/${CFG_FILE}" ; then
        name=$(sed -n '1p' "${HOME}/${CFG_FILE}")
        family_name=$(sed -n '2p' "${HOME}/${CFG_FILE}")
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
    if "${name}" = "" ; then
        get_user_info
    fi
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
    echo "usage: initpw [OPTIONS] number"
}

print_help_full(){
    echo "Automatically creates files for your practicals."
    print_help_basic
    echo "Options:
-h: print reduced help and exit
--help: print this message and exit
-l=NAME.FAMILY_NAME: uses this name only for this time (changes not saved). Please do use capital letters when needed.
-L=NAME.FAMILY_NAME: uses this name and saves it.Please do use capital letters when needed."
}

edit_config_file() {
    echo "${1}
${2}" > "${HOME}/${CFG_FILE}"
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
            -l=*)
                family_name="${i#*\.}"
                name="${i#-n}"
                shift
                ;;
            -L=*)
                name="${i#-L=}"
                name="${name%\.*}"
                family_name="${i#*\.}"
                edit_config_file "${name}" "${family_name}"
                shift
                ;;
            *)
                echo "Invalid argument"
                exit 1
                shift
                ;;
        esac
    done
}

parse_args "$@"
setup "$1"
