-- GROUPING(cube, rollup절에 사용된 컬럼)
-- 해당 컬럼이 소계 계산에 사용된 경우 1 , 
-- 사용되지 않은 경우 0

--job컬럼
--group_ad2
--case1. GROUPING(job)=1 and GROUPING(deptno)=1
--      job --> '총계'
--case else 
--      job --> job
SELECT 
    CASE WHEN GROUPING( job) =1 AND GROUPING(deptno)=1
        THEN '총계'
        ELSE job
    END job, deptno,
    GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--group_ad2 심화
SELECT 
    CASE WHEN GROUPING( job) =1 AND GROUPING(deptno)=1
        THEN '총계'
        ELSE job
    END job, 
    CASE WHEN GROUPING(deptno) =1 AND GROUPING(job) = 0
         THEN job || ' 소계'
         ELSE TO_CHAR(deptno)
    END deptno,
GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--group_ad3
SELECT deptno,job,sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--group_ad4
SELECT dname, job, sum(sal) sal
FROM dept a, emp b
WHERE a.deptno = b.deptno
GROUP BY ROLLUP(dname,job)
ORDER BY dname ,sal desc;

--group_ad5
SELECT 
    CASE WHEN GROUPING(dname)=1
    THEN '총합'
    ELSE dname
    END dname, job, sum(sal) sal
FROM dept a, emp b
WHERE a.deptno = b.deptno
GROUP BY ROLLUP(dname,job)
ORDER BY dname ,sal desc;


--CUBE(col1, col2...)
--CUBE절에 나열된 컬럼의 가능한 모든 조합에 대해 서브그룹으로 생성
--CUBE에 나열된 컬럼에 대해 방향성은 없다.(ROLLUP과의 차이)
--GROUP BY CUBE(job, deptno)
--00: GROUP BY job, deptno
--0X: GROUP BY job
--XO: GROUP BY deptno
--XX: GROUP BY --모든 데이터에 대해서

--GROUP BY CUBE(job, deptno, mgr)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);


--subquery를 통한 업데이트
--advanced
--emp테이블의 데이터를 포함해서 모든 컬럼을 이용하여 emp_test테이블로 생성
CREATE TABLE emp_test AS
SELECT * 
FROM emp;

select * from emp_test;

--dept테이블에서 관리되고 있는 dname(VARCHAR2(14)) 컬럼추가
desc dept;
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

--subquery를 이용하여 dept테이블의 dname 컬럼을 업데이트
UPDATE emp_test 
SET dname =(SELECT dname 
            FROM dept
            WHERE emp_test.deptno = dept.deptno);

commit;
--조건 더 추가 가능 WHERE  empno IN (7369,7499)  
 
--실습sub_a1           
CREATE TABLE dept_test AS
SELECT *
FROM dept; 

ALTER TABLE dept_test ADD (empcnt number);
UPDATE dept_test 
SET empcnt = (SELECT COUNT(*)
            FROM emp 
            WHERE dept_test.deptno = emp.deptno);
select *from dept_test;
--sub_a2
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept; 

INSERT INTO dept_test values(99,'it1','daejeon');
INSERT INTO dept_test values(98,'it2','daejeon');
DELETE dept_test 
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
                
DELETE dept_test 
WHERE NOT EXISTS (SELECT 'X' 
                    FROM emp 
                  WHERE emp.deptno = dept_test.deptno);

select * from dept_test;

--다시보기
DELETE dept_test
WHERE empcnt not in (SELECT COUNT(*) 
                    FROM emp 
                    WHERE emp.deptno = dept_test.deptno
                    group by deptno);
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

--sub_a3
DROP TABLE emp_test;
CREATE TABLE emp_test AS
SELECT *
FROM emp; 

ALTER TABLE emp_test ADD (dname VARCHAR(14));

UPDATE emp_test a SET sal = sal+200
WHERE sal < 
    (SELECT AVG(sal) 
    FROM emp_test b
    WHERE b.deptno = a.deptno);

--emp,emp_test empno컬럼으로 같은 값끼리 조회
--1.emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno , emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal, 해당사원(emp테이블 기준)이 속한 부서의 급여평균
SELECT a.empno, a.ename, a.sal1, a.sal2, b.avg 
FROM
(SELECT emp_test.deptno as deptno,emp.empno empno, emp.ename ename, emp.sal sal1, emp_test.sal sal2
FROM emp, emp_test
WHERE emp.empno = emp_test.empno) a
JOIN 
(SELECT deptno , round(avg(sal),0) avg
FROM emp
group by deptno) b
ON(a.deptno  = b.deptno);







select * from emp_test;