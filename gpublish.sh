#!/bin/bash
export VPROJECT="/mnt/500GB/source1"
export usage="Bad usage. Maybe you haven't a correct structure.

- 1xcompiled should have your '$1' folder

- 1xcompiled/$1 should have your 'id' txt file for push addon updates
- 2xgma should have your '$1.gma' file for push updates

command usage: gpublish <folder>"

cd $VPROJECT

# check if we write the folder name and if this folder really exist
if [[ ! -z $1 && -d $VPROJECT/1xcompiled/$1 ]]; then
  id="$VPROJECT/1xcompiled/$1/id.txt" # parse check if the addon already exist. you need to manually create for each already existent addon
  workshopid=$( cat "$VPROJECT/1xcompiled/$1/id.txt" ) # where is stored the addon id for push updates
  addon="$VPROJECT/2xgma/$1.gma" # our .gma file to write/push
  icon="$VPROJECT/1xcompiled/$1/addon.jpg" # icon, Steam workshop require a 1:1 .jpg file

# we always create a new gma
  if [ -f $VPROJECT/1xcompiled/$1/addon.json ]; then

json=$( cat "$VPROJECT/1xcompiled/$1/addon.json" )

echo "
json:
$json
"

gmad create -folder $VPROJECT/1xcompiled/$1 -out $VPROJECT/2xgma/$1.gma
echo "done"

else
  echo "addon.json file not found"
  exit 0
fi


if [[ ! -f $id && -f $icon && -f $addon ]]; then

echo "We'll create a new gma file and publish
  Icon path: $icon
  Addon path: $addon"

# publish
gmpublish create -icon $icon -addon $addon
echo "done"


elif [[ -f $id && -f $icon && -f $addon ]]; then

echo "We'll update a addon and icon
  Workshop ID: $workshopid
  Icon path: $icon
  Addon path: $addon"

# update
gmpublish update -id $workshopid -addon $addon -icon $icon


elif [[ -f $id && -f $addon ]]; then
  echo "We'll just update a addon:
  Workshop ID: $workshopid
  at $addon"

# update
gmpublish update -id $workshopid -addon $addon


else
# You fucked something, your dumb
  echo "$usage"
fi
else
# You really did something very very wrong, your stupid
  echo "$usage"
fi
