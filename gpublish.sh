#!/bin/bash
####################################################
# We'll setup a few variables, edit as required:
####################################################

# our VProject root
export VPROJECT="/mnt/500GB/source1"

# where is our compied addons
export VPROJECT1="$VPROJECT/1xcompiled"

# where should be store .gma files
export GMA="$VPROJECT/2xgma"

# where the game is stored to add to library
export GDir="$HOME/.steam/steam/steamapps/common/GarrysMod/bin/linux64"

# workaround for this: https://github.com/Facepunch/garrysmod-issues/issues/71#issuecomment-19152056
#export LD_LIBRARY_PATH="$GDir:$LD_LIBRARY_PATH"

R='\e[0;38;5;160m'
RB='\e[1;38;5;160m'
G='\e[0;38;5;46m'
P='\e[1;38;5;198m'
W='\e[1;49;97m'
Y='\e[0;38;5;220m'
YB='\e[1;38;5;220m'
NC='\e[0m'
usage="${Y}Bad usage. Maybe bad structure.\n
  ${P}- ${YB}${VPROJECT1} ${Y}should have your ${W}\"$1\" ${Y}folder
  ${P}- ${YB}${VPROJECT1}/$1/addon.json ${Y}should have your ${W}workshopid ${Y}for push addon updates
  ${P}- ${YB}${GMA} ${Y}should have your ${W}$1.gma ${Y}file for push updates\n\n
command usage: ${W}${0##*/} <folder>\n\n"


####################################################
# This is all the thing:
####################################################

cd "$GDir"


# check if we write the folder name and if this folder really exist
if [ -d $VPROJECT1/$1 ]; then
  addon="$GMA/$1.gma"
  icon="$VPROJECT1/$1/addon.jpg"

# always create a new gma
  if [ -f $VPROJECT1/$1/addon.json ]; then

    id="$VPROJECT1/$1/addon.json"
    workshopid=$( cat $id | jq '.workshopid' )
    json=$( cat "$VPROJECT1/$1/addon.json" )

# print json table
#printf "$json"

# now create our gma file
printf "\n\e[5;49;33mCreating GMA${NC}\n"
./gmad create -folder $VPROJECT1/$1 -out $GMA/$1.gma

  else
    printf "${RB}addon.json ${R}not found\n"
    exit 0
  fi

# exit if no .gma was created
#if [ ! -f $addon ]; then
#  printf "$addon not found."
#  exit 0

if [[ -f $icon && $workshopid = "" || $workshopid = 0 ]]; then
printf "${Y}We'll publish a new addon
  ${W}Icon path: ${NC}$icon
  ${W}Addon path: ${NC}$addon\n"

# publish
./gmpublish create -icon $icon -addon $addon

elif [[ $workshopid && ! $workshopid = 0 && -f $icon ]]; then
printf "${Y}We'll update a addon and their icon
  ${W}Workshop ID: ${P}$workshopid
  ${W}Icon path: ${NC}$icon
  ${W}Addon path: ${NC}$addon\n"

# update
./gmpublish update -id $workshopid -addon $addon -icon $icon

elif [[ $workshopid && ! $workshopid = 0 ]]; then
  printf "${Y}We'll just update a addon:
  ${W}Workshop ID: ${P}$workshopid
  ${W}Addon path: ${NC}$addon\n"

# update
./gmpublish update -id $workshopid -addon $addon

else
# You did something wrong
  printf "$usage"
  exit 0
fi
else
# You really did something very very wrong
  printf "$usage"
  exit 0
fi
printf "${Y}done.${NC}\n"
exit 0
