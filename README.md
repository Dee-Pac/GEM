### GEM | Graph of Enterprise Metadata 

[![Join the chat at https://gitter.im/graph_of_enterprise_metadata/GEM-Ask-Us-Anything](https://badges.gitter.im/graph_of_enterprise_metadata/GEM-Ask-Us-Anything.svg)](https://gitter.im/graph_of_enterprise_metadata/GEM-Ask-Us-Anything?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/aeb9cda7171a467894ac9d805252a5d3)](https://app.codacy.com/gh/Dee-Pac/GEM?utm_source=github.com&utm_medium=referral&utm_content=Dee-Pac/GEM&utm_campaign=Badge_Grade)
![GitHub closed pull requests](https://img.shields.io/github/issues-pr-closed/Dee-Pac/GEM)
![GitHub issues](https://img.shields.io/github/issues-raw/Dee-Pac/GEM)
![GitHub last commit (branch)](https://img.shields.io/github/last-commit/Dee-Pac/GEM/main)


#### View of Enterprise Landscape

# <img src="docs/images/enterprise_view.png" width="600" height="350" />

#### Transformed into Graph of Enterprise Metadata

# <img src="docs/images/GEM.png" width="600" height="350" /> 


--------------------------------------------------------------------------------------------------------------------

### NODES2020 Conference

- #### [Agenda](https://neo4j.com/nodes-2020/agenda/)
- #### [View in Slideshare](https://www.slideshare.net/DeepakMC/graph-of-enterprisemetadata-nodes2020-neo4j-conference)
- #### [View as PDF](docs/pdfs/NODES2020_Talk.pdf)
- #### [Video Stream](https://www.bigmarker.com/neo4j-event/Mastering-Enterprise-Metadata-with-Neo4j?bmid=116f67e48bad)


--------------------------------------------------------------------------------------------------------------------

### Quick Start

#### Clone the Repo
```bash
# Clone the repo
git clone git@github.com:Dee-Pac/GEM.git

# Open the GEM repo
cd GEM

# make sure we are on "main" branch
git checkout origin main
```

#### Start neo4j & GraphQL
```bash
# make sure you are in the GEM directory...

# Fire-up the stack 
# - Starts a new docker network
# - Starts neo4j
# - bootstraps sample data & model
# - Starts GraphQL 

sh start.sh
```

* Following indicates successfull start of the stack
```

***********************************************************************************************
*                                 Firing Up NEO4J ...                                         *
***********************************************************************************************
...
..
***********************************************************************************************
*                          Bootstrapping neo4j with GEM data ...                              *
***********************************************************************************************
...
..
***********************************************************************************************
*                                Firing up GraphQL ...                                        *
***********************************************************************************************
...
..
***********************************************************************************************
*                     SUCCESS | Starting Graph of Enterprise Metadata                         *
***********************************************************************************************

---------------------- NEO4J Docker Environment ------------------------------
Successfully Launched neo4j docker container [gem_neo4j]
Accessing Docker Container : docker exec -it gem_neo4j bash
Accessing Via browser : http://localhost:7474/browser/
neo4j logs : <PATH_TO_REPO>/GEM/neo4j/logs/debug.log
------------------------------------------------------------------------------

----------------------- GraphQL Docker Environment ---------------------------
Successfully Launched GraphQL docker container [gem_api]
Accessing Docker Container : docker exec -it gem_api bash
Accessing Via browser : http://localhost:3000
------------------------------------------------------------------------------
```
#### Stop neo4j & GraphQL
```bash

# Stops all the containers, remove the gem docker network.

sh stop.sh
```

* Following indicates the stack has been cleaned off from the local environment
```bash
...
..
Stopping container if already running [gem_neo4j]...
Removing container if exists [gem_neo4j]...
Removing image if exists [gem_neo4j]...
Cleaning up already existing image and container [gem_api] ...
...
..
2020-10-20 12:13:11 | ------------------------------------------------------------------------------
2020-10-20 12:13:11 | Cleaning up networks ...
2020-10-20 12:13:11 | ------------------------------------------------------------------------------
2020-10-20 12:13:11 | Executing Command --> docker network rm gem_net
gem_net
2020-10-20 12:13:11 | SUCCESS
```



--------------------------------------------------------------------------------------------------------------------

### Questions

* [Contact on Gitter](https://github.com/Dee-Pac/GEM)

--------------------------------------------------------------------------------------------------------------------

### Contributing

* [Please read the contributor guidelines](https://github.com/Dee-Pac/GEM)


