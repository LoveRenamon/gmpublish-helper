# GMPublish-helper
And why in hell I would need this? 
Well, since i keep all my already compiled `vProjects` into a single folder called `"1xcompiled"` I would like to push updates to workshop through a single command and inside my terminal.
  
With my poorly skills I did this to help me. 


## How to use: 
  - You need be online at your Steam account. 
  - Download this script and put where you wish to. *(I personally directly at `$HOME/.local/bin` to directly call from any terminal instance)* 
  - Make sure your `gmpublish` is visible by adding a symlink to your `gmpublish` binary. example: 
```bash 
ln -s $HOME/.steam/steam/steamapps/common/GarrysMod/bin/linux64/gmpublish $HOME/.local/bin/gmpublish
``` 
  - Make sure GMod `bin/linux64` folder is visible to your `$LD_LIBRARY_PATH` variable. 
```bash
export LD_LIBRARY_PATH="$HOME/.steam/steam/steamapps/common/GarrysMod/bin/linux64:$LD_LIBRARY_PATH"
``` 
  - Edit exports and paths as you envirovment need, *(since mostly people have their own different methods)* 
  - Call the script, with `gpublish.sh <foldername>` to call `gmpublish` and parse the `addon.json` and `addon.jpg`. If `id.txt` exist inside your `<foldername>`, the script will automatically read the id inside and push a upgrade instead. 

## Update an existing addon: 
  Since I'm not to good with code, you will need to create a **.txt** file inside your addon folder called `id.txt`
