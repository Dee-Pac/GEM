

/* -------- TOP LEVEL -----------*/

CREATE
(enterprise:Enterprise { name: "PAYPAL.INC" }),
(adjacencies:Adjacencies { name: "ADJACENCIES" }),
(metadata:Metadata {name: "METADATA"}),
(security_zones:SecurityZones { name: "SECURITY ZONES" }),
(tech:DataTechnologies {name : "DATA TECHNOLOGIES"}),
(users:Users {name : "USERS"}),
(locations:Locations {name : "LOCATIONS"}),
(organizations:Organizations {name : "ORGANIZATIONS"}),
(access_controls:AccessControls {name : "ACCESS CONTROL POLICIES"}),
(docs:Documentations {name : "DOCS"}),
(communication_channels:CommunicationChannels {name : "COMMUNICATION CHANNELS"}),
(logs:ProcessLogs {name : "LOGS - PROCESS/DATA"}),
(code:CodeBase {name : "CODE-ARTIFACTS"}),
(slack:Channels { name: "SLACK" }),
(teams:Channels { name: "TEAMS" }),
(wiki:DocType { name: "JIRA" }),
(jira:DocType { name: "WIKI" }),
(iam:RoleType {name: "IAM"}),
(apache_ranger:RoleType {name: "APACHE_RANGER"})
;

/* -------- TOP LEVEL - RELATIONSHIP -----------*/

MATCH
(enterprise:Enterprise),
(adjacencies:Adjacencies),
(security_zones:SecurityZones),
(tech:DataTechnologies),
(users:Users),
(locations:Locations),
(organizations:Organizations),
(access_controls:AccessControls),
(communication_channels:CommunicationChannels),
(metadata:Metadata)
CREATE 
(adjacencies)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(security_zones)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(tech)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(users)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(locations)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(organizations)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(access_controls)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(communication_channels)-[:TOP_LEVEL_BELONGS_TO]->(enterprise),
(metadata)-[:TOP_LEVEL_BELONGS_TO]->(enterprise)
;

MATCH
(metadata:Metadata)
CREATE
(metadata)-[:HAS_TECH]->(StorageTechnology),
(metadata)<-[:IS_A_TYPE_OF_METADATA]-(StorageTechnology)
;

MATCH (access_controls:AccessControls),(role_type:RoleType)
CREATE
(access_controls)-[:HAS_ROLE_TYPES]->(role_type),
(access_controls)<-[:IS_A_TYPE_OF_ROLE]-(role_type)
;

MATCH
(docs:Documentations),
(logs:ProcessLogs),
(code:CodeBase),
(metadata:Metadata)
CREATE
(docs)-[:BELONGS_TO]->(metadata),
(logs)-[:BELONGS_TO]->(metadata),
(code)-[:BELONGS_TO]->(metadata),
(docs)<-[:HAS_METADATA]-(metadata),
(logs)<-[:HAS_METADATA]-(metadata),
(code)<-[:HAS_METADATA]-(metadata)
;

MATCH  
(docs:Documentations),
(doc_type:DocType)
CREATE
(doc_type)-[:BELONGS_TO]->(docs),
(doc_type)<-[:HAS_DOC_TYPE]-(docs)
;


MATCH  
(communication_channels:CommunicationChannels),
(channel:Channels)
CREATE
(channel)-[:BELONGS_TO]->(communication_channels),
(channel)<-[:HAS_CHANNELS]-(communication_channels)
;

/*--------- Dataset --> Storage System ----------*/
 
MATCH ()-[r:STORAGE_SYSTEM_HAS_DATASET]-() DELETE r;
MATCH ()-[r:DATASET_BELONGS_TO_STORAGE_SYSTEM]-() DELETE r;

MATCH (s:storage_system), (d:dataset)
WHERE tolower(s.storage_system_name) = tolower(d.storage_system_name)
CREATE (s)-[e:STORAGE_SYSTEM_HAS_DATASET]->(d)
CREATE (s)<-[:DATASET_BELONGS_TO_STORAGE_SYSTEM]-(d)
;

/*--------- Dataset --> column ----------*/
 
MATCH ()-[r:DATASET_HAS_COLUMN]-() DELETE r;
MATCH ()-[r:COLUMN_BELONGS_TO_DATASET]-() DELETE r;

MATCH (c:column), (d:dataset)
WHERE tolower(d.dataset) = tolower(c.dataset)
AND tolower(d.storage_system_name) = tolower(c.storage_system_name)
CREATE (d)-[e:DATASET_HAS_COLUMN]->(c)
CREATE (d)<-[:COLUMN_BELONGS_TO_DATASET]-(c)
;

