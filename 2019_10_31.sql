--테이블에서 데이터 조회
/*
    SELECT 컬럼 | express(문자열 상수) [as] 별칭
    FROM 데이터를 조회할 테이블(VIEW)
    WHERE 조건 (condition)
*/

DESC user_tables;

--SELECT table_name,
--'SELECT * FROM ' || table_name || ';' AS select_query
--FROM user_tables
--WHERE TABLE_NAME != 'EMP';

--숫자비교 연산
--보통 숫자형은 오른쪽 정렬, 문자형은 왼쪽 정렬
--부서번호가 30번보다 크거나 같은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno >= 30;

--부서번호가 30번보다 작은 부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno < 30;

--입사일자가 1982년 1월 1일 이후인 직원 조회
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
--WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');
WHERE hiredate >= TO_DATE('01011982','MMDDYYYY');

-- col BETWEEN X AND Y 연산
-- 컬럼의 값이 X보다 크거나 같고, Y보다 작거나 같은 데이터
-- 급여(sal)가 1000보다 크거나 같고, 2000보다 작거나 같은 데이터 조회
SELECT *
FROM emp
WHERE sal between 1000 and 2000;


--위의 BETWEEN AND 연산자는 아래의 <= , >= 조합과 같다.
SELECT *
FROM emp
WHERE sal >= 1000 and sal <= 2000 and deptno = 30;

--실습1
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101','YYYYMMDD') and  TO_DATE('19830101','YYYYMMDD');

--실습2
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') and hiredate <= TO_DATE('19830101','YYYYMMDD');

--IN 연산자
-- COL IN(values...)
--부서번호가 10 혹은 20인 직원 조회
SELECT *
FROM emp
WHERE deptno in (10,20);

--IN 연산자는 OR연산자로 표현할 수 있다.
SELECT *
FROM emp
WHERE deptno =10 OR deptno =20;

--실습3
SELECT userid 아이디, usernm 이름, filename 별명
FROM users
WHERE userid in ('brown', 'cony', 'sally');

--COL LIKE 'S%'
--COL의 값이 대문자 S로 시작하는 모든 값
--COL LIKE 'S____'
--COL의 값이 대문자 S로 시작하고 이어서 4개의 문자열이 존재하는 값

SELECT *
FROM emp
WHERE ename LIKE 'S%';

--실습4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

--실습5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

--NULL비교
--col IS NULL
--EMP테이블에서 MGR 정보가 없는 사람(NULL) 조회
SELECT *
FROM emp
WHERE mgr IS NULL;

--소속 부서가 10번이 아닌 직원들
SELECT *
FROM emp
WHERE deptno != '10';

-- = , !=
-- is null , is not null
--실습6
SELECT *
FROM emp
WHERE COMM IS NOT NULL;

--AND / OR
SELECT *
FROM emp
WHERE mgr = 7698 AND sal >= 1000;

SELECT*
FROM emp
WHERE mgr = 7698 OR sal >= 1000;

--emp테이블에서 관리자(mgr) 사번이 7698이 아니고, 7839가 아닌 직원들 조회
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839);

--위의 쿼리를 AND/OR 연산자로 변환
SELECT *
FROM emp
WHERE mgr !=7698 AND mgr != 7839;

--IN, NOT IN 연산자의 NULL처리
--IN 연산자에서 결과값에 NULL이 있을 경우 의도하지 않은 동작을 한다.
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839) AND mgr IS NOT NULL;


--실습7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--실습8
SELECT *
FROM emp
WHERE deptno != 10 and hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');


--실습9
SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--실습10
SELECT *
FROM emp
WHERE deptno IN(20,30) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--실습11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--실습12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

--실습13(LIKE사용X)
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno =78 OR (empno BETWEEN 780 AND 789) OR  (empno BETWEEN 7800 AND 7899);

--실습14
SELECT *
FROM emp
WHERE (job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') )
OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));

