Readme.txt for UntitledPowershell-iPerf
-------------------------------------------
Danish iPerf speed measurement script.

Servers used in the script are:
**Kviknet**, **DeiC**, **Fiberby** and **Globalconnect**.
If you have knowledge about other iPerf servers located in Denmark, please feel free to contact me or leave a comment.

# Overview about the script
1) Four text documents are created and can be located within the AppData/Temporary (Run > %TEMP%) folder on the PC to be used later on.
2) The four created documents are then renamed with day, month, year and timestamps to ensure that no duplicate exists.
3) Script will now search for iPerf3.exe and the DLL-files required to execute the program later on.
4) If the iPerf files are not located/found within the Temporary-folder, the script will automatically download the ZIP-file and extract the content to the Temporary-folder.
5) Before the script is executed, the script will check the NIC linkspeed. If the linkspeed of the NIC is not equal to 1 Gbps or 10 Gbps the script will break/discontinue.
6) The script now executes two times three iPerf speed measurements towards Kviknet, Deic and Fiberby. Both download and upload tests are scheduled for 30 seconds meaning that the speed measurement will run for appox. three minutes in total.
7) After both download and upload tests are performed, the script will check to see that the iPerf test were ran successfully. It will now check the logfile created for a pattern to determine if the iPerf test was completed as expected. If succesful, the script outputs the Mbits/sec to the user and continues to the next iPerf test.
8) The script will discontinue break at the end.

*More details will be added if needed.

# Roadmap - Still in progress
Upload created text files to FTP/HTTP-site.
Send created text files to mail.
Move the created text files to user's document folder for easier access.
