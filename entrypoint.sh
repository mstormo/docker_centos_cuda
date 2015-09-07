#!/bin/bash

# If the Docker container was launched with -e UID=$UID, we'll add a local user
# with the same UID, so compiles will match the user, and not build as root
user='root'
if [ "$UID" -ne 0 ] ; then
  user=`getent passwd "$UID" | cut -d: -f1`

  # Allow users to so VERBOSE=1 to output the commands
  verbose=false
  [[ "$VERBOSE" -ne 0 ]] && verbose=true

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

    # Add custom bashrc content to the user's OS default
    cat /root/user.bashrc >> /home/$user/.bashrc
  fi

  # Execute as $user with proper UID
  cmd="su -ml --session-command=\"$@\" $user"
  $verbose && echo ' *' $cmd
  $cmd
  exit $?
fi

# Add custom bashrc content to root's OS default
cat /root/root.bashrc >> /root/.bashrc

# No UID passed in, so execute as root
$@
exit $?
