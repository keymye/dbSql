--����ŷ, �Ƶ�����, kfc����
SELECT a.sido, a.sigungu, a.cnt kmb, b.cnt l, round(a.cnt/ b.cnt, 2) point
FROM(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE /* sido = '����������' 
AND */ gb IN('����ŷ','�Ƶ�����','KFC')
GROUP BY sido, sigungu) a,
--�Ե�����
(SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE /* sido = '����������' 
AND */ gb = '�Ե�����'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido AND
a.sigungu = b.sigungu
ORDER BY point desc;


--�õ�, �ñ���, ��������, �õ�, �ñ���, �������� ���Ծ�
--����� �߱� 5.7 ��⵵ ������ 18623591 ������������ ������

SELECT a.*, b.*
FROM
(SELECT a.* , rownum rn
FROM
(SELECT a.sido, a.sigungu,round(a.cnt/ b.cnt, 2) point
    FROM
        --140��
        (SELECT sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb IN('����ŷ','�Ƶ�����','KFC')
        GROUP BY sido, sigungu) a,
       
       --188��
        (SELECT sido, sigungu, COUNT(*) cnt
        FROM fastfood
        WHERE gb = '�Ե�����'
        GROUP BY sido, sigungu) b
WHERE a.sido = b.sido 
AND a.sigungu = b.sigungu
ORDER BY point desc) a) a 
RIGHT OUTER JOIN
(SELECT b.* , rownum rn
FROM
    (SELECT sido, sigungu, sal
    FROM tax
    ORDER BY sal desc) b) b
ON (a.rn(+) = b.rn);


----------------------------------------------------------------
--EMP_TEST ���̺�����
DROP TABLE emp_test;

--multiple insert�� ���� �׽�Ʈ ���̺� ����
--empno, ename �ΰ��� �÷��� ���� emp_test, emp_test2 ���̺��� 
--emp���̺�� ���� �����Ѵ�.(CTAS)
--�����ʹ� �������� �ʴ´�.

CREATE TABLE emp_test AS
SELECT empno , ename
FROM emp
WHERE 1=2;

CREATE TABLE emp_test2 AS
SELECT empno , ename
FROM emp
WHERE 1=2;

--INSERT ALL
--�ϳ��� SQL�������� ���� ���̺� �����͸� �Է�
INSERT ALL 
    INTO emp_test 
    INTO emp_test2 
SELECT 1, 'brown' FROM dual UNION ALL
SELECT 2, 'sally' FROM dual;

--insert������ Ȯ��
SELECT * FROM emp_test;
SELECT * FROM emp_test2;

--insert all �÷� ����
ROLLBACK;

INSERT ALL
    INTO emp_test (empno) VALUES (empno)
    INTO emp_test2 VALUES (empno, ename)
SELECT 1 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;


--multiple insert(conditional insert)
ROLLBACK;
INSERT ALL
    WHEN empno < 10 THEN
        INTO emp_test (empno) VALUES (empno)
    ELSE --������ ������� ���� ���� ����
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual UNION ALL
SELECT 2 empno, 'sally' ename FROM dual;

SELECT * FROM emp_test;
SELECT * FROM emp_test2;


--insert first
--���ǿ� �����ϴ� ù��° insert������ ����
ROLLBACK;
INSERT FIRST
    WHEN empno > 10 THEN
        INTO emp_test (empno) VALUES (empno)
    WHEN empno > 5 THEN 
        INTO emp_test2 VALUES (empno, ename)
SELECT 20 empno, 'brown' ename FROM dual; --�� ������ ���������� ù��° ���Ǹ� ����

SELECT * FROM emp_test;
SELECT * FROM emp_test2;

rollback;
--merge : ���ǿ� �����ϴ� �����Ͱ� ������ update, ������ insert
--empno�� 7369�� �����͸� emp���̺�κ��� emp_test���̺� ����(insert)
INSERT INTO emp_test
SELECT empno, ename 
FROM emp 
WHERE empno =7369;

SELECT * FROM emp_test;

--emp���̺��� �������� emp_test���̺��� empno�� ���� ���� ����
--�����Ͱ� ���� ��� emp_test.ename = ename || '_merge'������ update
--���� ��� emp_test���̺� insert
ALTER TABLE emp_test MODIFY (ename VARCHAR2(20));

MERGE INTO emp_test 
USING (SELECT empno, ename
        FROM emp
        WHERE emp.empno IN (7369,7499)) emp --2���ິ��
ON (emp.empno = emp_test.empno)
WHEN MATCHED THEN
    UPDATE SET ename = emp.ename || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES(emp.empno, emp.ename);

rollback;
SELECT * FROM emp_test;

--�ٸ� ���̺��� ������ �ʰ� ���̺� ��ü�� ������ ���� ������
--merge�ϴ� ���
ROLLBACK;
DROP TABLE emp_test;

CREATE TABLE emp_test AS
SELECT empno , ename
FROM emp
WHERE 1=2;

INSERT INTO emp_test
SELECT empno, ename 
FROM emp 
WHERE empno =7369;

--empno = 1, ename= 'brown'
--empno�� ���� ���� ������ ename�� 'brown'���� ������Ʈ
--empno�� ���� ���� ������ �ű� insert
MERGE INTO emp_test
USING dual
    ON (emp_test.empno = 1) -- �� �÷��� ������Ʈ �� �� ����.
WHEN MATCHED THEN
    UPDATE SET ename='brown' || '_merge'
WHEN NOT MATCHED THEN
    INSERT VALUES(1, 'brown');

SELECT * FROM emp_test;
rollback;
--merge�� ����������
SELECT 'X'
FROM emp_test
WHERE empno= 1;

UPDATE emp_test set ename = 'brown' || '_merge'
WHERE empno=1;

INSERT INTO emp_test VALUES(1,'brown');

--group_ad1 �׷캰 �հ�, ��ü�հ踦 ������ ���� ���Ϸ���?
--row���� �ø����� union 
SELECT deptno, sum(sal) 
FROM emp 
GROUP BY deptno
UNION ALL --�÷������� �����ؾ���
SELECT null,sum(sal)
FROM emp
ORDER BY deptno;

--�� ������ rollup���·� ����
SELECT deptno, sum(sal)
FROM emp
GROUP BY ROLLUP(deptno);

--rollup
--group by�� ���� �׷��� ����
--GROUP BY ROLLUP({col,})
--�÷��� �����ʿ������� �����ذ��鼭 ���� ����׷���
--GROUP BY�Ͽ� UNION�� �Ͱ� ����
--ex : GROUP BY ROLLUP(job,deptno)
--GROUP BY job,deptno
--UNION
--GROUP BY job
--UNION
--GROUP BY -->�Ѱ�(��� �࿡ ���� �׷��Լ� ����)
SELECT job, deptno, sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--GROUPING SETS(col1, col2...)
--GROUPING SETS�� ������ �׸��� �ϳ��� ����׷����� GROUP BY���� �̿�ȴ�.

--GROUP BY col1
--union
--GROUP BY col2

--EMP���̺��� �̿��Ͽ� �μ��� �޿��հ� ������(JOB)�� �޿����� ���Ͻÿ�

--�μ���ȣ, job, �޿��հ�
SELECT deptno, null job ,sum(sal)
FROM emp
GROUP by deptno
UNION ALL
SELECT null, job, sum(sal)
FROM emp
GROUP by job;
--------
SELECT job,deptno, sum(sal)
FROM emp
GROUP BY grouping sets(job, deptno);
--------
SELECT job,deptno, sum(sal)
FROM emp
GROUP BY grouping sets(deptno,job,(deptno,job));


