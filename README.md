# Observational learning task - short version
Psychtoolbox version of Observational Learning task (short version for computational psychiatry battery).
The task has an instruction phase, self-paced, followed by 2 task blocks of about 7 minutes each

### Dependencies
- The task run under Matlab with Psychtoolbox-3 (http://psychtoolbox.org/overview.html).
- So far tested on Windows 7 and Mac OS, with Matlab 2017b and 2018b

### How to?
- Download or clone repository in directory on your desktop
- In Matlab, navigate to that directory
- Run the script called 'run_OLtask.m' in order to start the task
- For now, the task run in a window (debug mode). To run in full screen mode, alter line 16 of initIOStruct.m function, replacing the 'debugWinSize' argument with 'fullWinSize' or [].
- During the task, 'hidden' keys for the experimenters are to press 'p' to proceed (before the instructions, and before the start of the main task) as well as 'q' to quit (at the very end of the task)