/* -------------- ADJACENCY - ZONE ---------------------*/

MATCH ()-[r:ADJACENCY_HAS_ZONE]-() DELETE r;
 
MATCH (z:zone), (e:adjacency)
WHERE e.adjacency_id = z.adjacency_id
CREATE (e)-[r:ADJACENCY_HAS_ZONE]->(z)
CREATE (e)<-[:BELONGS_TO]-(z)
;

/*--------- Storage --> Storage Type ----------*/

MATCH ()-[r:STORAGE_CATEGORY_HAS_STORAGE_TYPE]-() DELETE r;
 
MATCH (s:storage_category), (st:storage_type)
WHERE s.storage_category_id = st.storage_category_id
CREATE (s)-[r:STORAGE_CATEGORY_HAS_STORAGE_TYPE]->(st)
CREATE (s)<-[:BELONGS_TO]-(st)
;

/*--------- Storage Type --> Storage System ----------*/
 
MATCH ()-[r:STORAGE_TYPE_HAS_STORAGE_SYSTEM]-() DELETE r;

MATCH (s:storage_system), (st:storage_type)
WHERE s.storage_type_id = st.storage_type_id
CREATE (st)-[e:STORAGE_TYPE_HAS_STORAGE_SYSTEM]->(s)
CREATE (st)<-[:BELONGS_TO]-(s)
;

/*--------- Zone --> Storage System ----------*/

MATCH ()-[r:ZONE_HAS_STORAGE_SYSTEM]-() DELETE r;

MATCH (s:storage_system), (z:zone)
WHERE s.zone_id = z.zone_id
CREATE (z)-[:ZONE_HAS_STORAGE_SYSTEM]->(s)
CREATE (z)<-[:BELONGS_TO]-(s)
;

/*----------- Location - Org ----------------*/

MATCH (l:location)-[r:IS_AT_LOCATION]-(o:organization) DELETE r;

MATCH (l:location),(o:organization) 
WHERE o.location = l.location 
CREATE (o)-[:ORG_IS_AT_LOCATION]->(l)
CREATE (o)<-[:LOCATION_HAS_ORGS]-(l)
;


/* --------------- TOP LEVEL ------------------*/

MATCH ()-[r:HAS_ZONE]-() DELETE r;

MATCH 
(security_zones:SecurityZones),(zone:zone)
CREATE
(zone)-[:BELONGS_TO]->(security_zones),
(zone)<-[:HAS_ZONE]-(security_zones)
;

MATCH ()-[r:HAS_ADJACENCY]-() DELETE r;

MATCH 
(adjacencies:Adjacencies),
(adjacency:adjacency)
CREATE
(adjacency)-[:BELONGS_TO]->(adjacencies),
(adjacency)<-[:HAS_ADJACENCY]-(adjacencies)
;

MATCH ()-[r:HAS_USER]-() DELETE r;

MATCH 
(users:Users),
(user:user)
CREATE
(user)-[:BELONGS_TO]->(users),
(user)<-[:HAS_USER]-(users)
;



/* --------------- MANAGER ------------------*/

MATCH ()-[r:MANAGES]-() DELETE r;
MATCH ()-[r:REPORTS_TO]-() DELETE r;


MATCH 
(user_manager:user_manager),
(manager:user),
(user:user)
WHERE
user_manager.manager_name = manager.user_name AND
user_manager.user_name = user.user_name
CREATE
(user)-[:REPORTS_TO_MANAGER]->(manager),
(user)<-[:MANAGER_OF]-(manager)
;



/* --------------- LOCATION ------------------*/

MATCH ()-[r:HAS_LOCATION]-() DELETE r;

MATCH 
(locations:Locations),
(location:location)
CREATE
(location)-[:BELONGS_TO]->(locations),
(location)<-[:HAS_LOCATION]-(locations)
;

/* --------------- ORG ------------------*/

MATCH ()-[r:HAS_ORGANIZATION]-() DELETE r;

MATCH 
(organizations:Organizations),
(organization:organization)
CREATE
(organization)-[:BELONGS_TO]->(organizations),
(organization)<-[:HAS_ORGANIZATION]-(organizations)
;


/* --------------- USER-LOCATION ------------------*/

MATCH ()-[r:USER_BELONGS_TO_LOCATION]-() DELETE r;
MATCH ()-[r:LOCATION_HAS_USER]-() DELETE r;

MATCH 
(user:user),
(location:location),
(user_location:user_location)
WHERE
user.user_name = user_location.user_name AND
location.location= user_location.location
CREATE
(user)-[:USER_BELONGS_TO_LOCATION]->(location),
(user)<-[:LOCATION_HAS_USER]-(location)
;


