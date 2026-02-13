import pytest
import schemathesis
import jwt_client
import os
import allure
import requests

from hypothesis import settings
from dotenv import load_dotenv
# loading variables from .env file
load_dotenv()

# Fetch and modify schema to fix malformed parameter
base_url = f"https://{os.environ['VIRTUAL_SERVICE_HOST_NAME']}"
response = requests.get(f"{base_url}/api/unit/api-docs/v3")
schema_dict = response.json()

# Fix malformed parameters - add schema to data-partition-id if missing
def fix_parameters(spec):
    """Fix malformed parameters in OpenAPI spec"""
    for path, path_obj in spec.get('paths', {}).items():
        for method, operation in path_obj.items():
            if method in ['get', 'post', 'put', 'delete', 'patch', 'options', 'head']:
                params = operation.get('parameters', [])
                for param in params:
                    # If parameter has neither schema nor content, add a default schema
                    if 'schema' not in param and 'content' not in param:
                        if param.get('name') == 'data-partition-id':
                            param['schema'] = {'type': 'string'}
    return spec

schema_dict = fix_parameters(schema_dict)
schema = schemathesis.openapi.from_dict(schema_dict)

@pytest.fixture(scope="session")
def token():
    return jwt_client.get_id_token()

@pytest.fixture(scope="session")
def api_base_url():
    return base_url

# exclude methods that fail
# TODO: should be fixed on later api revisions
@allure.feature('Unit Service API v3')
@allure.story('API Contract Testing')
@allure.severity(allure.severity_level.CRITICAL)
@schema.parametrize()
@settings(max_examples=25)
def test_api(case, token, api_base_url):
    """
    Tests Unit Service API v3 endpoints using schema-based testing.
    Validates API contract compliance and response schemas.
    """
    with allure.step(f"Test {case.method} {case.path}"):
        allure.attach(
            f"Method: {case.method}\nPath: {case.path}\nQuery: {case.query}",
            name="Request Details",
            attachment_type=allure.attachment_type.TEXT
        )
        
        case.headers = {"Authorization": f"Bearer {token}"}
        
        with allure.step("Execute API call"):
            response = case.call(base_url=api_base_url)
            
        with allure.step("Validate response"):
            allure.attach(
                str(response.status_code),
                name="Response Status Code",
                attachment_type=allure.attachment_type.TEXT
            )
            if response.text:
                allure.attach(
                    response.text[:1000],  # Limit to first 1000 chars
                    name="Response Body (truncated)",
                    attachment_type=allure.attachment_type.JSON
                )
            case.validate_response(response)