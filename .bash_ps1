# Get user without domain
current_user() {
    # different prompt and color for root
    local USER=`whoami`
    if [[ ${USER} == *"+"* ]]; then
        USER=`cut -d'+' -f2 <<<"${USER}"`
    fi
    echo "${USER}"
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=`git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'`
	if [ ! "${BRANCH}" == "" ]
	then
		STAT=`parse_git_dirty`
		echo "[${BRANCH}${STAT}]"
    elif [ -d ".svn" ]; then
        BRANCH="[ "`svn info | awk '/Last\ Changed\ Rev/ {print $4}'`" ]"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
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

function current_path {
    local CURRENT_PATH=`echo ${PWD/#$HOME/\~}`
    # trim long path
    if [ ${#CURRENT_PATH} -gt "50" ]; then
        echo ".../${PWD#${PWD%/*/*/*/*/*/*}/}/"
    else
        echo "${CURRENT_PATH}"
    fi
}

export PS1="\[\e]0;$PWD\007\]\n\[\e[32m\]\`current_user\`@\h\[\e[m\] \[\e[33m\]\`current_path\`\[\e[m\] \[\e[36m\]\`parse_git_branch\`\[\e[m\]\n\[\e[0m\]$"
