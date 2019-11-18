SELECT *
FROM v$SQL
WHERE SQL_TEXT LIKE '%bind_test%'; 
--관리자만조회 가능