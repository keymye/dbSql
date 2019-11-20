--emp���̺� empno�÷� �������� PRIMARY KEY����
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE => �ش� �÷����� UNIQUE INDEX �ڵ� ����
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM TABLE(dbms_xplan.display); --dbms_xplan�� ���� �ֱٿ� �����Ѱ��� �������ش�.

Plan hash value: 2949544139
 
--------------------------------------------------------------------------------------
| Id  | Operation                   | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |        |     1 |    37 |     1   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP    |     1 |    37 |     1   (0)| 00:00:01 |
|*  2 |   INDEX UNIQUE SCAN         | PK_EMP |     1 |       |     0   (0)| 00:00:01 |
--------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7369)
--�ڽĳ����� �д´�.
--empno=7369�� �÷��� �д´�.

--empno�÷����� �ε����� �����ϴ� ��Ȳ���� �ٸ��÷� ������ �����͸� ��ȸ�ϴ� ���
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER';

SELECT *
FROM TABLE(dbms_xplan.display);

Plan hash value: 3956160932
 
--------------------------------------------------------------------------
| Id  | Operation         | Name | Rows  | Bytes | Cost (%CPU)| Time     |
--------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |      |     3 |   111 |     3   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS FULL| EMP  |     3 |   111 |     3   (0)| 00:00:01 |
--------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("JOB"='MANAGER')
   
   
--�ε��� ���� �÷������� SELECT���� ����� ���
--���̺� ������ �ʿ����.
EXPLAIN PLAN FOR
SELECT empno 
FROM emp
WHERE empno=7782;

SELECT*
FROM TABLE(dbms_xplan.display);

Plan hash value: 56244932
 
----------------------------------------------------------------------------
| Id  | Operation         | Name   | Rows  | Bytes | Cost (%CPU)| Time     |
----------------------------------------------------------------------------
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 | --���̺������� ����.
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782) access �����Ҷ� ���
   
--�÷��� �ߺ��� ������ non-unique�ε��� ������
--unique index���� �����ȹ ��
--PRIMARY KEY �������� ����(unique �ε��� ����)
ALTER TABLE emp DROP CONSTRAINT pk_emp;
CREATE INDEX /*UNIQUE*/ IDX_emp_01 ON emp (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7782;

SELECT*
FROM TABLE(dbms_xplan.display);


------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_01 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("EMPNO"=7782)
    INDEX RANGE SCAN--�ߺ����� ���� �� �ֱ� ������
   
   
--emp���̺� job�÷����� �ι�° �ε��� ����(non-uniqud index)
--job�÷��� �ٸ� �ο��� job �÷��� �ߺ��� ������ �÷��̴�.
CREATE INDEX idx_emp_02 ON emp (job);
   
EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER' AND ename LIKE 'C%';

SELECT*
FROM TABLE(dbms_xplan.display);   
   
   
   
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     3 |   111 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     3 |   111 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')   
   
   --IDX_EMP_02�� ����
   
   
   
 ------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') --�ε������� Ȯ�κҰ�,���̺� �����ؾ����� �˼�����
   2 - access("JOB"='MANAGER')  
   
   
   
--emp���̺� job,ename �÷��� �������� non-unique �ε��� ����
CREATE INDEX IDX_emp_03 ON emp(job, ename);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER' AND ename LIKE 'C%';


SELECT*
FROM TABLE(dbms_xplan.display);   
   
   
    
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_03 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
       filter("ENAME" LIKE 'C%')
       
       
--emp���̺� ename,job�÷����� non-unique�ε��� ���� pt���� Ȯ��!!!!!
CREATE INDEX IDX_EMP_04 ON emp (ename,job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER' AND ename LIKE '%C';-- �ε����� ����� ����� ������.

SELECT*
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
--skip scan �ε����� �� �о���Ѵ�. 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
       
       
       
--HINT�� ����� �����ȹ ����
EXPLAIN PLAN FOR --emp_04 -> 03���� �ٲٱ�
SELECT /*+ INDEX (emp idx_emp_03) */ * --'+'�� ��Ʈ,���� ����,�����ϸ� �Ⱦ��°� ����.
FROM emp
WHERE job='MANAGER' AND ename LIKE '%C';

SELECT*
FROM TABLE(dbms_xplan.display);
       
       
       
--idx1
CREATE TABLE dept_test AS
SELECT *
FROM dept
WHERE 1=1;

CREATE UNIQUE INDEX dept_test_idx_01 ON dept_test(deptno); 
CREATE INDEX dept_test_idx_02 ON dept_test(dname); 
CREATE INDEX dept_test_idx_03 ON dept_test(deptno, dname); 

EXPLAIN PLAN FOR 
SELECT *
FROM dept_test
WHERE deptno=10;

SELECT*
FROM TABLE(dbms_xplan.display);

--idx2
DROP INDEX dept_test_idx_01;
DROP INDEX dept_test_idx_02;
DROP INDEX dept_test_idx_03;

--idx3(empno = pk index)
CREATE INDEX emp_idx_01 ON emp(mgr); 
CREATE INDEX emp_idx_02 ON emp(deptno); 
CREATE INDEX emp_idx_03 ON emp(ename); 


