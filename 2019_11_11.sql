--sub3
SELECT *
FROM emp
WHERE deptno IN ((SELECT deptno
                FROM emp
                WHERE ename IN ('SMITH','WARD')))
ORDER BY empno desc;

SELECT *
FROM emp
WHERE deptno IN ((SELECT deptno
                FROM emp
                WHERE ename IN (:name1,:name2)))
ORDER BY empno desc;

--ANY: set중에 만족하는게 하나라도 있으면 참으로(크기비교)
--SMITH, WARD 두사람의 급여보다 적은 급여를 받는 직원 정보 조회

SELECT *
FROM emp
WHERE sal < any (SELECT sal --800,1250
                FROM emp
                WHERE ename IN ('SMITH','WARD'));

--smith와 ward보다 급여가 높은 직원 조회
--smith보다도 급여가 높고 ward보다도 급여가 높은 사람(and)
SELECT *
FROM emp
WHERE sal > all (SELECT sal --800,1250
                FROM emp
                WHERE ename IN ('SMITH','WARD'));
              
                
--NOT IN

--관리자의 직원정보
--1.관리자인 사람만 조회
--mgr 컬럼에 값이 나오는 직원
SELECT distinct mgr FROM emp ORDER BY mgr;

--어떤 직원의 관리자 역할을 하는 직원정보 조회
--단 NOT IN 연산자 사용시 SET에 NULL이 포함될 경우 정상적으로 동작하지 않는다.
--NULL처리 함수나 WHERE절을 통해 NULL값을 처리한 이후 사용
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr FROM emp WHERE mgr IS NOT NULL); --서브쿼리 결과에 null이 존재할 경우 값이 안나오는게 정상
                                
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,-9999) FROM emp);    
                
--pair wise
--사번 7499, 7782인 직원의 관리자, 부서번호 조회
--7698 30
--7839 10
--직원중에 관리자와 부서번호가 7698,30이거나 7839,10인 사람
--mgr, deptno 컬럼을 [동시]에 만족시키는 직원정보 조회
SELECT mgr, deptno FROM emp WHERE empno IN(7499,7782);

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno FROM emp WHERE empno IN(7499,7782));                
                
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr FROM emp WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno FROM emp WHERE empno IN(7499,7782)); --위와 달리 동시에 만족하지 않아도 된다.
                
--SCALAR SUBQUERY : SELECT절에 등장하는 서브 쿼리(단 값이 하나의 행, 하나의 컬럼)
--직원의 소속 부서명을 JOIN을 사용하지 않고 조회
SELECT empno, ename, deptno, (SELECT dname
                                FROM dept
                                WHERE deptno = emp.deptno) dname
FROM emp;

--sub4 데이터 생성
INSERT INTO dept values(99,'ddit','daejeon');
commit;

SELECT * FROM dept
WHERE deptno NOT IN (SELECT deptno FROM emp);
   
--sub5
SELECT distinct pid, pnm
FROM product 
WHERE pid NOT IN (SELECT pid FROM cycle WHERE cid=1);

--sub6
SELECT  *
FROM cycle
WHERE cid = 1 and pid in
(SELECT pid FROM cycle WHERE cid=2);
    
--sub7
SELECT a.cid, cnm, a.pid, pnm,a.day, a.cnt
FROM customer JOIN
(SELECT  *
FROM cycle
WHERE cid = 1 and pid in
(SELECT pid FROM cycle WHERE cid=2)) a ON (a.cid=customer.cid) 
JOIN product ON (a.pid=product.pid); 

SELECT cycle.cid, customer.cnm,product.pid,product.PNM,day,cnt
FROM customer,cycle,product
WHERE cycle.cid = 1 and customer.cid = cycle.cid and cycle.pid = product.pid 
and product.pid in(SELECT pid 
                    FROM cycle 
                    WHERE cid=2);
                    
               
--EXISTS MAIN쿼리의 컬럼을 사용해서 SUBQUERY에 만족하는 조건이 있는지 체크
--만족하는 값이 하나라도 존재하면 더이상 진행하지 않고 멈추기 때문에 성능면에서 유리

--MGR가 존재하는 직원 조회
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);
               
--MGR가 존재하지 않는 직원 조회
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);               
                    
--sub8 MGR가 존재하는 직원 조회 (서브쿼리 쓰지않고!)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--부서에 소속된 직원이 있는 부서 정보 조회(EXISTS)
SELECT *
FROM dept
WHERE deptno IN (10,20,30);

SELECT *
FROM dept
WHERE EXISTS(SELECT 'X' FROM emp WHERE dept.deptno = deptno);

--in 
SELECT *
FROM dept
WHERE deptno in (SELECT deptno FROM emp);    

--sub9

--집합연산
--사번이 7566 or 7698인 사원 조회(사번이랑 이름)
SELECT empno, ename
FROM emp
WHERE empno = 7566 or empno=7698

--UNION : 합집합,중복제거
--       DBMS에서는 중복을 제거하기 위해 데이터를 정렬
--      (대량의 데이터에 대해 정렬시 부하)
--UNION ALL : 중복제거 X, 위아래 집합에 중복되는 데이터가 없다는 것을 확신하면 UNION연산자보다 성능면에서 유리

--UNION
UNION ALL--합집합,중복
--사번이 7369,7499인 사원 조회(사번,이름)
SELECT empno, ename 
FROM emp
WHERE empno = 7566 or empno=7698; --중복제거
--WHERE empno =7369 OR empno=7499;


--INTERSECT
--사번이 7566 or 7698인 사원 조회(사번이랑 이름)
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(차집합: 위 집합에서 아래 집합을 제거)
--순서가 존재
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);


SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499)
MINUS
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369);

SELECT 1 n, 'x' m
FROM dual
union
SELECT 2, 'y' --컬럼명이 달라도 된다.
FROM dual
ORDER BY m desc;--정렬은 마지막에
