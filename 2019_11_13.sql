--unique table level constraint
CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13),
    
    --constraint 제약조건명 constraint type[(컬럼...)]
    CONSTRAINT uk_dept_test_dname_loc UNIQUE (dname,loc)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
--첫번째 쿼리에 의해 dname, loc값이 중복되므로 두번째 쿼리는 실행되지 못한다.
INSERT INTO dept_test VALUES(2,'ddit','daejeon');


--foreign key참조제약
DROP TABLE dept_test;

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
commit;

--emp_test (empno, ename, deptno)
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test(deptno) --외래키
);
--dept_test 테이블에 1번 부서번호만 존재하고 fk제약을 dept_test.deptno 컬럼을 참조하도록 생성하여 
--1번이외의 부서번호는 emp_test 테이블에 입력될 수 없다.

--emp_test fk테스트 insert
INSERT INTO emp_test VALUES(9999,'brown',1);
--2번 부서는 dept_test테이블에 존재하지 않는 데이터이기 때문에 fk제약에 의해 insert가 정상적으로 동작하지 못한다.
INSERT INTO emp_test VALUES(9998,'sally',2);

--무결성 제약에러 발생시 뭘 해야할까?
--입력하려고 하는 값이 맞는건가? (2번이맞나? 1번아냐?)
-- .부모테이블에 값이 왜 입력안됐는지 확인(dept_test확인)

--fk제약 table level constraint
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
);

--fk제약을 생성하려면 참조하려는 컬럼에 인덱스가 생성되어있어야한다.
DROP TABLE emp_test;
DROP TABLE dept_test; --참조하는 테이블이있기 때문에 자식테이블 먼저 지워야 지울 수 있다.

CREATE TABLE dept_test(
    deptno NUMBER(2), /* PRIMARY KEY -> UNIQUE 제약 X, 인덱스 생성 X */
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4), 
    ename VARCHAR2(10),
    --dept_test.dept_no컬럼에 인덱스가 없기 때문에 정상적으로 fk제약을 생성할 수 없다.
    deptno NUMBER(2) REFERENCES dept_test (deptno)
);

--테이블 삭제
DROP TABLE dept_test;                                                                                                                                                                                                                                                                                       

CREATE TABLE dept_test(
    deptno NUMBER(2) PRIMARY KEY ,
    dname VARCHAR2(14),
    loc VARCHAR2(13)
);

CREATE TABLE emp_test(
    empno NUMBER(4), 
    ename VARCHAR2(10),
    deptno NUMBER(2) REFERENCES dept_test (deptno)
);

INSERT INTO dept_test VALUES(1,'ddit','daejeon');
INSERT INTO emp_test VALUES(9999,'brown',1);
commit;

DELETE emp_test WHERE empno=9999;
--dept_test테이블의 deptno값을 참조하는 데이터가 있을 경우 삭제가 불가능하다.
--즉 자식 테이블에서 참조하는 데이터가 없어야 부모 테이블의 데이터를 삭제하는것이 가능하다.
DELETE dept_test WHERE deptno=1;--삭제됨

--fk제약 옵션
--default : 데이터입력/삭제시 순차적으로 처리해줘야 fk제약을 위배하지 않는다.
--ON DELETE CASCADE : 부모 데이터 삭제시 참조하는 자식 테이블 같이 삭제          
--ON DELETE NULL : 부모 데이터 삭제시 참조하는 자식 테이블 값 NULL설정
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
    ON DELETE CASCADE 
);

SELECT * FROM DEPT_TEST;
/* INSERT INTO dept_test VALUES (1,'ddit','daejeon'); */
INSERT INTO emp_test VALUES (9999,'brown',1);
commit;

--FK 제약 dafault 옵션시에는 부모 테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는
--데이터가 없어야 정상적으로 삭제가 가능
--on delete cascade의 경우 부모테이블 삭제시 참조하는 자식 테이블의 데이터를 같이 삭제
--1.삭제 쿼리가 정상적으로 실행되는지 확인
--2.자식 테이블에 데이터가 삭제 되었는지확인
DELETE dept_test WHERE deptno=1;

SELECT * FROM emp_test;
















--fk제약 ON DELETE SET NULL
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4) PRIMARY KEY,
    ename VARCHAR2(10),
    deptno NUMBER(2),
    CONSTRAINT fk_emp_test_to_dept_test FOREIGN KEY (deptno) REFERENCES dept_test(deptno)
    ON DELETE SET NULL
);

SELECT * FROM DEPT_TEST;
INSERT INTO dept_test VALUES (1,'ddit','daejeon');
INSERT INTO emp_test VALUES (9999,'brown',1);
commit;

--FK 제약 dafault 옵션시에는 부모 테이블의 데이터를 삭제하기 전에 자식 테이블에서 참조하는
--데이터가 없어야 정상적으로 삭제가 가능
--on delete SET NULL의 경우 부모테이블 삭제시 참조하는 자식 테이블의 데이터의 참조 컬럼을 NULL로 수정한다.
--1.삭제 쿼리가 정상적으로 실행되는지 확인
--2.자식 테이블에 데이터가 NULL로 변경 되었는지 확인
DELETE dept_test WHERE deptno=1;

SELECT * FROM emp_test;

