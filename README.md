## Cloud Computing

### First Script
#### Adding it to PATH variable

- cd ~
- mkdir bin
- cp ~/cloud-computing/lunixStatuts.sh ~/bin/lunixStatuts
- export PATH=$PATH:$HOME/bin
- source ~/.bashrc

### Second Script
#### Adding the script to crontab

- crontab -e
- 0 0 * * * $HOME/cloud-computing/deployApp.sh Adding the following line to the end of the file to schedule
- then save and exit

