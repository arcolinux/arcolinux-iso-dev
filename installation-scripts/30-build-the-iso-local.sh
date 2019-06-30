#!/bin/bash
#set -e
##################################################################################################################
# Author	:	Erik Dubois
# Website	:	https://www.erikdubois.be
# Website	:	https://www.arcolinux.info
# Website	:	https://www.arcolinux.com
# Website	:	https://www.arcolinuxd.com
# Website	:	https://www.arcolinuxforum.com
##################################################################################################################
#
#   DO NOT JUST RUN THIS. EXAMINE AND JUDGE. RUN AT YOUR OWN RISK.
#
##################################################################################################################

echo
echo "################################################################## "
echo "Phase 1 : get the latest bashrc from github"
echo "################################################################## "
echo
echo "Removing old files/folders from folder"
rm -rf ../archiso/airootfs/etc/skel/.* 2> /dev/null
echo "getting .bashrc from arcolinux-root"
wget https://raw.githubusercontent.com/arcolinux/arcolinux-root/master/etc/skel/.bashrc-latest -O ../archiso/airootfs/etc/skel/.bashrc
echo ".bashrc copied to /etc/skel"


echo
echo "################################################################## "
echo "Phase 2 : Checking if archiso is installed"
echo "################################################################## "
echo
echo "Checking if archiso is installed"

package="archiso"

#----------------------------------------------------------------------------------

#checking if application is already installed or else install with aur helpers
if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "################## "$package" is already installed"
		echo "################################################################"

else

	#checking which helper is installed
	if pacman -Qi yay &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yay"
		echo "################################################################"
		yay -S --noconfirm $package

	elif pacman -Qi trizen &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with trizen"
		echo "################################################################"
		trizen -S --noconfirm --needed --noedit $package

	elif pacman -Qi yaourt &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with yaourt"
		echo "################################################################"
		yaourt -S --noconfirm $package

	elif pacman -Qi pacaur &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with pacaur"
		echo "################################################################"
		pacaur -S --noconfirm --noedit  $package

	elif pacman -Qi packer &> /dev/null; then

		echo "################################################################"
		echo "######### Installing with packer"
		echo "################################################################"
		packer -S --noconfirm --noedit  $package

	fi

	# Just checking if installation was successful
	if pacman -Qi $package &> /dev/null; then

		echo "################################################################"
		echo "#########  "$package" has been installed"
		echo "################################################################"

	else

		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
		echo "!!!!!!!!!  "$package" has NOT been installed"
		echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

	fi

fi


echo
echo "################################################################## "
echo "Phase 3 : Making sure we start with a clean slate"
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d ~/arcolinux-build ] && sudo rm -rf ~/arcolinux-build


echo
echo "################################################################## "
echo "Phase 4 : Moving files to arcolinux-build folder"
echo "################################################################## "
echo
echo "Copying files and folder to ~/arcolinux-build"
sudo cp -r ../../arcolinux-iso-dev ~/arcolinux-build

sudo chmod 750 ~/arcolinux-build/archiso/airootfs/etc/sudoers.d
sudo chmod 750 ~/arcolinux-build/archiso/airootfs/etc/polkit-1/rules.d
sudo chgrp polkitd ~/arcolinux-build/archiso/airootfs/etc/polkit-1/rules.d

echo
echo "################################################################## "
echo "Phase 5 : Cleaning the cache"
echo "################################################################## "
echo
yes | sudo pacman -Scc

echo
echo "################################################################## "
echo "Phase 5 bis : Choose whether you want linux kernel or linux-lts kernel"
echo "If you do not know what this is about, choose linux kernel"
echo "https://wiki.archlinux.org/index.php/Kernel"
echo "################################################################## "
echo
echo "Choose linux kernel or linux-lts kernel"
echo
echo "1.  linux kernel"
echo "2.  linux-lts kernel"
echo "Type the number..."

read CHOICE

WDP=$HOME"/arcolinux-build/archiso"

case $CHOICE in

    1 )
			echo
			echo "################################################################## "
      echo "You have chosen for the linux kernel"
			echo "################################################################## "
			echo
      ;;
    2 )
			echo
			echo "################################################################## "
			echo "You have chosen for the linux-lts kernel"
			echo "################################################################## "
			echo
			FIND="calamares"
			REPLACE="calamares-lts"
			sudo sed -i "s/$FIND/$REPLACE/g" $WDP/packages.x86_64

			FIND="arcolinux-calamares-git"
			REPLACE="arcolinux-calamares-lts-git"
			sudo sed -i "s/$FIND/$REPLACE/g" $WDP/packages.x86_64

			FIND="#arcolinux-local-repo-git"
			REPLACE="arcolinux-local-repo-git"
			sudo sed -i "s/$FIND/$REPLACE/g" $WDP/packages.x86_64

			FIND="iso_name=arcolinux"
			REPLACE="iso_name=arcolinux-lts"
			sudo sed -i "s/$FIND/$REPLACE/g" $WDP/build.sh
      ;;
    * )
      echo "############################################"
      echo "Wrong choice - try again - keyboard issue?"
      echo "############################################"
			exit 1;
      ;;
esac

echo
echo "################################################################## "
echo "Phase 6 : Building the iso"
echo "################################################################## "
echo

cd ~/arcolinux-build/archiso/
sudo ./build.sh -v

echo
echo "################################################################## "
echo "Phase 7 : Copying the iso to ~/ArcoLinux-Out"
echo "################################################################## "
echo
[ -d  ~/ArcoLinux-Out ] || mkdir ~/ArcoLinux-Out
cp ~/arcolinux-build/archiso/out/arcolinux* ~/ArcoLinux-Out

echo
echo "################################################################## "
echo "Phase 8 : Making sure we start with a clean slate next time"
echo "################################################################## "
echo
echo "Deleting the build folder if one exists - takes some time"
[ -d ~/arcolinux-build ] && sudo rm -rf ~/arcolinux-build
