#! /bin/bash

pwd

if [[ $ENV == 'DEV' ]]; then 
pwd
   echo "Running Development Server test"
   exec python "identidock.py"
elif [[ $ENV == 'UNIT' ]]; then
pwd
ls -a  ./tests.py
ls -al
ls -al ..
    echo "Running Unit Tests"
    exec python ./tests.py || {
	pwd
	ls -al
    }
else
pwd
   echo "Running Production Sever"
   exec uwsgi --http 0.0.0.0:9090 --wsgi-file /app/identidock.py \
                     --callable app --stats 0.0.0.0:9191
fi
