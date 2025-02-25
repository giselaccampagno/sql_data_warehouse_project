/*
=============================================================
Create Database and Schemas (Multiple Databases in MySQL. Schemas in SQL Server and PostgreSQL)
=============================================================
Script Purpose:
    This script creates new databases named 'dataWarehouse.[layer]' after checking if they already exists. 
    If the databases exists, they are dropped and recreated. The layer will be: 'bronze2', 'silver2', and 'gold2'.
	
WARNING:
    Running this script will drop the three databases if they exists. 
    All data in the databases will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

DROP DATABASE IF EXISTS bronze2;
CREATE DATABASE bronze2;

DROP DATABASE IF EXISTS silver2;
CREATE DATABASE silver2;

DROP DATABASE IF EXISTS gold2;
CREATE DATABASE gold2;




