SELECT ename,sal,deptno,
RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_rank,
DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal) sal_DENSE_RANK,
ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal) sal_ROW_NUMBER
FROM emp;

--RANK() : 1���� �θ��̸� ���� ������ 3��
--DENSE_RANK() :1���� �θ��̸� ���� ������ 2��
--ROW_NUMBER() : ���ϰ��̶� ������ ������ �ο� (�ߺ�X)

--no_ana1
SELECT empno, ename, sal , deptno, 
RANK() OVER(ORDER BY sal desc ,empno) sal_rank,
DENSE_RANK() OVER(ORDER BY sal desc,empno) sal_dense_NUMBER,
ROW_NUMBER() OVER(ORDER BY sal desc,empno) sal_ROW_NUMBER
FROM emp;

--no_ana2 �м��Լ� ���x
SELECT empno, ename, a.deptno, a.cnt
FROM emp,
(SELECT deptno,COUNT(*) cnt
FROM emp
GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY deptno;

--�м��Լ� ���
SELECT empno, ename, deptno, 
COUNT(*) over(PARTITION BY deptno) cnt
FROM emp;

--�μ��� ����� �޿��հ�
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

--�׷쳻 �����
--�μ��� �����ȣ�� ���� ������� ((lastvalue�� ����
SELECT empno, ename, deptno, 
FIRST_VALUE(empno) OVER(PARTITION BY deptno ORDER BY empno) f_emp
FROM emp;

--LAG(������)
--������
--LEAD(������)
--�޿��� ���������� ���������� �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�,
--                          �ڱ⺸�� �Ѵܰ� �޿��� ���� ����� �޿�
SELECT empno, ename, hiredate, sal,
LEAD(sal) OVER(ORDER BY sal desc, hiredate) lead_sal,
LAG(sal) OVER(ORDER BY sal desc, hiredate) lag_sal
FROM emp;

--ana5 ����
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
--UNBOUNDED PRECEDING : ���� ���� �������� �����ϴ� ��� ��
--CURRENT ROW : ���� ��
--UNBOUNDED FOLLOWING : ���� ���� �������� �����ϴ� ��� ��
--N(����) PRECEDING : ���� ���� �������� �����ϴ� N���� ��
--N(����) FOLLOWING : ���� ���� �������� �����ϴ� N���� ��

SELECT empno, ename, sal, 
SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_sal1,

SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) sum_sal2,

SUM(sal) OVER(ORDER BY sal, empno 
ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) sum_sal3 --�յ� ���྿ ���ϴ°�

FROM emp;

--ana7
SELECT empno, ename, deptno, sal,
SUM(sal) OVER(PARTITION BY deptno ORDER BY sal, empno
ROWS UNBOUNDED PRECEDING ) c_sum
FROM emp;

--ROWS VS RANGE
--RANGE�� �������� �ϳ��� ������ ����.
--ROWS�� BETWEEN�� �����ʾƵ� �ڱ������ ������ �Ǿ ���� ����� ���´�.
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

