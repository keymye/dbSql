-- GROUPING(cube, rollup���� ���� �÷�)
-- �ش� �÷��� �Ұ� ��꿡 ���� ��� 1 , 
-- ������ ���� ��� 0

--job�÷�
--group_ad2
--case1. GROUPING(job)=1 and GROUPING(deptno)=1
--      job --> '�Ѱ�'
--case else 
--      job --> job
SELECT 
    CASE WHEN GROUPING( job) =1 AND GROUPING(deptno)=1
        THEN '�Ѱ�'
        ELSE job
    END job, deptno,
    GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--group_ad2 ��ȭ
SELECT 
    CASE WHEN GROUPING( job) =1 AND GROUPING(deptno)=1
        THEN '�Ѱ�'
        ELSE job
    END job, 
    CASE WHEN GROUPING(deptno) =1 AND GROUPING(job) = 0
         THEN job || ' �Ұ�'
         ELSE TO_CHAR(deptno)
    END deptno,
GROUPING(job), GROUPING(deptno), sum(sal) sal
FROM emp
GROUP BY ROLLUP(job, deptno);

--group_ad3
SELECT deptno,job,sum(sal) sal
FROM emp
GROUP BY ROLLUP(deptno, job);

--group_ad4
SELECT dname, job, sum(sal) sal
FROM dept a, emp b
WHERE a.deptno = b.deptno
GROUP BY ROLLUP(dname,job)
ORDER BY dname ,sal desc;

--group_ad5
SELECT 
    CASE WHEN GROUPING(dname)=1
    THEN '����'
    ELSE dname
    END dname, job, sum(sal) sal
FROM dept a, emp b
WHERE a.deptno = b.deptno
GROUP BY ROLLUP(dname,job)
ORDER BY dname ,sal desc;


--CUBE(col1, col2...)
--CUBE���� ������ �÷��� ������ ��� ���տ� ���� ����׷����� ����
--CUBE�� ������ �÷��� ���� ���⼺�� ����.(ROLLUP���� ����)
--GROUP BY CUBE(job, deptno)
--00: GROUP BY job, deptno
--0X: GROUP BY job
--XO: GROUP BY deptno
--XX: GROUP BY --��� �����Ϳ� ���ؼ�

--GROUP BY CUBE(job, deptno, mgr)

SELECT job, deptno, SUM(sal)
FROM emp
GROUP BY CUBE(job, deptno);


--subquery�� ���� ������Ʈ
--advanced
--emp���̺��� �����͸� �����ؼ� ��� �÷��� �̿��Ͽ� emp_test���̺�� ����
CREATE TABLE emp_test AS
SELECT * 
FROM emp;

select * from emp_test;

--dept���̺��� �����ǰ� �ִ� dname(VARCHAR2(14)) �÷��߰�
desc dept;
ALTER TABLE emp_test ADD (dname VARCHAR2(14));

--subquery�� �̿��Ͽ� dept���̺��� dname �÷��� ������Ʈ
UPDATE emp_test 
SET dname =(SELECT dname 
            FROM dept
            WHERE emp_test.deptno = dept.deptno);

commit;
--���� �� �߰� ���� WHERE  empno IN (7369,7499)  
 
--�ǽ�sub_a1           
CREATE TABLE dept_test AS
SELECT *
FROM dept; 

ALTER TABLE dept_test ADD (empcnt number);
UPDATE dept_test 
SET empcnt = (SELECT COUNT(*)
            FROM emp 
            WHERE dept_test.deptno = emp.deptno);
select *from dept_test;
--sub_a2
DROP TABLE dept_test;
CREATE TABLE dept_test AS
SELECT *
FROM dept; 

INSERT INTO dept_test values(99,'it1','daejeon');
INSERT INTO dept_test values(98,'it2','daejeon');
DELETE dept_test 
WHERE deptno NOT IN(SELECT deptno
                    FROM emp);
                
DELETE dept_test 
WHERE NOT EXISTS (SELECT 'X' 
                    FROM emp 
                  WHERE emp.deptno = dept_test.deptno);

select * from dept_test;

--�ٽú���
DELETE dept_test
WHERE empcnt not in (SELECT COUNT(*) 
                    FROM emp 
                    WHERE emp.deptno = dept_test.deptno
                    group by deptno);
DELETE dept_test
WHERE deptno NOT IN (SELECT deptno FROM emp);

--sub_a3
DROP TABLE emp_test;
CREATE TABLE emp_test AS
SELECT *
FROM emp; 

ALTER TABLE emp_test ADD (dname VARCHAR(14));

UPDATE emp_test a SET sal = sal+200
WHERE sal < 
    (SELECT AVG(sal) 
    FROM emp_test b
    WHERE b.deptno = a.deptno);

--emp,emp_test empno�÷����� ���� ������ ��ȸ
--1.emp.empno, emp.ename, emp.sal, emp_test.sal
SELECT emp.empno , emp.ename, emp.sal, emp_test.sal
FROM emp, emp_test
WHERE emp.empno = emp_test.empno;

--2. emp.empno, emp.ename, emp.sal, emp_test.sal, �ش���(emp���̺� ����)�� ���� �μ��� �޿����
SELECT a.empno, a.ename, a.sal1, a.sal2, b.avg 
FROM
(SELECT emp_test.deptno as deptno,emp.empno empno, emp.ename ename, emp.sal sal1, emp_test.sal sal2
FROM emp, emp_test
WHERE emp.empno = emp_test.empno) a
JOIN 
(SELECT deptno , round(avg(sal),0) avg
FROM emp
group by deptno) b
ON(a.deptno  = b.deptno);







select * from emp_test;