
/* ---------------- LOAD DATA -----------------------*/



MATCH (n:zone) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_zone.csv" AS row
CREATE (n:zone)
SET n = row,
  n.zone_id = toInteger(row.zone_id),
  n.zone_name = (row.zone_name),
  n.adjacency_id = toInteger(row.adjacency_id)
  ;



MATCH (n:adjacency) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_adjacency.csv" AS row
CREATE (n:adjacency)
SET n = row,
  n.adjacency_id = toInteger(row.adjacency_id),
  n.adjacency_name = (row.adjacency_name)
  ;

  
MATCH (n:storage_category) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_storage_category.csv" AS row
CREATE (n:storage_category)
SET n = row,
  n.storage_category_id = toInteger(row.storage_category_id),
  n.storage_category_name = (row.storage_category_name)
  ;
  
MATCH (n:storage_type) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_storage_type.csv" AS row
CREATE (n:storage_type)
SET n = row,
  n.storage_category_id = toInteger(row.storage_category_id),
  n.storage_type_name = (row.storage_type_name),
  n.storage_type_id = toInteger(row.storage_type_id)
  ;

MATCH (n:storage_system) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_storage_system.csv" AS row
CREATE (n:storage_system)
SET n = row,
  n.storage_system_id = toInteger(row.storage_system_id),
  n.storage_system_name = (row.storage_system_name),
  n.storage_type_id = toInteger(row.storage_type_id),
  n.adjacency_id = toInteger(row.adjacency_id),
  n.zone_id = toInteger(row.zone_id)
  ; 
  
MATCH (n:iam_role) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_iam_role_application.csv" AS row
CREATE (node:iam_role)
SET node = row,
  node.iam_role_name = (row.iam_role_name),
  node.application = (row.application)
  ; 


MATCH (n:iam_role_subscriber) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_iam_role_subscriber.csv" AS row
CREATE (node:iam_role_subscriber)
SET node = row,
  node.iam_role_name = (row.iam_role_name),
  node.role_subscriber = (row.role_subscriber)
  ; 
  
MATCH (n:iam_role_owner) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_iam_role_owner.csv" AS row
CREATE (node:iam_role_owner)
SET node = row,
  node.iam_role_name = (row.iam_role_name),
  node.role_owner = (row.role_owner)
  ; 

/* -------------- USER --------------- */
  
MATCH (n:user) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_users.csv" AS row
CREATE (node:user)
SET node = row,
  node.user_name = (row.user_name)
  ; 

MATCH (n:user_manager) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_user_manager.csv" AS row
CREATE (node:user_manager)
SET node = row,
  node.user_name = (row.user_name),
  node.manager_name = (row.manager_name)
  ; 

/* -------------- LOCATION --------------- */
MATCH (n:location) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_location.csv" AS row
CREATE (node:location)
SET node = row,
node.location = row.location
  ; 
  
MATCH (n:user_location) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_user_location.csv" AS row
CREATE (node:user_location)
SET node = row,
  node.user_name = (row.user_name),
  node.location = (row.location)
  ; 

/* -------------- ORGANIZATION --------------- */

MATCH (n:organization) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_organization.csv" AS row
CREATE (node:organization)
SET node = row,
  node.organization = (row.organization)
  ; 

MATCH (n:user_organization) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_user_organization.csv" AS row
CREATE (node:user_organization)
SET node = row,
  node.user_name = (row.user_name),
  node.organization = (row.organization)
  ; 

MATCH (n:organization_location) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_organization_location.csv" AS row
CREATE (node:organization_location)
SET node = row,
  node.location = (row.location),
  node.organization = (row.organization)
  ; 


/* -------------- DATASET & LINEAGE --------------- */


MATCH (n:dataset) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_storage_dataset.csv" AS row
CREATE (node:dataset)
SET node = row
  ; 

MATCH (n:column) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_dataset_column.csv" AS row
CREATE (node:column)
SET node = row
  ;
  
MATCH (n:lineage) DELETE n;
LOAD CSV WITH HEADERS FROM "file:///pc_dataset_lineage.csv" AS row
CREATE (node:lineage)
SET node = row
  ; 



