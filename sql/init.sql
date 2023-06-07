-- create root user and grant rights
CREATE USER 'root' IDENTIFIED BY 'root';
GRANT ALL ON *.* TO 'root';

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root';