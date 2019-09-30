# Abstract

Helpul query to list all attributes and their options

# Query



```
DROP VIEW IF EXISTS `view_attributes` ;
DROP TABLE IF EXISTS `view_attributes`;


CREATE VIEW view_attributes AS
  SELECT eaov.option_id,
    ea.attribute_code,
    eao.attribute_id,
    eaov.value,
    eaov.store_id
  FROM   eav_attribute_option eao
    LEFT JOIN eav_attribute_option_value eaov
      ON eao.option_id = eaov.option_id
    LEFT JOIN eav_attribute ea
      ON eao.`attribute_id`=ea.attribute_id;
``` 
