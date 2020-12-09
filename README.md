# Customizable-Zombies
Mod for Project Zomboid

# How to modify configuration files for Steam Dedicated Server (Windows) (12/9/20)

**NOTE: (SKIP to Step 9 if you already have a Dedicated Server with this mod added, created and working.)**

1. If you have not set up a Steam Dedicated Server already, click this link and follow this guide (by nasKo) below the headings, "**Through the Steam Client**" and "**Starting the Server**". https://steamcommunity.com/sharedfiles/filedetails/?id=514493377

2. Once your dedicated Server is creating and works, make sure your server is not running. If it is running, quit/shutdown your server by typing "quit" into the console and press enter.
<br>![Imgur](https://imgur.com/jZxOrRg.png)

3. To add "Customizable Zombies" to your dedicated server, run your game "Project Zomboid" and click "Host" from the title screen.
<br>![Imgur](https://imgur.com/lcFyYls.png) 

4. Click "Manage settings...".
<br>![Imgur](https://imgur.com/P4FgDkA.png) 

5. You should have a settings named "servertest" created when you created/started up your Dedicated Server from Step 1. If there is no settings named "servertest", click "Create New Settings" and create a settings named "servertest".

6. Click on "servertest" and edit the settings for it.

7. Click on "Steam Workshop" and add "Customizble Zombies" from the dropdown list.
<br>![Imgur](https://imgur.com/7ICzllZ.png)

8. Click "Save". Start up your dedicated server to generate the configuration files, then shutdown the dedicated server.

9. To edit the configuration files, navigate to your dedicated server's location. 
<br>My server is stored at "D:\Games\SteamLibrary\steamapps\common\Project Zomboid Dedicated Server". Your location may be different depending on how you installed your Project Zomboid Dedicated Server.

10. Click on "steamapps" and navigate to "..\steamapps\workshop\content\108600\1992785456\mods\Customizable Zombies"
<br>![Imgur](https://imgur.com/9YGTtMD.png)

11. Open "MOD Configuration_Options (Customizable Zombies).lua" in any text editor. **(If you do not see the file, start up your Dedicated Server to generate the file, then shut down the server once the file is generated.)**
<br>![Imgur](https://imgur.com/Jy7MSiJ.png)

12. Here are the settings below.
  * I am using Integers to store the settings.
    * *ChanceToSpawn*: 0 to 1000 (0.0% to 100.0%) <br>
    * *HPMultiplier*: 1 = 0.001, 1000 = 1.000, 2000 = 2.000, 3000 = 3.000, etc. <br>
    * **NOTE:** The "Crawler", "Shamber", "FastShambler", and "Runner" and their "ChanceToSpawn" must all add up to 1000 (100.0%) otherwise they may not spawn correctly. <br>
<br>![Imgur](https://imgur.com/OtvU6br.png)

13. Save and close the file once you are finished.
14. Start up your server, join, and the settings should apply.
