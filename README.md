# Open-Rail-Management-System

ORMS is a Lua Program for OpenComputers 1.7 and newer. Its main purpose is to control your minecraft railway including signals and switches from one place with just your mouse.
</br>
</br>
Tested and developed on Minecraft 1.7.10

This project uses the [LibGrapes](https://github.com/ApelSoftCorp/LibGrapes) library, making the [MineOS](https://github.com/IgorTimofeev/MineOS) GUI library available under OpenOS

# Installation
</br>
Needed Mods:

  [OpenComputers](https://www.curseforge.com/minecraft/mc-mods/opencomputers)
  
  [Computronics](https://github.com/Petsox/Computronics_Ctyrk4_Edition/tree/master)

   - [AsieLib](https://wiki.vexatos.com/wiki:computronics)

  [Railcraft](https://github.com/Petsox/Railcraft-mc-1.7.10)
  
  [TrainCraft](https://www.curseforge.com/minecraft/mc-mods/traincraft)

  [SignalCraft](https://pixeldrain.com/u/8bFEUxvG)
   - [VirusTotal scan](https://www.virustotal.com/gui/file/63362a784ea69233104f196080acf7555494f3e0c5005445612f16a139657969?nocache=1)
  
  </br>
  
</br>

THIS VERSION DOESN'T SUPPORT RAILCRAFT SIGNALS, ONLY SIGNALCRAFT ONES! IF YOU WANT TO USE RAILCRAFT SIGNALS, USE THE OLD VERSION [HERE](https://github.com/Petsox/Open-Rail-Management-System/tree/master)

When you have all the mods installed, make a computer with an <b>internet card, display, GPU, CPU, memory, HDD</b>

Then, install OpenOS using the OpenOS floppy and run the following command, which will automatically install ORMS into <i>/home/orms</i>:

	wget -f https://raw.githubusercontent.com/Petsox/Open-Rail-Management-System/new-master/installer.lua /tmp/installer.lua && /tmp/installer.lua

 Alternatively, if the Github installer doesn't work (you are getting a certificate error), you may try the alternative Pastebin installer, which will also install ORMS into <i>/home/orms</i>:

 	pastebin run -f iQAC8EfE
</br>

Make two digital controllers (one named "Crossings" and one named "Switches") and a digital controller from SignalCraft, named "Signals", connect them to the computer with a cable from the top

Then insert your ORMS layout into config.lua generated using the tool below.

ORMS Layout Generator is available [here](https://petsox.github.io/ORMS-Layout-Generator-Web-Edition/)

  </br>

# ORMS Demo layout
</br>

![image](https://github.com/Petsox/Open-Rail-Management-System/assets/63014892/c02e977b-5c90-49ea-98ce-b39681ebc592)

</br>

## ORMS throughout development
</br>
First Working version - 30.8.2022

![image](https://user-images.githubusercontent.com/92917981/234371577-79d61228-f193-4e25-810f-d66f4bd9d922.png)

</br>
Version 1.0 - 25.4.2023</br>

![image](https://user-images.githubusercontent.com/92917981/234370757-6332b3ea-0772-49a6-95ee-f9b95d0bb5ae.png)

</br>
Current Version 2.0 - 15.6.2024</br>

![image](https://github.com/Petsox/Open-Rail-Management-System/assets/63014892/c02e977b-5c90-49ea-98ce-b39681ebc592)
