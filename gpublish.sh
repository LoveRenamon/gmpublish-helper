#!/bin/bash
export VPROJECT="/mnt/500GB/source1"
export VPROJECT1="$VPROJECT/1xcompiled"
export GMA="$VPROJECT/2xgma"

usage="Bad usage. Maybe you haven't a correct structure.

- 1xcompiled should have your '$1' folder

- $VPROJECT1/$1/addon.json should have your 'workshopid' for push addon updates
- $GMA should have your '$1.gma' file for push updates

command usage: gpublish <folder>"

cd $VPROJECT

# check if we write the folder name and if this folder really exist
if [[ ! -z $1 && -d $VPROJECT1/$1 ]]; then
  addon="$GMA/$1.gma"
  icon="$VPROJECT1/$1/addon.jpg"

# always create a new gma
  if [ -f $VPROJECT1/$1/addon.json ]; then

    id="$VPROJECT1/$1/addon.json"
    workshopid=$( cat $id | jq '.workshopid' )
    json=$( cat "$VPROJECT1/$1/addon.json" )

# print json table
#echo "$json"

# now create our gma file
gmad create -folder $VPROJECT1/$1 -out $GMA/$1.gma

else
  echo "addon.json file not found"
  exit 0
fi

# exit if no .gma was created
if [ ! -f $addon ]; then
  echo "$addon not found."
  exit 0

elif [[ -f $icon && -z $workshopid || $workshopid = 0 ]]; then
echo "We'll publish a new addon
  Icon path: $icon
  Addon path: $addon"

# publish
gmpublish create -icon $icon -addon $addon

elif [[ $workshopid && ! $workshopid = 0 && -f $icon ]]; then
echo "We'll update a addon and their icon
  Workshop ID: $workshopid
  Icon path: $icon
  Addon path: $addon"

# update
gmpublish update -id $workshopid -addon $addon -icon $icon

elif [[ $workshopid && ! $workshopid = 0 ]]; then
  echo "We'll just update a addon:
  Workshop ID: $workshopid
  Addon path: $addon"

# update
gmpublish update -id $workshopid -addon $addon

else
# You fucked something
  echo "$usage"
fi
else
# You really did something very very wrong
  echo "$usage"
fi
