# Ferret Mod
A mod adding various ferrets that tell you to go make games.
The sprites for the ferrets are based on the ferrets from [FerretSoftware](https://twitch.tv/ferretsoftware)
Mugshots for the ferrets were found [here](https://pbs.twimg.com/media/GHzvcQvaoAAsmVk?format=jpg&name=4096x4096)

# Building the mod
As advised on the noita wiki for modding with cmake as a build tool, this project is setup to be built using cmake.

```shell
cmake -G "Ninja" -B "build" -S "ferret_mod" -DCMAKE_INSTALL_PREFIX="path_to_your_game_install_here"
cmake --build -B "build"
```

The project is also setup to work with cpack, so executing cpack in the build directory should function correctly.

# Generating sprites
There's some utility python files in the `resources` folder that help with generating the spritesheets and sprites needed for each ferret. I used [piskel](https://www.piskelapp.com/) to make the animations, and it only allows one animation to be worked on at a time in the editor. so `gen_spritesheets.py` just stitches these files together and drops them in the right place that I want them for this project. `gen_ragdolls.py` just chops up the first frame of the `stand.png` animation to be the ragdoll pieces for the ferrets, and it generates the appropriate `filenames.txt` for those files.
