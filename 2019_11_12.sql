INSERT INTO emp (empno,ename,job) VALUES (9999,'brown',null);
rollback;
select * from emp;

desc emp;
--테이블정보 검색하는 또다른 방법 (컬럼명이 모두 대문자)
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

--SELECT 결과(여러건)를 INSERT
INSERT INTO emp (empno, ename)
SELECT deptno, dname
FROM dept;
rollback;

select* from emp;

--UPDATE
UPDATE dept SET dname='대덕IT', loc='ym' --dname 네글자까지
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

--되돌리기
SET TRANSACTION
isolation LEVEL READ COMMITTED;

commit;
select * from dept;
--DML문장을 통해 트랜잭션 시작
INSERT INTO dept
values (99,'ddit','daejeon');

select * from dept;

--DDL : AUTO COMMIT, ROLLBACK이 안된다.
--CREATE
CREATE TABLE ranger_new(
    ranger_no NUMBER,
    ranger_name VARCHAR2(50), --문자 varchar2, char 웬만하면 varchar2사용
    reg_dt DATE DEFAULT sysdate --DEFAULT : SYSDATE
);

desc ranger_new;

--DDL은 ROLLBACK이 적용되지 않는다.
rollback;

INSERT INTO ranger_new (ranger_no, ranger_name)
VALUES (1000,'brown'); --sysdate가 디폴트로 들어감
commit;

select*from ranger_new;

--날짜 타입에서 특정 필드 가져오기
--ex : sysdate에서 년도만 가져오기
SELECT TO_CHAR(sysdate,'YYYY')
FROM dual;

SELECT ranger_no, ranger_name, reg_dt, TO_CHAR(reg_dt,'MM') mm,
            EXTRACT(MONTH FROM reg_dt) mm,
              EXTRACT(YEAR FROM reg_dt) year
              ,  EXTRACT(DAY FROM reg_dt) day
FROM ranger_new;


--제약조건
--DEPT 모방해서 DEPT_TEST생성
desc dept_test;
CREATE TABLE DEPT_TEST (
  deptno number(2) PRIMARY KEY,--DEPTNO를 식별자로 지정(중복X,NULL X)
  dname varchar2(14),
  loc varchar2(13)
);

--primary key 제약조건 확인
--1.deptno컬럼에 null이 들어갈 수 없다.
--2.deptno컬럼에 중복된 값이 들어갈 수 없다.

INSERT INTO dept_test (deptno, dname, loc)
VALUES (null, 'ddit', 'daejeon'); --null안됨

INSERT INTO dept_test
VALUES (1, 'ddit', 'daejeon'); 

INSERT INTO dept_test
VALUES (1, 'ddit2', 'daejeon');--중복값x

rollback;

--사용자 지정 제약조건명을 부여한 PRIMARY KEY
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) CONSTRAINT PK_DEPT_TEST PRIMARY KEY, --제약조건 이름
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

--TABLE CONSTRAINT
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2), 
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    CONSTRAINT PK_DEPT_TEST PRIMARY KEY (deptno, dname) --두개컬럼을 식별자로 보기 때문에(복합키) 아래 insert문은 실행된다.
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
