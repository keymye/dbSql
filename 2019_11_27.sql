SELECT *
FROM no_emp;


--1.lear nodeã��
SELECT lpad(' ', (level-1)*4,' ') || org_cd, s_emp
FROM
    (SELECT org_cd, parent_org_cd,SUM(s_emp) s_emp
        FROM
        (SELECT org_cd, parent_org_cd,
                SUM(no_emp/org_cnt) OVER(PARTITION BY gr 
                                    ORDER BY rn 
                                    ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) s_emp
        FROM
        (SELECT a.*, ROWNUM rn, a.lv + ROWNUM gr, COUNT(org_cd) OVER (PARTITION BY org_cd) org_cnt
             FROM
            (SELECT org_cd, parent_org_cd, no_emp, LEVEL lv, connect_by_isleaf leaf
                 FROM no_emp
                    START WITH parent_org_cd IS NULL
                    CONNECT BY PRIOR org_cd = parent_org_cd) a
                    START WITH leaf= 1
                    CONNECT BY PRIOR parent_org_cd = org_cd))
        GROUP BY org_cd, parent_org_cd)
START WITH parent_org_cd IS NULL
CONNECT BY PRIOR org_cd = parent_org_cd;




--PL/SQL
--�Ҵ翬�� :=
-- system.out.prinln("") --> dbms_output.put_line("");
-- �ڹٿ����� log4j�� �������
-- ��±�� Ȱ��ȭ : set serveroutput on; 

--PL/SQL
--declare : ���� , ��� ����
--begin : ���� ����
--exception : ����ó��

DESC dept;
set serveroutput on;

DECLARE
    --���� ����
    deptno NUMBER(2);
    dname VARCHAR2(14); --����Ʈ
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --INTO : �����Ͱ� �� ���϶�! WHERE������ ��������.
    
    --select���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname : ' || dname || 
    '(' || deptno || ')');
END;
/
--��ħǥ��


DECLARE
    --�������� ����(���̺� �÷�Ÿ���� ����Ǿ PL/SQL������
    --������ �ʿ䰡 ����.
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --INTO : �����Ͱ� �� ���϶�! WHERE������ ��������.
    
    --select���� ����� ������ �� �Ҵ��ߴ��� Ȯ��
    dbms_output.put_line('dname : ' || dname || 
    '(' || deptno || ')');
END;
/

--10���μ��� �μ��̸��� LOC������ ȭ�鿡 ����ϴ� ���ν���
--���ν����� : printdept
--CREATE OR REPLACE ���� ���δ�.

CREATE OR REPLACE PROCEDURE printdept 
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = 10;
    
    dbms_output.put_line('dname,loc = ' || dname || ',' || loc);
END;
/
exec printdept; --����


--�Ķ���� 
CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE)
IS
    --��������
    dname dept.dname%TYPE;
    loc dept.loc%TYPE;
BEGIN
    SELECT dname, loc 
    INTO dname, loc
    FROM dept
    WHERE deptno = p_deptno;
    
    dbms_output.put_line('dname,loc = ' || dname || ',' || loc);
END;
/
exec printdept_p(30);


--pro_1
--procedure : printemp
--�Է�: �����ȣ
--���: ����̸�, �μ��̸�

CREATE OR REPLACE PROCEDURE printemp (empno_p IN emp.empno%TYPE)
IS 
    ename emp.ename%TYPE; --emp�� ename�� �����Ѵ�. �������� �ƹ��ų� �������(var_ename emp.ename%TYPE;) 
    dname dept.dname%TYPE;
BEGIN
    SELECT ename, dname
    INTO ename, dname
    --INTO var_ename, var_dname
    FROM emp a, dept b
    WHERE a.empno = empno_p and a.deptno = b.deptno;
    
    dbms_output.put_line(ename || ',' || dname);
                        --var_ename|| ',' || var_dname
END;
/
exec printemp(7369);


--pro_2
CREATE OR REPLACE PROCEDURE registdept_test (deptno_p IN dept_test.deptno%TYPE, 
dname_p IN dept_test.dname%TYPE, loc_p IN dept_test.loc%TYPE) 
IS
BEGIN 
    INSERT INTO dept_test VALUES(deptno_p,dname_p, loc_p);
    
    dbms_output.put_line(deptno_p || ',' || dname_p || ',' || loc_p);
END;
/
exec registdept_test(99,'ddit','daejeon'); 


select * from dept_test;
desc dept_test;



