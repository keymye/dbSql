--�׷��Լ�
--multi row function : �������� ���� �Է����� �ϳ��� ��� ���� ����
--SUM, MAX, MIN, AVG, COUNT
--GROUP BY col | express
--SELECT ������ GROUP BY���� ����� COL,EXPRESSǥ�� ����

--������ ���� ���� �޿� ��ȸ
--14���� ���� �Է����� �� �ϳ��� ����� ����
SELECT MAX(sal) max_sal
FROM emp;

--�μ����� ���� ���� �޿� ��ȸ
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
--emp���̺��� dname�÷��� ����. --> �μ���ȣ(deptno)�ۿ� ����
ALTER TABLE emp ADD(dname VARCHAR2(14));
-->emp���̺� �μ��̸��� ������ �� �ִ� dname�÷� �߰�

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

--ansi natural join : �����ϴ� ���̺��� �÷����� ���� �÷��� �������� JOIN
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

--from ���� ���� ��� ���̺� ����
--where���� �������� ���
--������ ����ϴ� ���� ���൵ �������
SELECT emp.empno, emp.ename, dept.dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.job='SALESMAN';

SELECT emp.empno,  emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno
AND emp.job='SALESMAN');
--job�� SALESMAN�� ����� ������� ��ȸ

--JOIN with ON(�����ڰ� ���� �÷��� ON���� ���� ���)
SELECT emp.empno, emp.ename, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

--SELF join : ���� ���̺��� ����
--emp���̺��� mgr������ �����ϱ� ���ؼ� emp���̺�� ������ �ؾ��Ѵ�.
--a: ��������, b: ������
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a JOIN emp b ON(a.mgr = b.empno)
WHERE a.empno BETWEEN 7369 AND 7698;

--oracle
SELECT a.empno, a.ename, a.mgr, b.empno, b.ename
FROM emp a , emp b
WHERE a.mgr = b.empno AND (a.empno BETWEEN 7369 AND 7698);

--non-equi joing (��� ������ �ƴѰ��)
SELECT *
FROM salgrade;

--������ �޿� �����?
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
--��� ����� ���� ���´�.


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



