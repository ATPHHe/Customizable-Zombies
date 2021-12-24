# How to modify configuration files for Steam Dedicated Server (Windows) (12/23/2021)
# Build 41.60+

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

# Configuration for Dedicated Server on Local PC.
1. Start your Project Zomboid game for Build 41.60+.

2. In the title screen, click "Options".

3. Click the "CZombie" tab and edit the settings here.
<br>![Imgur](https://imgur.com/bJuUHfU.png)

4. Apply the settings.

5. Restart up your Dedicated Server and join.

# Configuration for Dedicated Server on External PC.
1. To edit the configuration files, navigate to the "SteamLibrary" where you installed your Dedicated Server.. 
<br>My server installed in "D:\Games\SteamLibrary\steamapps". Your location may be different depending on how you installed your Project Zomboid Dedicated Server.
<br>![Imgur](https://imgur.com/D5Wjvv7.png)

2. Navigate to "..\steamapps\workshop\content\108600\1992785456\mods\Customizable Zombies"
<br>Example location: "D:\Games\SteamLibrary\steamapps\workshop\content\108600\1992785456\mods\Customizable Zombies"
<br>![Imgur](https://imgur.com/6X2qNJ7.png)

3. Open "MOD Configuration_Options (Customizable Zombies).lua" in any text editor. **(If you do not see the file, start up your Dedicated Server to generate the file, then shut down the server once the file is generated.)**
<br>![Imgur](https://imgur.com/IkHNbYX.png)

4. Here are the settings below.
  * I am using Integers to store the settings.
    * *ChanceToSpawn*: 0 to 1000 (0.0% to 100.0%) <br>
    * *HPMultiplier*: 1 = 0.001, 1000 = 1.000, 2000 = 2.000, 3000 = 3.000, etc. <br>
    * **NOTE:** The "Crawler", "Shamber", "FastShambler", and "Runner" and their "ChanceToSpawn" must all add up to 1000 (100.0%) otherwise they may not spawn correctly. <br>
<br>![Imgur](https://imgur.com/OtvU6br.png)


5. Save and close the file once you are finished.
6. Start up your server and join.
