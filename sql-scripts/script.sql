CREATE DATABASE MyDatabase;

USE MyDatabase;

-- Define TABLE

-- Define TABLE
CREATE TABLE trades (
                        AccountNo varchar(10),
                        Symbol varchar(10),
                        Quantity integer,
                        BuySell varchar(4),
                        Price decimal
) WITH (
    'connector' = 'filesystem',
    'path' = '/opt/flink/usrlib/sql-scripts/trade-data.csv',
    'format' = 'csv'
);

SELECT * FROM trades;