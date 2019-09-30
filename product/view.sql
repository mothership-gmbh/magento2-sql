# Abstract

A query to create a view which contains all associated attributes including parent-child relation.

# Query

Depends on: 

```
create view view_all as
  SELECT        
  
   ce.entity_id,
    cpsl.parent_id,
    ce.sku,
    ea.attribute_id,
    ea.attribute_code,
    ea.frontend_input,
    ea.backend_type,
    ea.source_model,
    e_eaov.`option_id`,
    ea.*,

    CASE ea.backend_type
    WHEN 'static' THEN
      CASE
      WHEN ea.attribute_code='created_at' THEN ce.created_at
      WHEN ea.attribute_code='sku' THEN ce.sku
      END
    WHEN 'VARCHAR' THEN ce_varchar.value
    WHEN 'INT' THEN ce_int.value
    WHEN 'TEXT' THEN ce_text.value
    WHEN 'DECIMAL' THEN ce_decimal.value
    WHEN 'DATETIME' THEN ce_datetime.value
    END            AS `value`,

    e_eaov.value   AS option_value,

    CASE ea.backend_type
    WHEN 'VARCHAR' THEN ce_varchar.value
    WHEN 'INT' THEN
      CASE
      WHEN e_eaov.value IS NULL THEN ce_int.value ELSE e_eaov.value
      END
    WHEN 'TEXT' THEN ce_text.value
    WHEN 'DECIMAL' THEN ce_decimal.value
    WHEN 'DATETIME' THEN ce_datetime.value
    END            AS `combined`,

    CASE ea.backend_type
    WHEN 'VARCHAR' THEN ce_varchar.store_id
    WHEN 'INT' THEN ce_int.store_id
    WHEN 'TEXT' THEN ce_text.store_id
    WHEN 'DECIMAL' THEN ce_decimal.store_id
    WHEN 'DATETIME' THEN ce_datetime.store_id
    END            AS store_id,
    ea.is_required AS required
 FROM catalog_product_entity ce
 
 JOIN eav_entity_attribute eea
 LEFT JOIN eav_attribute ea on ea.`attribute_id` = eea.entity_attribute_id
 
      
      
    LEFT JOIN catalog_product_entity_varchar AS ce_varchar
      ON ce.entity_id = ce_varchar.row_id
         AND ea.attribute_id = ce_varchar.attribute_id
         AND ea.backend_type = 'VARCHAR'
    LEFT JOIN catalog_product_entity_int AS ce_int
      ON ce.entity_id = ce_int.row_id
         AND ea.attribute_id = ce_int.attribute_id
         AND ea.backend_type = 'INT'
    LEFT JOIN catalog_product_entity_text AS ce_text
      ON ce.entity_id = ce_text.row_id
         AND ea.attribute_id = ce_text.attribute_id
         AND ea.backend_type = 'TEXT'
    LEFT JOIN catalog_product_entity_decimal AS ce_decimal
      ON ce.entity_id = ce_decimal.row_id
         AND ea.attribute_id = ce_decimal.attribute_id
         AND ea.backend_type = 'DECIMAL'
    LEFT JOIN catalog_product_entity_datetime AS ce_datetime
      ON ce.entity_id = ce_datetime.row_id
         AND ea.attribute_id = ce_datetime.attribute_id
         AND ea.backend_type = 'DATETIME'
    LEFT JOIN view_attributes e_eaov
      ON e_eaov.`option_id` = ce_int.`VALUE`
         AND e_eaov.`store_id` = ce_int.`store_id`
         AND e_eaov.attribute_id = ea.attribute_id
    LEFT JOIN catalog_product_super_link cpsl ON ce.entity_id = cpsl.product_id;
```
