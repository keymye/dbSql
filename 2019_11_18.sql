SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC15';

SELECT *
FROM pc15.V_EMP_DEPT;

--sem계정에서 조회권한을 받은 v_emp_dept view를 hr계정에서 조회하기 위해서는
--계정명.view이름 형식으로 기술해야한다.
--매번 계정명을 기술하기 귀찮으므로 synonym을 통해 다른 별칭을 생성

CREATE SYNONYM V_EMP_DEPT FOR pc15.V_EMP_DEPT;

--sem.V_EMP_DEPT -->V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

--시노님 삭제
DROP SYNONYM 시노님명;

--hr계정 비밀번호 : java
--hr계정 비밀번호 변경 : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc15 IDENTIFIED BY java; --본인 계정이 아니라 에러
ALTER USER hr IDENTIFIED BY java;

--dictionary
--접두어 : USER : 사용자 소유 객체
-- ALL : 사용자가 사용가능한 객체
-- DBA : 관리자 관점의 전체 객체(일반 사용자는 사용 불가)
-- V$ : 시스템과 관련된 view (일반 사용자는 사용 불가)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC15','HR'); 
--system계정으로 조회가능

SELECT *
FROM emp
WHERE empno = 7369;


--오라클에서 동일한 SQL이란?
--문자가 하나라도 틀리면 안됨
--다음 SQL들은 같은 결과를 만들어 낼지 몰라도 DBMS에서는
--서로 다른 SQL로 인식된다.
--(system계정의 파일 참고)
SELECT /*bind_test */ * FROM emp;
Select /*bind_test */ * FROM emp; --결과가 같으나 서로 다른 sql로 인식
Select /*bind_test */ *  FROM emp; --결과가 같으나 서로 다른 sql로 인식

Select /*bind_test */ * FROM emp WHERE empno = 7369;
Select /*bind_test */ * FROM emp WHERE empno = 7499;
Select /*bind_test */ * FROM emp WHERE empno = 7521; --실행계획이 각각 나옴
Select /*bind_test */ * FROM emp WHERE empno = :empno; --바인드변수 사용한 sql은 실행계획이 하나만 나옴 , 실제 값이 뭔지 몰라도 동일한 형태