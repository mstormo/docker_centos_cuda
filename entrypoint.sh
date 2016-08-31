#!/bin/bash

cmd="$@"

# Allow users to do VERBOSE=1 to output the commands
verbose=false
[[ "$VERBOSE" -ne 0 ]] && verbose=true

SSH_USERPASS=docker

# set root password
cmd_rootpwd="echo \"root:$SSH_USERPASS\" | /usr/sbin/chpasswd"
$verbose && echo ' *' $cmd_rootpwd
eval $cmd_rootpwd

cp /root/LS_COLOR /root/.dircolors

# If the Docker container was launched with -e UID=$UID, we'll add a local user
# with the same UID, so compiles will match the user, and not build as root
user='root'
if [ "$UID" -ne 0 ] ; then
  user=`getent passwd "$UID" | cut -d: -f1`

  if [ "$user" = "" ]; then
    user='me'

    # Oversimplification, for corporate machines most likely the group ID won't
    # match the user, but who cares. Docker really needs to support proper
    # user/groups, but until them this is an ok hack
    cmd="groupadd $user -g $UID"
    $verbose && echo ' *' $cmd
    $cmd

    # Add a user 'me' which matches the UID passed in
    cmd="useradd -d /home/$user --uid $UID -m -g $user -s /bin/bash $user"
    $verbose && echo ' *' $cmd
    $cmd

	# Set a user password, needed for sudo
	cmd_ssh="echo \"$user:$SSH_USERPASS\" | /usr/sbin/chpasswd"
    $verbose && echo ' *' $cmd_ssh
	eval $cmd_ssh

	# Add user to sudoers
	cmd="echo '$user ALL=(ALL) ALL' >> /etc/sudoers"
    $verbose && echo ' *' $cmd
    eval $cmd
  fi

  # Add custom bashrc content to the user's OS default
  cp /root/user.bashrc /home/$user/.bashrc
  cp /root/LS_COLOR /home/$user/.dircolors

  # Execute as $user with proper UID
  cmd="su -l --session-command=\"$@\" $user"
fi

# Figure out the target ID for /builds directory, and try to
# set up groups properly to match that, so user can easily
# access the build directory.
TARGET_GID=$(stat -c "%g" /builds)
EXISTS=$(cat /etc/group | grep $TARGET_GID | wc -l)
if [ $UID == "0" ]; then
    : # ignore for root user
elif [ $TARGET_GID == "0" ]; then
	chown $user /builds || echo Failed changing user of /builds to $user
elif [ $EXISTS == "0" ]; then
	# Create new group using target GID and add $user
	groupadd -g $ID$TARGET_GID tempgroup
	usermod -a -G tempgroup $user || echo Failed creating new group matching GID of /builds, and adding $user to it
else
	# GID exists, find group name and add
	GROUP=$(getent group $ID$TARGET_GID | cut -d: -f1)
	usermod -a -G $GROUP $user || echo Failed adding $user to group $TARGET_GID, for access to /builds
fi

# Start SSH server, unless a CMD is specified on the docker run command line
if [[ $cmd == *"bin/sshd"* ]]; then
	cmd_ssh="echo \"$user:$SSH_USERPASS\" | /usr/sbin/chpasswd"
    $verbose && echo ' *' $cmd_ssh
	eval $cmd_ssh
	
	OSname=`cat /etc/redhat-release | cut -d' ' -f1`
	OSver=`cat /etc/redhat-release | sed -re 's/^[A-Za-z ]* ([0-9]+.[0-9]+).*$/\1/'`
	CUver=`/usr/local/cuda/bin/nvcc --version | grep release | cut -d' ' -f5 | cut -d',' -f1`

	echo "Host Name     : $HOSTNAME"
	echo "OS            : $OSname $OSver (Cuda $CUver)"
	echo "SSH user/pass : $user/$SSH_USERPASS"
	echo "------------------------------------------------"
	echo "Get Port      : docker port $HOSTNAME"
	echo "On Windows    : putty -pw $SSH_USERPASS $user@localhost -P <port>"
	echo "On Linux      : sshpass -p '$SSH_USERPASS' ssh $user@localhost -p <port>"
	$verbose && echo ' *' $@
	$@
	exit $?
else
	echo " * su/sudo/$user password: $SSH_USERPASS"
fi

$verbose && echo ' *' $cmd
$cmd
exit $?
