import sys
sys.path.append("..")
from dotenv import load_dotenv
load_dotenv()

from unit_test_core.test_unit_service_v2 import *

if __name__ == '__main__':
    unittest.main(warnings='ignore')
