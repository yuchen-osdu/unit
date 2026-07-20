#!/bin/bash -eu
#
# Copyright 2017-2019, Schlumberger
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/usr/bin/env bash

python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

# Run tests
export API_VER="v2"
echo ***RUNNING UNIT API $API_VER TESTS***
python3 -W ignore run_test.py
TEST_STATUS_V2=$?
echo ***FINISHED UNIT API $API_VER TESTS***
echo ""
export API_VER="v3"
echo ***RUNNING UNIT API $API_VER TESTS***
python3 -W ignore run_test.py
TEST_STATUS_V3=$?
echo ***FINISHED UNIT API $API_VER TESTS***

echo "TEST_STATUS_V2: $TEST_STATUS_V2"
echo "TEST_STATUS_V3: $TEST_STATUS_V3"

if [ $TEST_STATUS_V2 -ne 0 ] || [ $TEST_STATUS_V3 -ne 0 ]
then
    exit 1
fi
