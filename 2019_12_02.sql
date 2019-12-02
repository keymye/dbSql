--�͸� ���
SET serveroutput on;

DECLARE
    --����̸��� ������ ��Į�� ����(1���� ��)
    v_ename emp.ename%TYPE;
BEGIN
    SELECT ename
    INTO v_ename 
    FROM emp;
    --��ȸ����� �������ε� ��Į�󺯼��� ���� �����Ϸ� �Ѵ�.
    -- -->����
    
    --�߻�����, �߻����ܸ� Ư�� ���� ���� �� --> others(java: exception)
    EXCEPTION
        WHEN others THEN
            dbms_output.put_line('Exception others');
        
END;
/


--����� ���� ����
DECLARE
    --emp���̺� ��ȸ�� ����� ���� ��� �߻���ų ����� ���� ����
    --���ܸ� EXCEPTION; --������ ����Ÿ��
    NO_EMP EXCEPTION;
    v_ename emp.ename%TYPE;
BEGIN
    BEGIN --try catch ���� �ȿ� try catch
        SELECT ename 
        INTO v_ename
        FROM emp
        WHERE empno=9999; --����
        
        EXCEPTION 
            WHEN NO_DATA_FOUND THEN
                dbms_output.put_line('������ ������');
                --����ڰ� ������ ����� ���� ���ܸ� ����
                RAISE NO_EMP; -- JAVA: throw
    END; 
    
    EXCEPTION
        WHEN NO_EMP THEN
            dbms_output.put_line('no_emp exception');
END;
/

--�����ȣ�� �����ϰ�, �ش� �����ȣ�� �ش��ϴ� ����̸��� �����ϴ� �Լ�(function)
CREATE OR REPLACE FUNCTION getEmpName(p_empno emp.empno%TYPE)
RETURN VARCHAR2
IS
    --�����
    ret_ename emp.ename%TYPE;
BEGIN
    --����
    SELECT ename
    INTO ret_ename
    FROM emp
    WHERE empno = p_empno;
    
    RETURN ret_ename;
END;
/

SELECT getEmpName(7369)
FROM dual;

SELECT empno, ename, getEmpName(empno)
FROM EMP;


--function1
CREATE OR REPLACE FUNCTION getdeptname(p_deptno dept.deptno%TYPE)
RETURN VARCHAR2
IS
    ret_dname dept.dname%TYPE;
BEGIN
    SELECT dname
    INTO ret_dname
    FROM dept
    WHERE deptno = p_deptno;
    
    RETURN ret_dname;
END;
/

SELECT deptno, getdeptname(deptno)
FROM dept;

SELECT getdeptname(10)
FROM dual;


--function2
CREATE OR REPLACE FUNCTION indent(p_dname dept.dname%TYPE, p_level NUMBER)
RETURN VARCHAR2
IS 
    ret_text VARCHAR2(50);
BEGIN
    SELECT  LPAD(' ',(p_level-1)*4,' ')|| p_dname
    INTO ret_text
    FROM dual;
    
    RETURN ret_text;
END;
/

SELECT indent('ACCOUNTING',2), indent('SALES',3)
FROM dual;


SELECT deptcd, indent(deptnm, LEVEL) as deptnm
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;


CREATE TABLE user_history(
    userid VARCHAR2(20),
    pass VARCHAR2(100),
    mod_dt DATE
);

--users���̺��� pass�÷��� ����� ���
--users_history�� ������ pass�� �̷����� ����� ���l��
CREATE OR REPLACE TRIGGER make_history
    BEFORE UPDATE ON users -- users���̺� ������Ʈ ����
    FOR EACH ROW
    
    BEGIN
        -- :NEW.�÷��� : UPDATE������ �ۼ��� ��
        -- :OLD.�÷��� : ���� ���̺� ��
        IF :NEW.pass != :OLD.pass THEN
            INSERT INTO user_history VALUES(:OLD.userid, :OLD.pass, sysdate);
        END IF;
    END;
/

--brown	����	c6347b73d5b1f7c77f8be828ee3e871c819578f23779c7d5e082ae2b36a44
SELECT * FROM users;

UPDATE users SET pass='brownpass'
WHERE userid='brown';
--������� where���� ���� �� �ٲ�

SELECT * 
FROM user_history;








