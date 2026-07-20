# Copyright © 2020 Amazon Web Services
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http:#www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

import sys
sys.path.append("..")

#from unit_test_core.test_unit_service_v3 import *
# these tests differ from the Unit Core tests
# AWS Istio configuration has a different reason in the response for invalid token
# The responses still return 401  or 403 , but differ slightly in the reason of the response
# Therefore the tests are changed slightly to be less restrictive
#This is likely a temporary override until reasons and response codes are standardized by the forum
from test_unit_service_aws_v3 import *

# if __name__ == '__main__':
#     unittest.main()

if __name__ == '__main__':
    import xmlrunner
    unittest.main(testRunner=xmlrunner.XMLTestRunner(output='test-reports/v3', outsuffix='aws'))
