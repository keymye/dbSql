SELECT *
FROM no_emp;


--1.lear node찾기
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
--할당연산 :=
-- system.out.prinln("") --> dbms_output.put_line("");
-- 자바에서는 log4j를 사용하자
-- 출력기능 활성화 : set serveroutput on; 

--PL/SQL
--declare : 변수 , 상수 선언
--begin : 로직 실행
--exception : 예외처리

DESC dept;
set serveroutput on;

DECLARE
    --변수 선언
    deptno NUMBER(2);
    dname VARCHAR2(14); --바이트
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --INTO : 데이터가 한 건일때! WHERE절빼면 에러난다.
    
    --select절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' || dname || 
    '(' || deptno || ')');
END;
/
--마침표시


DECLARE
    --참조변수 선언(테이블 컬럼타입이 변경되어도 PL/SQL구문을
    --수정할 필요가 없다.
    deptno dept.deptno%TYPE;
    dname dept.dname%TYPE;
BEGIN
    SELECT deptno, dname INTO deptno, dname
    FROM dept
    WHERE deptno = 10;
    --INTO : 데이터가 한 건일때! WHERE절빼면 에러난다.
    
    --select절의 결과를 변수에 잘 할당했는지 확인
    dbms_output.put_line('dname : ' || dname || 
    '(' || deptno || ')');
END;
/

--10번부서의 부서이름과 LOC정보를 화면에 출력하는 프로시저
--프로시저명 : printdept
--CREATE OR REPLACE 자주 쓰인다.

CREATE OR REPLACE PROCEDURE printdept 
IS
    --변수선언
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
exec printdept; --실행


--파라미터 
CREATE OR REPLACE PROCEDURE printdept_p (p_deptno IN dept.deptno%TYPE)
IS
    --변수선언
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
--입력: 사원번호
--출력: 사원이름, 부서이름

CREATE OR REPLACE PROCEDURE printemp (empno_p IN emp.empno%TYPE)
IS 
    ename emp.ename%TYPE; --emp의 ename을 참조한다. 변수명은 아무거나 상관없음(var_ename emp.ename%TYPE;) 
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



