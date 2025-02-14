##############################################################################################
## needed to create the local folder that sql server can access
##############################################################################################
$backuppath = "C:\temp\Docker\SQL\"
if((Test-Path -Path $backuppath) -eq $false) {
    md $backuppath
}

##############################################################################################
## SQL SERVER localhost
##############################################################################################
docker pull mcr.microsoft.com/mssql/server:2019-CTP3.2-ubuntu

docker run `
--name DEVSQL19 `
-p 15789:1433 `
-e "ACCEPT_EULA=Y" `
-e "SA_PASSWORD=1qaz@WSX" `
-v C:\temp\Docker\SQL:/sql `
-d mcr.microsoft.com/mssql/server:2019-CTP3.2-ubuntu

##############################################################################################
## copy a bak file into the folder for restoreability
##############################################################################################
$backuppath = "C:\temp\Docker\SQL\Backup\"
$backupfile = "VSDBA.bak"

if((Test-Path -Path $backuppath) -eq $false) {
    md $backuppath
}

if((Test-Path -Path ($backuppath + $backupfile)) -eq $false) {
    Copy-Item ".\Files\VSDBA.bak" $backuppath
}

# docker start DEVSQL19

# docker stop DEVSQL19

# docker ps -a
# docker logs 7134e7fe39bd

##############################################################################################
## powershell to run SQL CMD SHELL
##############################################################################################
<#
    sqlcmd -S localhost,15789 -U SA -P "1qaz@WSX"

    CREATE DATABASE TestDB;
    SELECT Name from sys.Databases;
    GO

    USE TestDB
    CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT)
    INSERT INTO Inventory VALUES (1, 'banana', 150); INSERT INTO Inventory VALUES (2, 'orange', 154);
    GO

    SELECT * FROM Inventory WHERE quantity > 152;
    SELECT * FROM Inventory;
    GO

#>