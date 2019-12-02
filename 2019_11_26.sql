SELECT ename,sal,deptno,
RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_rank,
DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_DENSE_RANK,
ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) sal_ROW_NUMBER
FROM emp;

--RANK() : 1등이 두명이면 다음 순위는 3등
--DENSE_RANK() :1등이 두명이면 다음 순위는 2등
--ROW_NUMBER() : 동일값이라도 별도의 순위를 부여 (중복X)

--no_ana1
SELECT empno, ename, sal , deptno, 
RANK() OVER(ORDER BY sal desc ,empno) sal_rank,
DENSE_RANK() OVER(ORDER BY sal desc,empno) sal_dense_NUMBER,
ROW_NUMBER() OVER(ORDER BY sal desc,empno) sal_ROW_NUMBER
FROM emp;

--no_ana2 분석함수 사용x
SELECT empno, ename, a.deptno, a.cnt
FROM emp,
(SELECT deptno,COUNT(*) cnt
FROM emp
GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY deptno;

--분석함수 사용
SELECT empno, ename, deptno, 
COUNT(*) over(PARTITION BY deptno) cnt
FROM emp;

--부서별 사원의 급여합계
--sum
SELECT empno, ename, deptno, sal,
SUM(sal) over(PARTITION BY deptno) sum
FROM emp;

--ana2
SELECT empno,ename,sal,deptno,
ROUND(AVG(sal) over(PARTITION BY deptno),2) cnt
FROM emp;

--ana3
SELECT empno,ename,sal,deptno,
MAX(sal) over(PARTITION BY deptno) max_sal
FROM emp;

--ana4
SELECT empno,ename,sal,deptno,
MIN(sal) over(PARTITION BY deptno) min_sal
FROM emp;

--그룹내 행순서
--부서별 사원번호가 가장 빠른사람 ((lastvalue는 보류
SELECT empno, ename, deptno, 
FIRST_VALUE(empno) OVER(PARTITION BY deptno ORDER BY empno) f_emp
FROM emp;

--LAG(이전행)
--현재행
--LEAD(다음행)
--급여가 높은순으로 정렬했을때 자기보다 한단계 급여가 낮은 사람의 급여,
--                          자기보다 한단계 급여가 높은 사람의 급여
SELECT empno, ename, hiredate, sal,
LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal,
LAG(sal) OVER(ORDER BY sal desc, hiredate) lag_sal
FROM emp;

--ana5 높은
SELECT empno, ename, hiredate , sal,
LEAD(sal) OVER(ORDER BY sal, hiredate) lead_sal
FROM emp;

SELECT empno, ename, hiredate , sal,
LAG(sal) OVER(ORDER BY sal desc, hiredate) lag_sal
FROM emp;

--ana6
SELECT empno, ename, hiredate, job, sal,
LAG(sal)OVER(PARTITION BY job ORDER BY sal desc ,hiredate) LAG_SAL 
FROM emp;

--no_ana3
SELECT  a.empno, a.ename, a.sal, sum(b.sal) sal_sum
FROM
    (SELECT a.*, ROWNUM rn
        FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)a,
     (SELECT a.*, ROWNUM rn
         FROM 
        (SELECT empno, ename, sal
        FROM emp
        ORDER BY sal)a)b
WHERE a.rn>=b.rn
GROUP BY a.empno, a.ename, a.sal
ORDER BY a.sal, a.empno;
       
select empno, ename, deptno,sal ,
sum(sal) over(order by sal
rows between unbounded preceding and current row)
c_sum
from emp;



--WINDOWING
--UNBOUNDED PRECEDING : 현재 행을 기준으로 선행하는 모든 행
--CURRENT ROW : 현재 행
--UNBOUNDED FOLLOWING : 현재 행을 기준으로 후행하는 모든 행
--N(정수) PRECEDING : 현재 행을 기준으로 선행하는 N개의 행
--N(정수) FOLLOWING : 현재 행을 기준으로 후행하는 N개의 행

SELECT empno, ename, sal, 
SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal1,

SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,

SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 --앞뒤 한행씩 더하는것

FROM emp;

--ana7
SELECT empno, ename, deptno, sal,
SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno
ROWS UNBOUNDED PRECEDING ) c_sum
FROM emp;

--ROWS VS RANGE
--RANGE는 같은값을 하나의 행으로 본다.
--ROWS는 BETWEEN을 쓰지않아도 자기행까지 기준이 되어서 같은 결과가 나온다.
SELECT empno, ename, deptno, sal,
SUM(sal) OVER(ORDER BY sal 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) row_sum,
SUM(sal) OVER(ORDER BY sal 
            ROWS UNBOUNDED PRECEDING) row_sum2,
SUM(sal) OVER(ORDER BY sal 
            RANGE BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) range_sum,
SUM(sal) OVER(ORDER BY sal 
            RANGE UNBOUNDED PRECEDING) range_sum2            
FROM emp;

