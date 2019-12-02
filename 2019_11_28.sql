set serveroutput on;
--pro_3
CREATE OR REPLACE PROCEDURE UPDATEdept_test (deptno_p IN dept_test.deptno%TYPE, 
dname_p IN dept_test.dname%TYPE, loc_p IN dept_test.loc%TYPE) 
IS
BEGIN 
    UPDATE dept_test SET deptno = deptno_p, dname = dname_p, loc = loc_p
    WHERE deptno=99;
    
    dbms_output.put_line(deptno_p || ',' || dname_p || ',' || loc_p);
END;
/
exec updatedept_test(99,'ddit_m','daejeon'); 

select * from dept_test;

--ROWTYPE : ���̺��� �� ���� �����͸� ���� �� �ִ� ����Ÿ��
set serveroutput on;
DECLARE
    dept_row dept%ROWTYPE;
BEGIN
    SELECT *
    INTO dept_row
    FROM dept
    WHERE deptno=10;
    
    dbms_output.put_line(dept_row.deptno || ',' || 
    dept_row.dname || ',' || dept_row.loc);
    
END;
/


--���պ��� : record (�����ڰ� ���� ����� ����)
DECLARE
    --UserVO uservo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE); --���࿡ �ΰ��� �÷�
        
     v_dname dept.dname%TYPE;   
     v_row dept_row;    
     --java : Ÿ�� ������;
     --pl/sql : ������ Ÿ��;
     
BEGIN
    SELECT deptno, dname
    INTO v_row
    FROM dept
    WHERE deptno = 10;

    dbms_output.put_line(v_row.deptno || ',' || v_row.dname);

END;
/

--tabletype
DECLARE
    TYPE dept_tab IS TABLE OF dept%ROWTYPE INDEX BY BINARY_INTEGER;
    --dept�� ���������� �����ϴ� ���̺�Ÿ��            �ε����� Ÿ�Լ���
    
    v_dept dept_tab;

BEGIN

    SELECT *
    bulk collect INTO v_dept --6���� ��ü �����Ͱ� ������ �����
    FROM dept;
    
    FOR i IN 1..v_dept.count LOOP
         dbms_output.put_line(v_dept(i).dname);
    END LOOP;
    
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(1).dname);
--    dbms_output.put_line(v_dept(2).dname);
--    dbms_output.put_line(v_dept(3).dname);
--    dbms_output.put_line(v_dept(4).dname);
END;
/

--IF
--ELSE IF --> ELSIF
--END IF;

DECLARE
    ind BINARY_INTEGER;
BEGIN
    ind := 2;
    IF ind = 1 THEN
        dbms_output.put_line(ind);
    ELSIF ind = 2 THEN
        dbms_output.put_line('ELSIF ' || ind);
    ELSE
        dbms_output.put_line('ELSE');
    END IF;
END;
/

--for loop
--FOR �ε������� IN ���۰�..���ᰪ LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/

--LOOP : ��� ���� �Ǵ� ������ LOOP�ȿ��� ����
--java : while(true)
DECLARE
    i NUMBER;
BEGIN
    i := 0;
    LOOP
         dbms_output.put_line('i : ' || i);
        i := i+1;
        --loop��� ���࿩�� �Ǵ�
        EXIT WHEN i>=5;
    END LOOP;
END;
/

--���� ��� : 5��
DECLARE 
     TYPE DT_tab IS TABLE OF DT%ROWTYPE INDEX BY BINARY_INTEGER;
    p_tab DT_tab;
    i_sum NUMBER := 0;
BEGIN   
    SELECT *
    bulk collect INTO p_tab 
    FROM DT
    ORDER BY DT desc;
    
    FOR i IN 1..(p_tab.count)-1 LOOP
        i_sum := i_sum + (p_tab(i).dt - p_tab(i+1).dt); 
    END LOOP;
        i_sum := i_sum / ((p_tab.count)-1); --������ �켱���� ���!!
        dbms_output.put_line('���� ��� : ' || i_sum || '��');
        
END;
/


--lead, lag
SELECT AVG(a.diff)
FROM
(SELECT 
dt, LEAD(dt) OVER(ORDER BY dt desc),
dt - LEAD(dt) OVER(ORDER BY dt desc) diff
FROM dt)a;

--�ִ�,�ּڰ����� ���ϱ�
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)- 1) avg
FROM dt;

--�м��Լ� ������� ���ϴ� ȯ�濡��

SELECT AVG(a.dt - b.dt) ���
FROM
    (SELECT ROWNUM RN, DT
    FROM
        (SELECT *
        FROM dt
        ORDER BY dt desc)) a,
    (SELECT ROWNUM RN, DT
    FROM
        (SELECT *
        FROM dt
        ORDER BY dt desc)) b
WHERE a.rn+1 = b.rn;
    
--cursor
--�������� �����͸� ���̺�Ÿ�Ծ��� �۾�����
DECLARE 
    --Ŀ�� ����
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --Ŀ�� ����
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;  
        EXIT WHEN dept_cursor%NOTFOUND; --���̻� ���� �����Ͱ� ���� �� ����
        dbms_output.put_line(v_deptno || ',' || v_dname);
    END LOOP;

END;
/

--for loop cursor
--����for�� ����
DECLARE
    CURSOR dept_cursor IS
        SELECT deptno, dname
        FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    FOR rec IN dept_cursor LOOP
        dbms_output.put_line(rec.deptno || ',' || rec.dname);
    END LOOP;
END;
/

--�Ķ���Ͱ� �ִ� ����� Ŀ��
--�������� ���� �ٲܼ��ִ�.
DECLARE
    CURSOR emp_cursor(p_job emp.job%TYPE) IS
        SELECT empno, ename, job
        FROM emp
        WHERE job = p_job;     
BEGIN
    FOR emp IN emp_cursor('SALESMAN') LOOP
         dbms_output.put_line(emp.empno || ',' || emp.ename || ',' || emp.job);   
    END LOOP;
END;