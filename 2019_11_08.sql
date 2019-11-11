--조인복습
--조인 왜??
--RDMS의 특성상 데이터의 중복을 최대 배제한 설계를 한다.
--EMP테이블에는 직원의 정보가 존재, 해당 직원의 소속 부서정보는
--부서번호만 갖고있고, 부서번호를 통해 dept 테이블과 조인을 통해
--해당 부서의 정보를 가져올 수 있다.

--직원번호, 직원이름, 직원의 소속 부서번호, 부서이름
--emp, dept

SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--부서번호, 부서명, 해당부서의 인원수
SELECT dept.deptno, dname, COUNT(*) cnt
FROM emp JOIN dept ON (emp.deptno =dept.deptno)
GROUP BY dept.deptno, dname;

SELECT deptno, dname, COUNT(*) cnt
FROM emp JOIN dept USING (deptno)
GROUP BY deptno, dname;

--TOTAL ROW :14
--널값은 count되지 않는다.
SELECT count(*), count(empno), count(mgr), count(comm)
FROM emp;

--OUTER JOIN : 조인에 실패도 기준이 되는 테이블의 데이터는 조회결과가 나오도록 하는 형태
--LEFT OUTER JOIN : JOIN KEYWORD 왼쪽에 위치한 테이블이 조회 기준이 되도록하는 형태
--RIGHT도 마찬가지
--FULL OUTER JOIN : LEFT + RIGHT - 중복제거

--직원 정보와 해당 직원의 관리자정보 OUTER JOIN
--직원 번호, 이름, 관리자 번호, 이름
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--oracle outer join ( left, right만 존재 fullouter는 지원하지 않음)
--left outer join 
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--그냥조인
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno; 


--ANSI LEFT OUTER????
SELECT a.empno, a.ename, a.mgr, a.ename--????
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- 아래 두개의 쿼리는 on절에 기술되면 조인 조건, where절은 join이 끝난후 제거조건이므로 결과가 다르다.
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename,b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno )
WHERE b.deptno = 10;

--oracle outer문법에서는 outer테이블이 되는 모든 컬럼에 (+)를 붙여줘야
--outer join이 정상적으로 동작한다.
SELECT a.empno, a.ename, b.empno, b.ename
FROM emp a , emp b
WHERE a.mgr = b.empno(+)
AND b.deptno(+) = 10;

--ANSI RIGHT OUTER
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a RIGHT OUTER JOIN emp b ON (a.mgr = b.empno);


--outerjoin1
SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON buyprod.BUY_PROD = prod.prod_id 
AND buy_date = TO_DATE('05/01/25','YY/MM/DD');

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod , buyprod
WHERE buyprod.BUY_PROD(+) = prod.prod_id 
AND buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');
--BUY_DATE는 타입이 DATE라서 TO_CHAR적용안됨. 날짜는 웬만하면 TO_DATE쓰기

--outerjoin2
SELECT nvl(buy_date,TO_DATE('05/01/25','YY/MM/DD')) buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod , buyprod
WHERE buyprod.BUY_PROD(+) = prod.prod_id 
AND buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');

SELECT nvl(buy_date,'05/01/25') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.BUY_PROD = prod.prod_id 
AND buy_date = TO_DATE('05/01/25','YY/MM/DD'));

SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM prod LEFT OUTER JOIN buyprod ON (buyprod.BUY_PROD = prod.prod_id 
AND buy_date = TO_DATE('05/01/25','YY/MM/DD'));

--outerjoin3
SELECT nvl(buy_date,'05/01/25') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty,0)
FROM prod , buyprod
WHERE buyprod.BUY_PROD(+) = prod.prod_id 
AND buy_date(+) = TO_DATE('05/01/25','YY/MM/DD');

SELECT TO_DATE('05/01/25','YY/MM/DD') buy_date, buy_prod, prod_id, prod_name, nvl(buy_qty,0)
FROM prod LEFT OUTER JOIN buyprod ON buyprod.BUY_PROD = prod.prod_id 
AND buy_date = TO_DATE('05/01/25','YY/MM/DD');

--outerjoin4
SELECT product.pid,pnm,NVL(cid,1) cid,NVL(day,0) day,NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON product.pid = cycle.pid AND cid = 1;

SELECT product.pid,pnm,NVL(cid,1) cid,NVL(day,0) day,NVL(cnt,0) cnt
FROM product ,cycle 
WHERE product.pid = cycle.pid(+) AND cid(+) = 1;

--outerjoin5
SELECT product.pid,pnm,NVL(cycle.cid,1) cid, NVL(cnm,'brown') cnm,NVL(day,0) day,NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON product.pid = cycle.pid AND cid = 1 
LEFT OUTER JOIN customer  ON cycle.cid = customer.cid
ORDER BY product.pid desc ,day desc;

--oracle
SELECT product.pid,pnm,NVL(cycle.cid,1) cid, NVL(cnm,'brown') cnm,NVL(day,0) day,NVL(cnt,0) cnt
FROM product , cycle , customer
WHERE product.pid = cycle.pid(+) AND cycle.cid(+) = 1 
AND cycle.cid = customer.cid(+)
ORDER BY product.pid desc ,day desc;

--인라인뷰
SELECT a.pid, a.pnm, a.cid, NVL(cnm,'brown') cnm,a.day, a.cnt
FROM
(SELECT product.pid pid, pnm, NVL(cycle.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON product.pid = cycle.pid AND cid = 1) a
LEFT OUTER JOIN customer on a.cid = customer.cid
ORDER BY a.pid desc , a.day desc;

--쌤
SELECT  a.pid, a.pnm, a.cid, c.cnm, a.day, a.cnt
FROM
(SELECT b.pid, b.pnm, 1 cid, nvl(a.day,0) day, nvl(a.cnt, 0) cnt
FROM cycle a, product b
where a.pid(+) = b.pid
and a.cid(+) =1) a, customer c
where a.cid = c.cid;

--crossjoin1
SELECT *
FROM customer CROSS JOIN product;

--subquery : main쿼리에 속하는 부분 쿼리
--사용되는 위치
--select : scalar subquery(하나의 행과 하나의 컬럼만 조회되는 쿼리이어야 한다.)
--from : inline view
--where : subquery

--scalar subquery
SELECT empno, ename, sysdate now /*현재날짜*/ 
FROM emp;

SELECT empno, ename, (SELECT sysdate FROM dual) now
FROM emp;

--1)
SELECT deptno --20
FROM emp
WHERE ename ='SMITH';
--2)
SELECT *
FROM emp
WHERE deptno = 20;
--1과 2의 합)
SELECT *
FROM emp
WHERE deptno =(SELECT deptno --20
                FROM emp
                WHERE ename ='SMITH');


--sub1
SELECT count(*)
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);

--sub2
SELECT *
FROM emp
WHERE sal > (SELECT AVG(sal) FROM emp);

