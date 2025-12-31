#!/bin/bash
# Copyright © Amazon.com, Inc. or its affiliates. All Rights Reserved.
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

set -e

# Store current directory
CUR_DIR=$(pwd)
SCRIPT_SOURCE_DIR=$(dirname "$0")
cd "$SCRIPT_SOURCE_DIR"

# Set required environment variables early
export VIRTUAL_SERVICE_HOST_NAME="${UNIT_HOST}"
export MY_TENANT="osdu"
export API_VER="v3"
export PRIVILEGED_USER_TOKEN=$(curl --location ${TEST_OPENID_PROVIDER_URL} --header "Content-Type:application/x-www-form-urlencoded" --header "Authorization:Basic ${SERVICE_PRINCIPAL_AUTHORIZATION}" --data-urlencode "grant_type=client_credentials" --data-urlencode ${IDP_ALLOWED_SCOPES}  --http1.1 | jq -r '.access_token')


python3 -m pip install --upgrade pip

python3 -m venv env
source env/bin/activate

python3 -m pip install -r v3/requirements.txt

echo ""
echo ***RUNNING UNIT API $API_VER TESTS***
python3 run_test.py
TEST_STATUS=$?
echo ***FINISHED UNIT API $API_VER TESTS***

echo "TEST STATUS: $TEST_STATUS"

#python3 -m pip uninstall -r requirements.txt -y
deactivate
rm -rf env/


if [ $TEST_STATUS -ne 0 ]
then
    exit 1
fi