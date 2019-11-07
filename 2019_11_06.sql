--그룹함수
--multi row function : 여러개의 행을 입력으로 하나의 결과 행을 생성
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT 절에는 GROUP BY절에 기술된 COL,EXPRESS표기 가능

--직원중 가장 높은 급여 조회
--14개의 행이 입력으로 들어가 하나의 결과가 도출
SELECT MAX(sal) max_sal
FROM emp;

--부서별로 가장 높은 급여 조회
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno;

--grp5
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyy, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY');

--grp6
SELECT COUNT(deptno) cnt
FROM dept;

SELECT COUNT(distinct deptno) CNT
FROM emp;

--JOIN
--emp테이블에는 dname컬럼이 없다. --> 부서번호(deptno)밖에 없음
ALTER TABLE emp ADD(dname VARCHAR2(14));
-->emp테이블에 부서이름을 저장할 수 있는 dname컬럼 추가

SELECT *
FROM emp;

UPDATE emp SET dname ='ACCOUNTING' WHERE DEPTNO = 10;
UPDATE emp SET dname ='RESEARCH' WHERE DEPTNO = 20;
UPDATE emp SET dname ='SALES' WHERE DEPTNO = 30;
COMMIT;


SELECT dname, MAX(sal) max_sal
FROM emp
GROUP BY dname;

ALTER TABLE emp DROP column dname;

SELECT *
FROM emp;

--ansi natural join : 조인하는 테이블의 컬럼명이 같은 컬럼을 기준으로 JOIN
SELECT DEPTNO, ENAME,DNAME 
FROM emp NATURAL JOIN dept;

--ORACLE join
SELECT emp.empno, emp.ename, emp.deptno, dept.dname, dept.loc
FROM emp,dept
WHERE emp.deptno = dept.deptno;

SELECT e.empno, e.ename, e.deptno, d.dname, d.loc
FROM emp e,dept d
WHERE e.deptno = d.deptno;

--ANSI JOIN WITH USING
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept USING(deptno);

--from 절에 조인 대상 테이블 나열
--where절에 조인조건 기술
--기존에 사용하던 조건 제약도 기술가능
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job='SALESMAN';

SELECT emp.empno,  emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno
AND emp.job='SALESMAN');
--job이 SALESMAN인 사람만 대상으로 조회

--JOIN with ON(개발자가 조인 컬럼을 ON절에 직접 기술)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--SELF join : 같은 테이블끼리 조인
--emp테이블의 mgr정보를 참고하기 위해서 emp테이블과 조인을 해야한다.
--a: 직원정보, b: 관리자
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a , emp b
WHERE a.mgr = b.empno AND (a.empno BETWEEN 7369 AND 7698);

--non-equi joing (등식 조인이 아닌경우)
SELECT *
FROM salgrade;

--직원의 급여 등급은?
SELECT empno, ename, sal
FROM emp;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT emp.empno, emp.ename, emp.sal, salgrade.*
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal);

--non equi joing
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a , emp b
WHERE a.mgr = b.empno
--WHERE a.mgr != b.empno
AND a.empno = 7369;

SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno AND a.empno = 7369);

SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno = 7369;


SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a , emp b
WHERE a.empno = 7369; 
--모든 경우의 수가 나온다.


--JOIN0
SELECT empno, ename, deptno, dname
FROM emp natural join dept
ORDER BY dname;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept USING(deptno)
ORDER BY deptno;

SELECT emp.empno, emp.ename, emp.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno=dept.deptno)
ORDER BY dname;


--JOIN0_1
SELECT empno , ename, deptno, dname
FROM emp natural join dept
WHERE deptno in(10,30);

SELECT empno, ename, emp.deptno,dname
FROM emp JOIN dept ON emp.deptno=dept.deptno and emp.deptno IN(10,30);

SELECT empno, ename, deptno,dname
FROM emp JOIN dept USING(deptno)
WHERE deptno = 10 OR deptno =30;

--JOIN0_2
SELECT empno , ename, sal, deptno, dname
FROM emp natural join dept
WHERE sal > 2500
ORDER BY deptno;

SELECT empno , ename, sal, dept.deptno, dname
FROM emp JOIN dept ON emp.deptno = dept.deptno AND sal > 2500
ORDER BY deptno;

SELECT empno , ename, sal,deptno, dname
FROM emp JOIN dept USING(deptno)
WHERE sal > 2500
ORDER BY deptno;

--JOIN0_3
SELECT empno , ename, sal, deptno, dname
FROM emp natural join dept
WHERE sal > 2500 and empno > 7600
ORDER BY deptno;

SELECT empno , ename, sal, dept.deptno, dname
FROM emp JOIN dept ON (sal > 2500 and empno > 7600 and emp.deptno = dept.deptno)
ORDER BY deptno;

SELECT empno , ename, sal, deptno, dname
FROM emp JOIN dept USING(deptno)
WHERE sal > 2500 and empno > 7600
ORDER BY deptno;

--JOIN0_4
SELECT empno , ename, sal, deptno, dname
FROM emp natural join dept
WHERE sal > 2500 and empno > 7600 and dname = 'RESEARCH'
ORDER BY deptno;

SELECT empno , ename, sal, dept.deptno, dname
FROM emp JOIN dept ON(sal > 2500 and empno > 7600 )
WHERE dname = 'RESEARCH' and emp.deptno = dept.deptno
ORDER BY deptno;

SELECT empno , ename, sal, deptno, dname
FROM emp JOIN dept USING(deptno)
WHERE dname = 'RESEARCH' and sal > 2500 and empno > 7600
ORDER BY deptno;

--join1
SELECT lprod_gu, lprod_nm, prod_id, prod_name
FROM prod JOIN lprod ON(lprod_gu = prod_lgu);



