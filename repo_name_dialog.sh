#!/bin/bash
#Author		: Egemen Gozoglu

#Color Codes
BOLD="\\033[1;39m"
NORMAL="\\033[0;39m"
GREEN="\\033[32m"
RED="\\033[31m"
PINK="\\033[35m"
BLUE="\\033[34m"

#Set a default repo server address and also give
#the change to the user to change address if he likes
default_git_server=git@yourserver
#Creates the dialog box
git_server=`dialog --stdout --title "Server Address" --backtitle "Egemen Inc." --inputbox 'Please enter the git server address' 0 0 $default_git_server`
#Quit the script if the user selects "Cancel"
if [[ $git_server == '' ]]; then
	echo;
        echo -e $BOLD$RED"You left the repo name setting script."$NORMAL ;
        exit;
fi

#Gets the name of the repo name that user wants to create
git_repo=`dialog --stdout --title "New Repo Name" --backtitle "Egemen Inc." --inputbox 'Please enter the new git repo name that you would like to add' 0 0`
#Quit the script if the user selects "Cancel"
if [[ $git_repo == '' ]]; then
        echo;
        echo -e $BOLD$RED"You left the repo name setting script."$NORMAL ;
        exit;
fi

#Gets the description of the repo that user wants to create
#It is really usefull if you are using a web interface to 
#browse your repos like GitWeb
repo_desc=`dialog --stdout --title "Repo Description" --backtitle "Egemen Inc." --inputbox 'Please enter the new git repo description' 0 0`
#Quit the script if the user selects "Cancel"
if [[ $repo_desc == '' ]]; then
        echo;
        echo -e $BOLD$RED"You left the repo name setting script."$NORMAL ;
        exit;
fi
echo;

#This part is git related. Script clones the gitolite's admin 
#repo into the system, makes the necessary changes and pushes 
#it back to the admin repo with commit description. Also sets 
#the visibility options if you are using gitweb. After the 
#process it deletes the gitolite admin repo from the user's hard-drive.
cd /tmp
git clone $git_server:gitolite-admin
cd gitolite-admin/conf
echo >> gitolite.conf
echo "repo   $git_repo" >> gitolite.conf
echo "          RW+ = @all" >> gitolite.conf
echo "          R   = gitweb daemon" >> gitolite.conf
echo "          $git_repo = \"$repo_desc\"">> gitolite.conf

git commit -a -m "New repo: $git_repo has just been added."
git push
rm -rf /tmp/gitolite-admin  

