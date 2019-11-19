--버거킹, 맥도날드, kfc개수
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, round(a.cnt/ b.cnt, 2) point
FROM(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE /* sido = '대전광역시' 
AND */ gb IN('버거킹','맥도날드','KFC')
GROUP BY sido, sigungu) a,
--롯데리아
(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE /* sido = '대전광역시' 
AND */ gb = '롯데리아'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido AND
a.sigungu = b.sigungu
ORDER BY point desc;


--시도, 시군구, 버거지수, 시도, 시군구, 연말정산 납입액
--서울시 중구 5.7 경기도 수원시 18623591 높은지수끼리 나오게

SELECT a.*, b.*
FROM
(SELECT a.* , rownum rn
FROM
(SELECT a.sido, a.sigungu,round(a.cnt/ b.cnt, 2) point
    FROM
        --140건
        (SELECT sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb IN('버거킹','맥도날드','KFC')
        GROUP BY sido, sigungu) a,
       
       --188건
        (SELECT sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb = '롯데리아'
        GROUP BY sido, sigungu) b
WHERE a.sido = b.sido 
AND a.sigungu = b.sigungu
ORDER BY point desc) a) a 
RIGHT OUTER JOIN
(SELECT b.* , rownum rn
FROM
    (SELECT sido, sigungu, sal
    FROM tax
    ORDER BY sal desc) b) b
ON (a.rn(+) = b.rn);


----------------------------------------------------------------
--EMP_TEST 테이블제거
DROP TABLE emp_test;

--multiple insert를 위한 테스트 테이블 생성
--empno, ename 두개의 컬럼을 갖는 emp_test, emp_test2 테이블을 
--emp테이블로 부터 생성한다.(CTAS)
--데이터는 복제하지 않는다.

CREATE TABLE emp_test AS
SELECT empno , ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno , ename
FROM emp
WHERE 1=2;

--INSERT ALL
--하나의 SQL구문으로 여러 테이블에 데이터를 입력
INSERT ALL 
    INTO emp_test 
    INTO emp_test2 
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--insert데이터 확인
SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--insert all 컬럼 정의
ROLLBACK;

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;


--multiple insert(conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE --조건을 통과하지 못할 때만 실행
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;


--insert first
--조건에 만족하는 첫번째 insert구문만 실행
ROLLBACK;
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN 
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual; --두 조건을 만족하지만 첫번째 조건만 실행

SELECT * FROM emp_test;
SELECT * FROM emp_test2;

rollback;
--merge : 조건에 만족하는 데이터가 있으면 update, 없으면 insert
--empno가 7369인 데이터를 emp테이블로부터 emp_test테이블에 복사(insert)
INSERT INTO emp_test
SELECT empno, ename 
FROM emp 
WHERE empno =7369;

SELECT * FROM emp_test;

--emp테이블의 데이터중 emp_test테이블의 empno와 같은 값을 갖는
--데이터가 있을 경우 emp_test.ename = ename || '_merge'값으로 update
--없을 경우 emp_test테이블에 insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));

MERGE INTO emp_test 
USING (SELECT empno, ename
        FROM emp
        WHERE emp.empno IN (7369,7499)) emp --2개행병합
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES(emp.empno, emp.ename);

rollback;
SELECT * FROM emp_test;

--다른 테이블을 통하지 않고 테이블 자체의 데이터 존재 유무로
--merge하는 경우
ROLLBACK;
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT empno , ename
FROM emp
WHERE 1=2;

INSERT INTO emp_test
SELECT empno, ename 
FROM emp 
WHERE empno =7369;

--empno = 1, ename= 'brown'
--empno가 같은 값이 있으면 ename을 'brown'으로 업데이트
--empno가 같은 값이 없으면 신규 insert
MERGE INTO emp_test
USING dual
    ON (emp_test.empno = 1) -- 이 컬럼은 업데이트 할 수 없다.
WHEN MATCHED THEN
    UPDATE SET ename='brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES(1, 'brown');

SELECT * FROM emp_test;
rollback;
--merge를 쓰지않을때
SELECT 'X'
FROM emp_test
WHERE empno= 1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno=1;

INSERT INTO emp_test VALUES(1,'brown');

--group_ad1 그룹별 합계, 전체합계를 다음과 같이 구하려면?
--row수를 늘릴때는 union 
SELECT deptno, sum(sal) 
FROM emp 
GROUP BY deptno
UNION ALL --컬럼갯수가 동일해야함
SELECT null,sum(sal)
FROM emp
ORDER BY deptno;

--위 쿼리를 rollup형태로 변경
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP(deptno);

--rollup
--group by의 서브 그룹을 생성
--GROUP BY ROLLUP({col,})
--컬럼을 오른쪽에서부터 제거해가면서 나온 서브그룹을
--GROUP BY하여 UNION한 것과 동일
--ex : GROUP BY ROLLUP(job,deptno)
--GROUP BY job,deptno
--UNION
--GROUP BY job
--UNION
--GROUP BY -->총계(모든 행에 대해 그룹함수 적용)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--GROUPING SETS(col1, col2...)
--GROUPING SETS의 나열된 항목이 하나의 서브그룹으로 GROUP BY절에 이용된다.

--GROUP BY col1
--union
--GROUP BY col2

--EMP테이블을 이용하여 부서별 급여합과 담당업무(JOB)별 급여합을 구하시오

--부서번호, job, 급여합계
SELECT deptno, null job ,sum(sal)
FROM emp
GROUP by deptno
UNION ALL
SELECT null, job, sum(sal)
FROM emp
GROUP by job;
--------
SELECT job,deptno, sum(sal)
FROM emp
GROUP BY grouping sets(job, deptno);
--------
SELECT job,deptno, sum(sal)
FROM emp
GROUP BY grouping sets(deptno,job,(deptno,job));