/* --------------- USER-ORG ------------------*/


MATCH ()-[r:USER_BELONGS_TO_ORGANIZATION]-() DELETE r;
MATCH ()-[r:ORG_HAS_USER]-() DELETE r;


MATCH 
(user:user),
(organization:organization),
(user_organization:user_organization)
WHERE
user.user_name= user_organization.user_name AND
organization.organization = user_organization.organization
CREATE
(user)-[:USER_BELONGS_TO_ORGANIZATION]->(organization),
(user)<-[:ORG_HAS_USER]-(organization)
;

/* --------------- LOCATION-ORG ------------------*/


MATCH ()-[r:ORG_IS_IN_LOCATION]-() DELETE r;
MATCH ()-[r:LOCATION_HAS_ORGS]-() DELETE r;


MATCH 
(location:location),
(organization:organization),
(organization_location:organization_location)
WHERE
location.location= organization_location.location AND
organization.organization = organization_location.organization
CREATE
(location)-[:LOCATION_HAS_ORGS]->(organization),
(location)<-[:ORG_IS_IN_LOCATION]-(organization)
;


/* --------------- IAM-OWNER ------------------*/

MATCH ()-[r:HAS_ROLES]-() DELETE r;
MATCH (iam_role:iam_role), (role_type:RoleType)
where role_type.name = "IAM"
CREATE (role_type)-[:HAS_ROLES]->(iam_role);

CREATE (:user {user_name : "#N/A"});

MATCH (n:iam_role)-[r]-(n1) WHERE n.n > 1 DELETE n ,r;
MATCH ()-[r:USER_OWNS_ROLE]-() DELETE r;
MATCH ()-[r:ROLE_OWNER_IS_USER]-() DELETE r;


MATCH 
(iam_role:iam_role),
(iam_role_owner:iam_role_owner),
(user:user)
WHERE
iam_role.iam_role_name = iam_role_owner.iam_role_name AND
user.user_name = iam_role_owner.role_owner
CREATE
(user)-[:USER_OWNS_ROLE]->(iam_role),
(user)<-[:ROLE_OWNER_IS_USER]-(iam_role)
;

/* --------------- IAM-SUBCRIBER ------------------*/


MATCH ()-[r:USER_HAS_ACCESS_TO_ROLE]-() DELETE r;
MATCH ()-[r:ROLE_IS_GRANTED_TO_USER]-() DELETE r;


MATCH 
(iam_role:iam_role),
(iam_role_subscriber:iam_role_subscriber),
(user:user)
WHERE
iam_role_subscriber.iam_role_name = iam_role.iam_role_name AND
user.user_name = iam_role_subscriber.role_subscriber
CREATE
(user)-[:USER_HAS_ACCESS_TO_ROLE]->(iam_role),
(user)<-[:ROLE_IS_GRANTED_TO_USER]-(iam_role)
;

/* --------------- LINEAGE ------------------*/

MATCH (n:SQL)-[r]-(n1)
DELETE n,r;

CREATE (p:SQL {name:"SQL"});

MATCH (p:SQL)-[r]-(c:CodeBase)
DELETE r;

MATCH (p:SQL),(c:CodeBase)
CREATE
(p)-[:IS_A_TYPE_OF_CODE]->(c),
(p)<-[:HAS_CODE_TYPE]-(c)
;


MATCH (p:Process) 
WHERE p.process = "gsql1" DELETE p
;

CREATE (gsql1:Process {process:"gsql1", code:"insert into Hive.1.edw.customer_profile \n select user_id, user_name ,extract(country from address) , count(txn_id) ,sum(txn_amt) ,count(activity_id) \n from \n Oracle.DB.1.site.user , Oracle.DB.2.site.txn , Kafka.1.user.activity \n where <JOIN>"})
;

MATCH
(p)-[a:HAS_LINEAGE]->(l),
(ct)-[b:HAS_SOURCE]->(cs),
(cs)-[c:HAS_TARGET]->(ct)
DELETE a,b,c
;

MATCH (p:Process),(l:lineage)
where p.process = l.process
CREATE 
(p)-[:HAS_LINEAGE]->(l)
;

MATCH (p:Process),(l:lineage),(cs:column),(ct:column)
where p.process = l.process
and l.source_storage_system_name = cs.storage_system_name
and l.source_dataset = cs.dataset
and l.source_column = cs.column
and l.target_storage_system_name = ct.storage_system_name
and l.target_dataset = ct.dataset
and l.target_column = ct.column
CREATE 
(ct)-[:HAS_SOURCE]->(cs),
(cs)-[:HAS_TARGET]->(ct)
;

/*****************************************/
/* END */
/*****************************************/
