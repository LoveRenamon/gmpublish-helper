#!/bin/bash
export VPROJECT="/mnt/500GB/source1"
usage="Bad usage. Maybe you haven't a correct structure.

- 1xcompiled should have your '$1' folder

- 1xcompiled/$1 should have your 'id' txt file for push addon updates
- 2xgma should have your '$1.gma' file for push updates

command usage: gpublish <folder>"

cd $VPROJECT

# check if we write the folder name and if this folder really exist
if [[ ! -z $1 && -d $VPROJECT/1xcompiled/$1 ]]; then
  addon="$VPROJECT/2xgma/$1.gma"
  icon="$VPROJECT/1xcompiled/$1/addon.jpg"

# always create a new gma
  if [ -f $VPROJECT/1xcompiled/$1/addon.json ]; then

    id="$VPROJECT/1xcompiled/$1/addon.json"
    workshopid=$( cat $id | jq '.workshopid' )
    json=$( cat "$VPROJECT/1xcompiled/$1/addon.json" )

# print json table
echo $json

# now create our gma file
gmad create -folder $VPROJECT/1xcompiled/$1 -out $VPROJECT/2xgma/$1.gma

else
  echo "addon.json file not found"
  exit 0
fi

# exit if no .gma was created
if [ ! -f $addon ] then
  echo "$addon not found."
  exit 0

elif [[ -f $icon && ! -z $workshopid || $workshopid = 0 ]]; then

echo "We'll publish a new addon
  Icon path: $icon
  Addon path: $addon"

# publish
gmpublish create -icon $icon -addon $addon


elif [[ ! -z $workshopid && ! $workshopid = 0 && -f $icon ]]; then

echo "We'll update a addon and their icon
  Workshop ID: $workshopid
  Icon path: $icon
  Addon path: $addon"

# update
gmpublish update -id $workshopid -addon $addon -icon $icon


elif [[ ! -z $workshopid && ! $workshopid = 0 ]]; then
  echo "We'll just update a addon:
  Workshop ID: $workshopid
  at $addon"

# update
gmpublish update -id $workshopid -addon $addon


else
# Something is wrong
  echo "$usage"
fi
else
# You really did something very very wrong
  echo "$usage"
fi
