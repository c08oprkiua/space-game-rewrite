## Space Game
This is a redone version of the Godot port of the Wii U homebrew app [Space Game](https://github.com/vgmoose/wiiu-space) (and [Space Game NX](https://github.com/vgmoose/space-nx)). The goal of this fork is to more natively integrate the game into the Godot game engine, by using Godot's features in place of the features the original C game had to provide.

### Downloads
Linux, Mac, and Windows builds will be available upon first release.

### Credits and License
This program is licensed under [the MIT license](https://opensource.org/licenses/MIT), which grants anyone permission to do pretty much whatever they want as long as the copyright notice stays intact.*
 - Programmed by [VGMoose](https://github.com/vgmoose)
 - Original codebase based on [libwiiu pong](https://github.com/wiiudev/libwiiu/tree/master/osscreenexamples/pong) by [Relys](https://github.com/Relys)
 - Music is [\~\*cruise\*\~](https://t-tb.bandcamp.com/track/cruise) by [(T-T)b](https://t-tb.bandcamp.com/)*
 - Space ship sprite by [Gungriffon Geona](http://shmups.system11.org/viewtopic.php?p=421436&sid=c7c9dc0b51eb40aa10bd77f724f45bb1#p421436)
 - Logo font by [Iconian Fonts](http://www.dafont.com/ozda.font) 
 - OSScreen-similar font by [M+ Fonts](http://mplus-fonts.osdn.jp/about-en2.html)
 - libwiiu/bugfixes: [MarioNumber1](https://github.com/MarioNumber1), [CreeperMario](https://github.com/CreeperMario),  [brienj](https://github.com/xhp-creations), [NWPlayer123](https://github.com/NWPlayer123), [dimok](https://github.com/dimok789)
 
 *The song [\~\*cruise\*\~](https://t-tb.bandcamp.com/track/cruise) is available under [CC BY-NC-ND](https://ptesquad.bandcamp.com/album/pizza-planet-ep), and is excluded from the MIT licensing.

### How it works

All the previous scripts in the game have been split up into smaller, more specific scripts, to more comfortably fit how Godot uses scripts for nodes. For example, the player related functions from space.gd/space.c have been moved to spaceship.gd, which is now attached to the spaceship node. Functions that no longer have any use (i.e. moveBullets) due to being natively handled by the engine have been removed, though their original variables have been preserved and reused to try to keep that same "feel" of the original. 

Space Game NX uses a Bitmap font to get around the lack of an OSScreen font in SDL. In this version, the text is saved in a universally used Control theme, so that all labels automatically use it. The NX bitmap font can be toggled with the code `11111` on the Password screen.

Most of the bitmap compression/rendering/matrix logic has been replaced by native Godot functions for rotation, movement, and sprite displaying.

Due to it using the same prng method, all old passwords should work from previous versions of Space Game!

### Gameplay Differences

The big change is that now Space Game runs at 60fps when it can, and when it can't it maintains the same speed of objects in game.  Godot will try to maintain 60fps, but may bump down to 30fps if 60 is too demanding. This difference means that regardless of the fps, the gameplay should "feel" the same speed (which is important, as later levels will make the enemies faster). In the previous homebrew versions the game would render each frame as fast as it could, which turned out to come in lower than 60fps or allow inconsistent slowing down depending on what was occurring on screen.

Game saving has been added! When the player does something, like enter a password or complete a level, a save file is created, and an options selection will appear on the title screen. This will house options to toggle various gameplay things as well as any cheat/easter egg codes (at least, that change aspects of the game) the player has entered. Furthermore, the player's progress will be saved, and can be optionally resumed from when starting subsequent sessions. 

The Password screen now acts like a subscreen of the title screen (because it is) instead of its own isolated area.

The code `22222` is also added to toggle the music playing within the code, and some other passwords also had their functionality change. For example, the code `24177` now enables a new double firing function from the ship, whereas before it would transform the player's sprite. Some passwords also now also open URLs as easter eggs. Like in the original, certain cheats will disable the score counter. The code `77777` to swap the red and blue channels from the NX port is also present!

<img width="410" alt="Screen Shot 2021-08-19 at 12 02 03 AM" src="https://user-images.githubusercontent.com/2467473/130005764-2e9437a1-4d2d-4710-a410-f9f65cf05231.png"> <img width="410" alt="Screen Shot 2021-08-19 at 12 01 31 AM" src="https://user-images.githubusercontent.com/2467473/130005776-3d1f634c-5348-458b-8af1-70aeabb74e86.png">


### A final note
This is technically the fifth port of Space Game! The porting history is as follows:

[Wii U Space Game (2016)](https://github.com/vgmoose/wiiu-space) ->
[JSpaceGame (2017)](https://github.com/vgmoose/JSpaceGame/) ->
[Space Game NX (2018)](https://github.com/vgmoose/space-nx)
[Space Game (2021)](https://github.com/vgmoose/space-game) ->
[Space Game Rewritten (2023)]
(https://github.com/c08oprkiua/space-game-rewrite)
(You are here).

Space Game NX (an SDL program) was intended to be the "final form" of this small game, but using a game engine like Godot allows for better control over the FPS issue as mentioned earlier, but also personally gives me greater confidence in the codebase being more accessible in the future in a way that SDL fell a little short. Trying to explain to others how to play Space Game always forces me to start off with a "Well..." as I picture the homebrewing paths, Java path, or trying to get SDL working with their setup (aka Controllers, framerate, OS concerns, etc). Now it can be easily brought to computers, phones, consoles, or other Godot projects!

That is also the reasoning behind just naming this "Space Game"– I want this version to be "the thing" I'm referring to when I picture the original game, in the absense of a nearby Wii U of course!
