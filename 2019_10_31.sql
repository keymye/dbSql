--���̺��� ������ ��ȸ
/*
    SELECT �÷� | express(���ڿ� ���) [as] ��Ī
    FROM �����͸� ��ȸ�� ���̺�(VIEW)
    WHERE ���� (condition)
*/

DESC user_tables;

--SELECT table_name,
--'SELECT * FROM ' || table_name || ';' AS select_query
--FROM user_tables
--WHERE TABLE_NAME != 'EMP';

--���ں� ����
--���� �������� ������ ����, �������� ���� ����
--�μ���ȣ�� 30������ ũ�ų� ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno >= 30;

--�μ���ȣ�� 30������ ���� �μ��� ���� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno < 30;

--�Ի����ڰ� 1982�� 1�� 1�� ������ ���� ��ȸ
SELECT *
FROM emp
--WHERE hiredate < '82/01/01';
--WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD');
WHERE hiredate >= TO_DATE('01011982','MMDDYYYY');

-- col BETWEEN X AND Y ����
-- �÷��� ���� X���� ũ�ų� ����, Y���� �۰ų� ���� ������
-- �޿�(sal)�� 1000���� ũ�ų� ����, 2000���� �۰ų� ���� ������ ��ȸ
SELECT *
FROM emp
WHERE sal between 1000 and 2000;


--���� BETWEEN AND �����ڴ� �Ʒ��� <= , >= ���հ� ����.
SELECT *
FROM emp
WHERE sal >= 1000 and sal <= 2000 and deptno = 30;

--�ǽ�1
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('19820101','YYYYMMDD') and  TO_DATE('19830101','YYYYMMDD');

--�ǽ�2
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('19820101','YYYYMMDD') and hiredate <= TO_DATE('19830101','YYYYMMDD');

--IN ������
-- COL IN(values...)
--�μ���ȣ�� 10 Ȥ�� 20�� ���� ��ȸ
SELECT *
FROM emp
WHERE deptno in (10,20);

--IN �����ڴ� OR�����ڷ� ǥ���� �� �ִ�.
SELECT *
FROM emp
WHERE deptno =10 OR deptno =20;

--�ǽ�3
SELECT userid ���̵�, usernm �̸�, filename ����
FROM users
WHERE userid in ('brown', 'cony', 'sally');

--COL LIKE 'S%'
--COL�� ���� �빮�� S�� �����ϴ� ��� ��
--COL LIKE 'S____'
--COL�� ���� �빮�� S�� �����ϰ� �̾ 4���� ���ڿ��� �����ϴ� ��

SELECT *
FROM emp
WHERE ename LIKE 'S%';

--�ǽ�4
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '��%';

--�ǽ�5
SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%��%';

--NULL��
--col IS NULL
--EMP���̺��� MGR ������ ���� ���(NULL) ��ȸ
SELECT *
FROM emp
WHERE mgr IS NULL;

--�Ҽ� �μ��� 10���� �ƴ� ������
SELECT *
FROM emp
WHERE deptno != '10';

-- = , !=
-- is null , is not null
--�ǽ�6
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

--emp���̺��� ������(mgr) ����� 7698�� �ƴϰ�, 7839�� �ƴ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839);

--���� ������ AND/OR �����ڷ� ��ȯ
SELECT *
FROM emp
WHERE mgr !=7698 AND mgr != 7839;

--IN, NOT IN �������� NULLó��
--IN �����ڿ��� ������� NULL�� ���� ��� �ǵ����� ���� ������ �Ѵ�.
SELECT *
FROM emp
WHERE mgr NOT IN(7698,7839) AND mgr IS NOT NULL;


--�ǽ�7
SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

--�ǽ�8
SELECT *
FROM emp
WHERE deptno != 10 and hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');


--�ǽ�9
SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--�ǽ�10
SELECT *
FROM emp
WHERE deptno IN(20,30) AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--�ǽ�11
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

--�ǽ�12
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno LIKE '78%';

--�ǽ�13(LIKE���X)
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno =78 OR (empno BETWEEN 780 AND 789) OR  (empno BETWEEN 7800 AND 7899);

--�ǽ�14
SELECT *
FROM emp
WHERE (job = 'SALESMAN' AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') )
OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));

