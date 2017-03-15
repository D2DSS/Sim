# D2DSS
D2DSS - Discrete 2D Soccer Simulator

This repository is for sharing a new soccer simulator implemented in Octave/Matlab to provide a discrete mapping environment, easy-to-use and with graphical engine separated from execution module. This 2D simulator allows to set up variables for simulation of real game aspects. Strategies were also implemented for agents, based on heuristics, random, static rules enhanced with search A*, or using Reinforcement Learning algorithms, Q-Learning and Sarsa.

# Requirements for use & demonstration
Please note that for use this simulator is needed to install GNU Octave (recommended 4.0.0 or above) or Mathworks Matlab (recommended 8.3 R2014a or above) in the machine. Presented simulator was tested with both IDE in Operational Systems: GNU/Linux, MacOS and Windows.

# Minimum machine configuration to run this simulator using GNU/Octave or Matlab
Operating Systems     Windows / Linux / Mac
Processor             Any Intel or AMD x86 processor supporting SSE2 instruction set
Disk Space            5 GB free space for Matlab Installation or 1 GB for GNU/Octave
RAM                   At least 1024 MB (2048 MB recommended)
Video                 Any Graphic Card and Monitor with support at least 1024x768 resolution or above

# Step by step
- Install GNU/Octave 4.0.0 or above (around 200 Mb) or Matlab 8.3 2014a (around 3-4 GB).
- Download D2DSS compacted files (around 50 Kb).
- Unpacks simulator compacted files in a local folder.
- Opens GNU/Octave or Matlab.
- Sets current folder or source as your local folder of simulator files.
- In this version you can find a predefined script for Static Rules with A* agent versus Q-Learning or Sarsa (TempMain1x1_QLearning5x3.m or TempMain1x1_Sarsa5x3.m), Random agent versus Rules with A* (TempMain11x11_RandVsStar50x25.m) and a Rules versus Rules (TempMain11x11_StarVsStar50x25.m).
- Sets up variables of simulation and agents parameters and put it to run (Only in TempMain files is recommeded for newer users).
- After run you can open script for plotting, plotIndividual.m for just one execution plot and plotCompare.m for comparing more than one execution with predefined graphic (it's just a model of how plotting with simulator).

Note that score match and intelligent agent are stored stored in Data folder as default.
You can find help for installation and use more detailed in video and in each class of simulator in soon.

# Copyright
Described simulator is a free software project, you can share not commercially, please referencing all authors and article of this simulator.

# Acknowledgments
Actors want to thanks the Brazilian foundation CAPES (Coordination for the Improvement of Higher Education Personnel) to support this research.