--CHECK제약: 컬럼의 값을 정해진 범위, 혹은 값만 들어오게끔 제약
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    sal NUMBER CHECK (sal >= 0)
);
--sal 컬럼은 CHECK제약조건에 의해 0이거나, 0보다 큰 값만 입력이 가능하다.
INSERT INTO emp_test VALUES(9999,'brown',10000);
INSERT INTO emp_test VALUES(9998,'sally',-10000);

DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    --emp_gb : 01 - 정직원, 02 - 인턴
    emp_gb VARCHAR2(2) CHECK (emp_gb IN ('01','02'))
);

INSERT INTO emp_test VALUES(9999,'brown','01');
--emp_gb 컬럼 체크제약에 의해 01,02가 아닌 값은 입력될 수 없다.
INSERT INTO emp_test VALUES(9998,'sally','03');

--SELECT 결과를 이용한 TABLE 생성
--CREATE TABLE 테이블명 AS 
--SELECT 쿼리
--> CTAS

DROP TABLE emp_test;
DROP TABLE dept_test;

--CUSTOMER 테이블을 사용하여 CUSTOMER_TEST 테이블로 생성
--CUSTOMER 테이블의 데이터도 같이 복제 (primary key, foreign key 복제가 안됨)
CREATE TABLE customer_test AS
SELECT *
FROM customer;

SELECT *
FROM customer_test;

CREATE TABLE test AS
SELECT sysdate dt
FROM dual;

DROP TABLE test;

--데이터는 복제하지 않고 특정 테이블의 컬럼형식만 가져올 수 없을까?
DROP TABLE customer_test;
CREATE TABLE customer_test AS
SELECT *
FROM customer
--WHERE cid =-99;
WHERE 1=2; --절대 참일 수 없는 조건


--check제약조건도 복사되지 않음
CREATE TABLE test (
    c1 VARCHAR2(2) CHECK (c1 in ('01','02'))
);

CREATE TABLE test2 AS
SELECT * FROM test;


--테이블 변경 
--컬럼변경 : varchar2 사이즈 외엔 변경제약이 심하다

--새로운 컬럼추가
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10)
);
--신규 컬럼 추가
ALTER TABLE emp_test ADD (deptno NUMBER(2));
DESC emp_test;

--기존 컬럼 변경(테이블에 데이터가 없는 상황)
ALTER TABLE emp_test MODIFY(ename VARCHAR2(200)); --됨
desc emp_test;

ALTER TABLE emp_test MODIFY(ename NUMBER); --됨
desc emp_test;

--데이터가 있는 상황에서 컬럼 변경 : 제한적이다.
INSERT INTO emp_test VALUES(9999,1000,10);
COMMIT;

--데이터 타입을 변경하기 위해서는 컬럼 값이 비어있어야 한다.
ALTER TABLE emp_test MODIFY(ename VARCHAR2(10));--안됨

--DEFAULT 설정
DESC emp_test;
ALTER TABLE emp_test MODIFY (deptno DEFAULT 10);

--컬럼명 변경
ALTER TABLE emp_test RENAME COLUMN deptno TO dno;

--컬럼 삭제(DROP)
ALTER TABLE emp_test DROP COLUMN dno;
ALTER TABLE emp_test DROP (dno);
DESC emp_test;

--테이블 변경 : 제약조건 추가
ALTER TABLE emp_test ADD CONSTRAINT pk_emp_test PRIMARY KEY (empno);

--제약조건 삭제
ALTER TABLE emp_test DROP CONSTRAINT pk_emp_test;

--UNIQUE 제약 - empno
ALTER TABLE emp_test ADD CONSTRAINT uk_emp_test UNIQUE (empno);

--UNIQUE 제약 삭제 : uk_emp_test
ALTER TABLE emp_test DROP CONSTRAINT uk_emp_test;

--FOREIGN KEY 추가
--실습
--1. DEPT테이블의 DEPTNO컬럼으로 PRIMARY KEY 제약을 테이블 변경
--DDL을 통해 생성
ALTER TABLE dept ADD CONSTRAINT pk_dept PRIMARY KEY(deptno);

--2. EMP 테이블의 EMPNO컬럼으로 PRIMARY KEY 제약을 테이블 변경
--DDL을 통해 생성
ALTER TABLE emp ADD CONSTRAINT pk_emp PRIMARY KEY(empno);

--3. EMP테이블의 DEPTNO컬럼으로 DEPT 테이블의 DEPTNO컬럼을 참조하는 FK제약을 테이블, 변경 DDL을 통해 생성
ALTER TABLE emp ADD CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);

--emp_test -> dept(deptno) fk 제약
DROP TABLE emp_test;
CREATE TABLE emp_test(
    empno NUMBER(4),
    ename VARCHAR2(10),
    deptno NUMBER(2)
);
ALTER TABLE emp_test ADD CONSTRAINT fk_emp_test_dept FOREIGN KEY (deptno) REFERENCES dept(deptno);

--CHECK 제약 추가 (ename 길이 체크, 길이가 3글자 이상)
ALTER TABLE emp_test ADD CONSTRAINT check_ename_len CHECK (length(ename)>3);
INSERT INTO emp_test VALUES (9999,'brown',10);
INSERT INTO emp_test VALUES (9998,'br',10); --제약조건에 걸림
rollback;

--CHECK 제약 제거
ALTER TABLE emp_test DROP CONSTRAINT check_ename_len;

--NOT NULL 제약 추가
ALTER TABLE emp_test MODIFY (ename NOT NULL);

--NOT NULL 제약 제거
ALTER TABLE emp_test MODIFY(ename NULL);







