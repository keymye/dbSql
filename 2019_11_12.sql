INSERT INTO emp (empno,ename,job) VALUES (9999,'brown',null);
rollback;
select * from emp;

desc emp;
--���̺����� �˻��ϴ� �Ǵٸ� ��� (�÷����� ��� �빮��)
select * from user_tab_columns where table_name = 'EMP';

EMPNO
ENAME
JOB
MGR
HIREDATE
SAL
COMM
DEPTNO;
insert into emp values(9999,'brown','ranger',null,sysdate,2500,null,40);

--SELECT ���(������)�� INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
rollback;

select* from emp;

--UPDATE
UPDATE dept SET dname='���IT', loc='ym' --dname �ױ��ڱ���
WHERE deptno =99;

--delete
delete emp where empno=9999;
commit;

select *from emp;

delete emp
where empno in (select deptno from dept);

--LV1--> LV3
SET TRANSACTION
isolation LEVEL SERIALIZABLE;

--�ǵ�����
SET TRANSACTION
isolation LEVEL READ COMMITTED;

commit;
select * from dept;
--DML������ ���� Ʈ����� ����
INSERT INTO dept
values (99,'ddit','daejeon');

select * from dept;

--DDL : AUTO COMMIT, ROLLBACK�� �ȵȴ�.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,
    ranger_name VARCHAR2(50), --���� varchar2, char �����ϸ� varchar2���
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

desc ranger_new;

--DDL�� ROLLBACK�� ������� �ʴ´�.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000,'brown'); --sysdate�� ����Ʈ�� ��
commit;

select*from ranger_new;

--��¥ Ÿ�Կ��� Ư�� �ʵ� ��������
--ex : sysdate���� �⵵�� ��������
SELECT TO_CHAR(sysdate,'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt,'MM') mm,
            EXTRACT(MONTH FROM reg_dt) mm,
              EXTRACT(YEAR FROM reg_dt) year
              ,  EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;


--��������
--DEPT ����ؼ� DEPT_TEST����
desc dept_test;
CREATE TABLE DEPT_TEST (
  deptno number(2) PRIMARY KEY,--DEPTNO�� �ĺ��ڷ� ����(�ߺ�X,NULL X)
  dname varchar2(14),
  loc varchar2(13)
);

--primary key �������� Ȯ��
--1.deptno�÷��� null�� �� �� ����.
--2.deptno�÷��� �ߺ��� ���� �� �� ����.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon'); --null�ȵ�

INSERT INTO dept_test
VALUES (1, 'ddit', 'daejeon'); 

INSERT INTO dept_test
VALUES (1, 'ddit2', 'daejeon');--�ߺ���x

rollback;

--����� ���� �������Ǹ��� �ο��� PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY, --�������� �̸�
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2), 
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname) --�ΰ��÷��� �ĺ��ڷ� ���� ������(����Ű) �Ʒ� insert���� ����ȴ�.
);

INSERT INTO dept_test
VALUES (1, 'ddit', 'daejeon'); 

INSERT INTO dept_test
VALUES (1, 'ddit2', 'daejeon');

select * from dept_test;
rollback;

--NOT NULL
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) NOT NULL,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(2,null,'daejeon');

--unique
DROP TABLE dept_test;
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14) UNIQUE,
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO dept_test VALUES(2,'ddit','daejeon');
