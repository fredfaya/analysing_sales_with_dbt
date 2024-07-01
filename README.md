## STAR SCHEMA VS ONE BIG TABLE (OBT) SCHEMA

Ce repo contient du code pour illustrer un peu certains types de schema de modelisation de données
On a illustré le star schema et le one big table schema
Les données ont été transformées en utilisant l'outil **dbt (data build tool)** et sont stockées sur **Snowflake**

Le fichier de base est les fichier sales.csv

On a repartie notre architecture en trois couches:

- ***LANDING/ INGESTION*** : On a dans cette couche des tables contenant des données telles qu'elles sont recues; elles ne subissent aucune transformations.  
Dans notre cas, le fichier brute est un fichier csv déjà bien organisé; On a donc pas besoin de créer une layer ingestion explicitement; la donnée est stockée en utilisant les seed et dbt

- ***PROCESSING*** : Dans cette couche, crée des données suivant une architecture de **star schema**; on a donc crée des tables de dimensions qui sont reliées à une table de faits</br></br></br>![Alt text](<Capture d’écran 2024-06-13 à 02.14.15.png>)</br></br>
Dans cette couche, pour effectuer des requetes, on doit parfois passer par plusieurs jointures sur plusieurs tables afin d'extraire des informations.

- ***CONSUMPTION*** : Dans cette couche, on a des tables finales qui sont là pour repondre à des besoins finaux métiers; ce sont des tables aggrégées qui suivent le schema **OBT** qui est l'un des type de schema adaptés pour ce besoin apres le star schema.  
Les requetes se font sur une seule table ne necessitant pas de jointure particuliere réduisant ainsi la complexité des requetes; 

*Exemple de table finales*:
- client_fidelity : Elle regroupe des données sur les clients afin d'evaluer leur achats, les dommes dépensées, le nombre d'achats quotidiens,etc
- employees_performances: Pour evaluer les performances des employés, leurs ventes, les sommes qu'ils raportent sur la période des données recus
- product_popularity_per_day: Une table pour permettre de connaitre la popularité d'un produit dans le temps, le nombre de fois où il est acheté, etc.
