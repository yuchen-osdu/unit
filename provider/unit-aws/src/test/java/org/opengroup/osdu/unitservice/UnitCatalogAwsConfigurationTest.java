/** Copyright © Amazon Web Services
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
*      http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.opengroup.osdu.unitservice;

import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.InjectMocks;
import org.mockito.junit.MockitoJUnitRunner;
import org.opengroup.osdu.unitservice.model.CatalogImpl;

@RunWith(MockitoJUnitRunner.class)
public class UnitCatalogAwsConfigurationTest {

	@InjectMocks
	private UnitCatalogAwsConfiguration unitCatalogAwsConfiguration;

	@Test
	public void testCatalogImpl() throws Exception {
        CatalogImpl catalogImpl = unitCatalogAwsConfiguration.catalogImpl("../../data/unit_catalog_v2.json");
        Assert.assertNotNull(catalogImpl);
	}
}