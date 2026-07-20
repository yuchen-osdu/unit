package org.opengroup.osdu.unitservice;

import org.opengroup.osdu.unitservice.model.CatalogImpl;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.io.ClassPathResource;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Reader;
import java.util.logging.Logger;

@Configuration
@PropertySource("classpath:swagger.properties")
public class UnitOcpConfiguration {
	
    private static Logger logger = Logger.getLogger(UnitOcpConfiguration.class.getName());

    private static final String DEFAULT_CATALOG_FILE = "unit_catalog_v2.json";
    
    @Bean
    public CatalogImpl catalogImpl(@Value("${osdu.unit.catalog.filename:null}") String location) throws Exception {
    	
    	logger.info("osdu.unit.catalog.filename=" + location);
        try (FileReader reader = new FileReader(location)) {
            return CatalogImpl.createCatalog(reader);
        } catch (NullPointerException e) {
        	logger.info("osdu.unit.catalog.filename is null");
		} catch (FileNotFoundException e) {
        	logger.info("File not found");
		}
        
    	ClassPathResource cpr = new ClassPathResource(DEFAULT_CATALOG_FILE);
        InputStream inputStream = cpr.getInputStream();
        Reader reader = new InputStreamReader(inputStream);
        return CatalogImpl.createCatalog(reader);
        
    }
}
