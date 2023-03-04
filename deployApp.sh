#! /bin/bash

# create log file
LOG_FILE=/var/log/install_$(date +%Y-%m-%d).log
touch $LOG_FILE

APP_DIR=/var/www/SimpleApacheApp

cloneAndDeploy() {
    # clone the repo from github to /var/www/html/SimpleApacheApp
 
    cd /var/www/ >> $LOG_FILE
    git clone https://github.com/LoaiMasri1/SimpleApacheApp.git

    # change the ownership of the directory to www-data:www-data

    chown -R www-data:www-data $APP_DIR  >> $LOG_FILE

    # change the permissions of the directory to 755

    chmod -R 755 $APP_DIR >> $LOG_FILE


    # delete the simpleApp.conf file from /etc/apache2/sites-available if it exists

    if [ -f /etc/apache2/sites-available/simpleApp.conf ]; then
        rm /etc/apache2/sites-available/simpleApp.conf >> $LOG_FILE
    fi

    # copy conf file to /etc/apache2/sites-available

    cp $APP_DIR/simpleApp.conf /etc/apache2/sites-available/simpleApp.conf >> $LOG_FILE

    # disable the default site

    a2dissite 000-default.conf >> $LOG_FILE

    # enable the new site

    a2ensite simpleApp.conf >> $LOG_FILE

    # restart apache2

    systemctl restart apache2 >> $LOG_FILE

    # check if the apache2 service is running

    if [ $(systemctl is-active apache2) == "active" ]; then
        echo "Apache2 service is running" >> $LOG_FILE
    else
        echo "Apache2 service is not running" >> $LOG_FILE
    fi

    # verify that the app is running

    if [ $(curl -s -o /dev/null -w "%{http_code}" localhost) == "200" ]; then
        echo "The app is running" >> $LOG_FILE
    else
        echo "The app is not running" >> $LOG_FILE
    fi
}

# clone the repo from github

# check if the var/www/SimpleApacheApp directory exists

if [ -d $APP_DIR ]; then

    cd $APP_DIR >> $LOG_FILE

    # push the changes to the repo

    if [ $(git status | grep "nothing to commit" | wc -l) == 1 ]; then
        echo "No changes to push" >> $LOG_FILE
    else
        git add . >> $LOG_FILE
        git commit -m "pushing changes" >> $LOG_FILE
        git push >> $LOG_FILE
    fi
    
    git config --global --add safe.directory /var/www/SimpleApacheApp >> $LOG_FILE
    git pull >> $LOG_FILE
    systemctl reload apache2 >> $LOG_FILE
    exit
else
    cloneAndDeploy
fi
