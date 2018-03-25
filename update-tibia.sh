#!/bin/bash

# Script to update Tibia Client on Linux. Made by Rafael :)

export LC_NUMERIC="en_US.UTF-8"

clear

echo '===================================='
echo 'Welcome to my Tibia Updating Script.'
echo 'By Rafael :)'
echo '===================================='
printf '\n\n'

echo 'Checking if game folders exist...'

if [ ! -d ~/games ]; then
  # Control will enter here if $DIRECTORY exists.
  echo '~/games folder does not exist. Creating ~/games/tibia...'
  mkdir ~/games
  mkdir ~/games/tibia
else
  printf '~/games folder exists.\nChecking if ~/games/tibia folder exists...\n'
  if [ ! -d ~/games/tibia ]; then
    echo '~/games/tibia folder does not exist. Creating it...'
    mkdir ~/games/tibia
    echo 'Folders now exist! Moving on...'
  else
    echo 'Folders exist. Moving on...'
  fi
fi

printf '\n'

pathTibia='~/games/tibia/'

echo 'Downloading newest version...'
cd /tmp
mkdir mytmp
cd mytmp
wget http://download.tibia.com/tibia.x64.tar.gz
echo 'Extracting downloaded game files...'
tar xzf *.gz
# echo "Deleting dowloaded compressed file..."
# rm -rf *.gz
printf "Moving extracted files to %s...\n" $pathTibia
cmd='mv ./tibia-11* '$pathTibia
eval $cmd
# printf "Cleaning up created tmp folder..."
# cd /tmp
# rm -rf mytmp

gameVersions=($(ls ~/games/tibia/ | grep tibia))
amountOfVersions=${#gameVersions[@]}
printf 'There are %i Tibia versions installed.\n\n' $amountOfVersions

echo 'Printing all versions...'
for i in `seq 0 $(($amountOfVersions-1))`;
do
        echo ' >' ${gameVersions[$i]}
done

previousVersion=${gameVersions[$((amountOfVersions-2))]}
newestVersion=${gameVersions[$((amountOfVersions-1))]}
printf "\nLatest previous version was %s." $previousVersion
printf "\nNewest version is %s.\n\n" $newestVersion

echo 'Making a backup for newest version files in ~/games/tibia/backup-newest...'
if [ ! ~/games/tibia/backup-newest ]; then
  mkdir ~/games/tibia/backup-newest
fi

pathNewest=$pathTibia$newestVersion
pathPrev=$pathTibia$previousVersion
pathBkp=$pathTibia'backup-newest'

printf 'Cleaning up previous backup...\n'
p=$pathBkp'/*'
cmd='rm -rf '$p
eval $cmd

printf "Making backup...\nCopying content of %s into %s...\n" $pathNewest $pathBkp
cmd='cp -R '$pathNewest' '$pathBkp'/'
eval $cmd

echo "Copying minimap files..."
cmd='cp -R '$pathPrev'/minimap '$pathNewest'/'
eval $cmd

echo "Copying characterdata files..."
cmd='cp -R '$pathPrev'/characterdata '$pathNewest'/'
eval $cmd

echo "Copying conf files..."
cmd='cp -R '$pathPrev'/conf '$pathNewest'/'
eval $cmd

echo "Copying cache files..."
cmd='cp -R '$pathPrev'/cache '$pathNewest'/'
eval $cmd

printf "\nCreating new shortcut for bash...\n"
printf "Deleting old alias...\n\n"

sed -i '/tibia/d' ~/.bashrc

printf "Deleted all occurences of tibia shortcuts in ~/.bashrc...\n"
printf "Appending new shortcuts...\n"
printf "\nalias tibia="$pathTibia$newestVersion"/start-tibia.sh\n"
printf "alias tibia="$pathTibia$newestVersion"/start-tibia.sh\n" >> ~/.bashrc
printf "alias tibiaupdater="$(pwd)"/update-tibia.sh"
printf "alias tibiaupdater="$(pwd)"/update-tibia.sh" >> ~/.bashrc
printf "\n\nAll done!!\nEnjoy the new game version! :)\n\n"
