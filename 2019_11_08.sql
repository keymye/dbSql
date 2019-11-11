--���κ���
--���� ��??
--RDMS�� Ư���� �������� �ߺ��� �ִ� ������ ���踦 �Ѵ�.
--EMP���̺��� ������ ������ ����, �ش� ������ �Ҽ� �μ�������
--�μ���ȣ�� �����ְ�, �μ���ȣ�� ���� dept ���̺�� ������ ����
--�ش� �μ��� ������ ������ �� �ִ�.

--������ȣ, �����̸�, ������ �Ҽ� �μ���ȣ, �μ��̸�
--emp, dept

SELECT emp.empno, emp.ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno;

--�μ���ȣ, �μ���, �ش�μ��� �ο���
SELECT dept.deptno, dname, COUNT(*) cnt
FROM emp JOIN dept ON (emp.deptno =dept.deptno)
GROUP BY dept.deptno, dname;

SELECT deptno, dname, COUNT(*) cnt
FROM emp JOIN dept USING (deptno)
GROUP BY deptno, dname;

--TOTAL ROW :14
--�ΰ��� count���� �ʴ´�.
SELECT count(*), count(empno), count(mgr), count(comm)
FROM emp;

--OUTER JOIN : ���ο� ���е� ������ �Ǵ� ���̺��� �����ʹ� ��ȸ����� �������� �ϴ� ����
--LEFT OUTER JOIN : JOIN KEYWORD ���ʿ� ��ġ�� ���̺��� ��ȸ ������ �ǵ����ϴ� ����
--RIGHT�� ��������
--FULL OUTER JOIN : LEFT + RIGHT - �ߺ�����

--���� ������ �ش� ������ ���������� OUTER JOIN
--���� ��ȣ, �̸�, ������ ��ȣ, �̸�
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a JOIN emp b ON (a.mgr = b.empno);

--oracle outer join ( left, right�� ���� fullouter�� �������� ����)
--left outer join 
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno(+);

--�׳�����
SELECT a.empno, a.ename, a.mgr, b.ename
FROM emp a, emp b
WHERE a.mgr = b.empno; 


--ANSI LEFT OUTER????
SELECT a.empno, a.ename, a.mgr, a.ename--????
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno);

-- �Ʒ� �ΰ��� ������ on���� ����Ǹ� ���� ����, where���� join�� ������ ���������̹Ƿ� ����� �ٸ���.
SELECT a.empno, a.ename, a.mgr, b.ename, b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno AND b.deptno = 10);

SELECT a.empno, a.ename, a.mgr, b.ename,b.deptno
FROM emp a LEFT OUTER JOIN emp b ON (a.mgr = b.empno )
WHERE b.deptno = 10;

--oracle outer���������� outer���̺��� �Ǵ� ��� �÷��� (+)�� �ٿ����
--outer join�� ���������� �����Ѵ�.
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
--BUY_DATE�� Ÿ���� DATE�� TO_CHAR����ȵ�. ��¥�� �����ϸ� TO_DATE����

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

--�ζ��κ�
SELECT a.pid, a.pnm, a.cid, NVL(cnm,'brown') cnm,a.day, a.cnt
FROM
(SELECT product.pid pid, pnm, NVL(cycle.cid,1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON product.pid = cycle.pid AND cid = 1) a
LEFT OUTER JOIN customer on a.cid = customer.cid
ORDER BY a.pid desc , a.day desc;

--��
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

--subquery : main������ ���ϴ� �κ� ����
--���Ǵ� ��ġ
--select : scalar subquery(�ϳ��� ��� �ϳ��� �÷��� ��ȸ�Ǵ� �����̾�� �Ѵ�.)
--from : inline view
--where : subquery

--scalar subquery
SELECT empno, ename, sysdate now /*���糯¥*/ 
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
--1�� 2�� ��)
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

