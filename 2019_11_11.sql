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

--ANY: set�߿� �����ϴ°� �ϳ��� ������ ������(ũ���)
--SMITH, WARD �λ���� �޿����� ���� �޿��� �޴� ���� ���� ��ȸ

SELECT *
FROM emp
WHERE sal < any (SELECT sal --800,1250
                FROM emp
                WHERE ename IN ('SMITH','WARD'));

--smith�� ward���� �޿��� ���� ���� ��ȸ
--smith���ٵ� �޿��� ���� ward���ٵ� �޿��� ���� ���(and)
SELECT *
FROM emp
WHERE sal > all (SELECT sal --800,1250
                FROM emp
                WHERE ename IN ('SMITH','WARD'));
              
                
--NOT IN

--�������� ��������
--1.�������� ����� ��ȸ
--mgr �÷��� ���� ������ ����
SELECT distinct mgr FROM emp ORDER BY mgr;

--� ������ ������ ������ �ϴ� �������� ��ȸ
--�� NOT IN ������ ���� SET�� NULL�� ���Ե� ��� ���������� �������� �ʴ´�.
--NULLó�� �Լ��� WHERE���� ���� NULL���� ó���� ���� ���
SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr FROM emp WHERE mgr IS NOT NULL); --�������� ����� null�� ������ ��� ���� �ȳ����°� ����
                                
SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr,-9999) FROM emp);    
                
--pair wise
--��� 7499, 7782�� ������ ������, �μ���ȣ ��ȸ
--7698 30
--7839 10
--�����߿� �����ڿ� �μ���ȣ�� 7698,30�̰ų� 7839,10�� ���
--mgr, deptno �÷��� [����]�� ������Ű�� �������� ��ȸ
SELECT mgr, deptno FROM emp WHERE empno IN(7499,7782);

SELECT *
FROM emp
WHERE (mgr, deptno) IN (SELECT mgr, deptno FROM emp WHERE empno IN(7499,7782));                
                
SELECT *
FROM emp
WHERE mgr IN (SELECT mgr FROM emp WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno FROM emp WHERE empno IN(7499,7782)); --���� �޸� ���ÿ� �������� �ʾƵ� �ȴ�.
                
--SCALAR SUBQUERY : SELECT���� �����ϴ� ���� ����(�� ���� �ϳ��� ��, �ϳ��� �÷�)
--������ �Ҽ� �μ����� JOIN�� ������� �ʰ� ��ȸ
SELECT empno, ename, deptno, (SELECT dname
                                FROM dept
                                WHERE deptno = emp.deptno) dname
FROM emp;

--sub4 ������ ����
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
                    
               
--EXISTS MAIN������ �÷��� ����ؼ� SUBQUERY�� �����ϴ� ������ �ִ��� üũ
--�����ϴ� ���� �ϳ��� �����ϸ� ���̻� �������� �ʰ� ���߱� ������ ���ɸ鿡�� ����

--MGR�� �����ϴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);
               
--MGR�� �������� �ʴ� ���� ��ȸ
SELECT *
FROM emp a
WHERE NOT EXISTS (SELECT 'X' FROM emp WHERE empno = a.mgr);               
                    
--sub8 MGR�� �����ϴ� ���� ��ȸ (�������� �����ʰ�!)
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--�μ��� �Ҽӵ� ������ �ִ� �μ� ���� ��ȸ(EXISTS)
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

--���տ���
--����� 7566 or 7698�� ��� ��ȸ(����̶� �̸�)
SELECT empno, ename
FROM emp
WHERE empno = 7566 or empno=7698

--UNION : ������,�ߺ�����
--       DBMS������ �ߺ��� �����ϱ� ���� �����͸� ����
--      (�뷮�� �����Ϳ� ���� ���Ľ� ����)
--UNION ALL : �ߺ����� X, ���Ʒ� ���տ� �ߺ��Ǵ� �����Ͱ� ���ٴ� ���� Ȯ���ϸ� UNION�����ں��� ���ɸ鿡�� ����

--UNION
UNION ALL--������,�ߺ�
--����� 7369,7499�� ��� ��ȸ(���,�̸�)
SELECT empno, ename 
FROM emp
WHERE empno = 7566 or empno=7698; --�ߺ�����
--WHERE empno =7369 OR empno=7499;


--INTERSECT
--����� 7566 or 7698�� ��� ��ȸ(����̶� �̸�)
SELECT empno, ename
FROM emp
WHERE empno IN (7566,7698,7369)
INTERSECT
SELECT empno, ename
FROM emp
WHERE empno IN(7566,7698,7499);

--MINUS(������: �� ���տ��� �Ʒ� ������ ����)
--������ ����
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
SELECT 2, 'y' --�÷����� �޶� �ȴ�.
FROM dual
ORDER BY m desc;--������ ��������
