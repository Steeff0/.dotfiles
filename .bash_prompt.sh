# Get user without domain
function __user_ps1() {
    # different prompt and color for root
    local USER=`whoami`
    if [[ ${USER} == *"+"* ]]; then
        USER=`cut -d'+' -f2 <<<"${USER}"`
    fi
    echo "${USER}"
}

# get current branch in git repo
function __git_ps1() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`__git_dirty_ps1`
		if [[ "${BRANCH}" == "master" ]]; then
			echo -e '\e[31m'"[${BRANCH}${STAT}]"     		# change to red
		else
			echo -e '\e[36m'"[${BRANCH}${STAT}]"     		# change to cyan
		fi
    elif [ -d ".svn" ]; then
        BRANCH="[ "`svn info | awk '/Last\ Changed\ Rev/ {print $4}'`" ]"
	else
		echo ""
	fi
}

# get current status of git repo
function __git_dirty_ps1() {
	status=`git status 2>&1 | tee`
	dirty=`echo -n "${status}" 2> /dev/null | grep "modified:" &> /dev/null; echo "$?"`
	untracked=`echo -n "${status}" 2> /dev/null | grep "Untracked files" &> /dev/null; echo "$?"`
	newfile=`echo -n "${status}" 2> /dev/null | grep "new file:" &> /dev/null; echo "$?"`
	renamed=`echo -n "${status}" 2> /dev/null | grep "renamed:" &> /dev/null; echo "$?"`
	deleted=`echo -n "${status}" 2> /dev/null | grep "deleted:" &> /dev/null; echo "$?"`
	bits=''
	if [ "${renamed}" == "0" ] ||
	    [ "${newfile}" == "0" ] ||
	    [ "${untracked}" == "0" ] ||
	    [ "${deleted}" == "0" ] ||
	    [ "${dirty}" == "0" ];
	then
		bits="!"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

function __path_ps1 {
  case $PWD in
    $HOME) echo "~";;
    $HOME/*/*/*) echo "~/.../${PWD#"${PWD%/*/*/*}/"}";;
    $HOME/*) echo "~/${PWD#"${HOME}/"}";;
    /*/*/*/*) echo ".../${PWD#"${PWD%/*/*/*}/"}";;
    *) echo "$PWD";;
  esac
}

function __docker_ps1 {
	if [ "$(echo $DOCKER_ENV)" == ""  ] || [ "$(echo $DOCKER_ENV)" == "LOCAL" ]; then
		echo ""
	elif [[ "$(echo $DOCKER_ENV)" == "prod" ]]; then
		echo -e '\e[31m'"[DOCKER ENV: ${DOCKER_ENV}] "       		# change to red
	else
		echo -e '\e[35m'"[DOCKER ENV: ${DOCKER_ENV}] "       		# change to purple
	fi
}

PS1='\[\e]0;$PWD\007\]' 			# set window title
PS1="$PS1"'\n'                 		# new line
PS1="$PS1"'\[\e[32m\]'     			# change to green
PS1="$PS1"'\D{%d/%m/%Y} \t: '       # time & date
# PS1="$PS1\`__user_ps1\`@\h "   	    # user@host<space>
PS1="$PS1"'\[\e[33m\]'     			# change to brownish yellow
PS1="$PS1\`__path_ps1\` "      	    # current working directory
PS1="$PS1\`__git_ps1\` "  	        # get git information
PS1="$PS1"'\[\e[0m\]'        		# change color
PS1="$PS1\n"               			# new line
PS1="$PS1\`__docker_ps1\`"	        # show docker env
PS1="$PS1"'\[\e[0m\]'        		# change color
PS1="$PS1$ "               			# prompt: always $

MSYS2_PS1="$PS1"               		# for detection by MSYS2 SDK's bash.basrc
