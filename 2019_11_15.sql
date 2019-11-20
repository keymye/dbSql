--emp테이블에 empno컬럼 기준으로 PRIMARY KEY생성
--PRIMARY KEY = UNIQUE + NOT NULL
--UNIQUE => 해당 컬럼으로 UNIQUE INDEX 자동 생성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY (empno);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE empno=7369;

SELECT *
FROM TABLE(dbms_xplan.display); --dbms_xplan은 가장 최근에 실행한것을 리턴해준다.

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
--자식노드먼저 읽는다.
--empno=7369인 컬럼만 읽는다.

--empno컬럼으로 인덱스가 존재하는 상황에서 다른컬럼 값으로 데이터를 조회하는 경우
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
   
   
--인덱스 구성 컬럼만으로 SELECT절에 기술한 경우
--테이블 접근이 필요없다.
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
|   0 | SELECT STATEMENT  |        |     1 |     4 |     0   (0)| 00:00:01 | --테이블접근이 없다.
|*  1 |  INDEX UNIQUE SCAN| PK_EMP |     1 |     4 |     0   (0)| 00:00:01 |
----------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - access("EMPNO"=7782) access 접근할때 사용
   
--컬럼에 중복이 가능한 non-unique인덱스 생성후
--unique index와의 실행계획 비교
--PRIMARY KEY 제약조건 삭제(unique 인덱스 삭제)
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
    INDEX RANGE SCAN--중복값이 있을 수 있기 때문에
   
   
--emp테이블에 job컬럼으로 두번째 인덱스 생성(non-uniqud index)
--job컬럼은 다른 로우의 job 컬럼과 중복이 가능한 컬럼이다.
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
   
   --IDX_EMP_02를 선택
   
   
   
 ------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|*  1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_02 |     3 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   1 - filter("ENAME" LIKE 'C%') --인덱스에서 확인불가,테이블에 접근해야지만 알수있음
   2 - access("JOB"='MANAGER')  
   
   
   
--emp테이블에 job,ename 컬럼을 기준으로 non-unique 인덱스 생성
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
       
       
--emp테이블에 ename,job컬럼으로 non-unique인덱스 생성 pt수정 확인!!!!!
CREATE INDEX IDX_EMP_04 ON emp (ename,job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job='MANAGER' AND ename LIKE '%C';-- 인덱스를 제대로 사용할 수없다.

SELECT*
FROM TABLE(dbms_xplan.display);

------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    37 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    37 |     2   (0)| 00:00:01 |
|*  2 |   INDEX SKIP SCAN           | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
--skip scan 인덱스를 다 읽어야한다. 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE '%C' AND "ENAME" IS NOT NULL)
       
       
       
--HINT를 사용한 실행계획 제어
EXPLAIN PLAN FOR --emp_04 -> 03으로 바꾸기
SELECT /*+ INDEX (emp idx_emp_03) */ * --'+'가 힌트,띄어쓰기 조심,웬만하면 안쓰는게 좋다.
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


