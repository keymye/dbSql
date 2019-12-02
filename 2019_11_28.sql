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

--ROWTYPE : 테이블의 한 행의 데이터를 담을 수 있는 참조타입
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


--복합변수 : record (개발자가 직접 만들수 있음)
DECLARE
    --UserVO uservo;
    TYPE dept_row IS RECORD(
        deptno NUMBER(2),
        dname dept.dname%TYPE); --한행에 두개의 컬럼
        
     v_dname dept.dname%TYPE;   
     v_row dept_row;    
     --java : 타입 변수명;
     --pl/sql : 변수명 타입;
     
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
    --dept의 여러개행을 저장하는 테이블타입            인덱스의 타입선언
    
    v_dept dept_tab;

BEGIN

    SELECT *
    bulk collect INTO v_dept --6건의 전체 데이터가 변수에 저장됨
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
--FOR 인덱스변수 IN 시작값..종료값 LOOP
--END LOOP;

DECLARE
BEGIN
    FOR i IN 0..5 LOOP
        dbms_output.put_line('i : ' || i);
    END LOOP;
END;
/

--LOOP : 계속 실행 판단 로직을 LOOP안에서 제어
--java : while(true)
DECLARE
    i NUMBER;
BEGIN
    i := 0;
    LOOP
         dbms_output.put_line('i : ' || i);
        i := i+1;
        --loop계속 진행여부 판단
        EXIT WHEN i>=5;
    END LOOP;
END;
/

--간격 평균 : 5일
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
        i_sum := i_sum / ((p_tab.count)-1); --연산자 우선순위 고려!!
        dbms_output.put_line('간격 평균 : ' || i_sum || '일');
        
END;
/


--lead, lag
SELECT AVG(a.diff)
FROM
(SELECT 
dt, LEAD(dt) OVER(ORDER BY dt desc),
dt - LEAD(dt) OVER(ORDER BY dt desc) diff
FROM dt)a;

--최댓값,최솟값으로 구하기
SELECT (MAX(dt)-MIN(dt)) / (COUNT(*)- 1) avg
FROM dt;

--분석함수 사용하지 못하는 환경에서

SELECT AVG(a.dt - b.dt) 평균
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
--여러건의 데이터를 테이블타입없이 작업가능
DECLARE 
    --커서 선언
    CURSOR dept_cursor IS
        SELECT deptno, dname FROM dept;
    v_deptno dept.deptno%TYPE;
    v_dname dept.dname%TYPE;
BEGIN
    --커서 열기
    OPEN dept_cursor;
    LOOP
        FETCH dept_cursor INTO v_deptno, v_dname;  
        EXIT WHEN dept_cursor%NOTFOUND; --더이상 읽을 데이터가 없을 때 종료
        dbms_output.put_line(v_deptno || ',' || v_dname);
    END LOOP;

END;
/

--for loop cursor
--향상된for문 개념
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

--파라미터가 있는 명시적 커서
--동적으로 값을 바꿀수있다.
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