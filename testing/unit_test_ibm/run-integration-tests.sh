#!/usr/bin/env bash

# Install venv for python3
which apt-get && sudo apt-get install python3 python3-pip python3-venv || echo "Not Ubuntu, skipping"

python3 -m venv env
sed -i 's/$1/${1:-}/' env/bin/activate # Fix deactivation bug '$1 unbound variable'
source env/bin/activate
python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

# Run tests
python3 run_test.py

TEST_STATUS=$?

python3 -m pip freeze > requirements.txt
python3 -m pip uninstall -r requirements.txt -y
deactivate
rm -rf env/

if [ $TEST_STATUS -ne 0 ]
then
    exit 1
fi
