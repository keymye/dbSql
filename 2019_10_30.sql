-- SELECT : 조회할 컬럼을 명시
--          -전체 컬럼 조회 : *
--          -일부 컬럼 : 해당 컬럼명 나열(,구분)
-- FROM : 조회할 테이블 명시
-- 쿼리를 여러줄에 나누어서 작성해도 상관없다.
-- 단 keyword는 붙여서 작성

-- 모든 컬럼을 조회
SELECT * FROM prod;

-- 특정 컬럼만 조회
SELECT prod_id, prod_name
FROM prod;

--1] 1prod테이블의 모든 컬럼조회
SELECT *
FROM 1prod;

--2] buyer테이블에서 buyer_id, buyer_name 조회
SELECT buyer_id, buyer_name
FROM buyer;

--3] cart 테이블에서 모든 데이터 조회
SELECT *
FROM cart;

--4] member테이블에서 mem_id, mem_pass, mem_name 조회
SELECT mem_id, mem_pass, mem_nam FROM member;

--5]remain 테이블에서 remain_year, remain_prod, remain_date 조회
-- SELECT remain_year, remain_prod, remain_date FROM remain;

--연산자 / 날짜연산
--date type + 정수 : 일자를 더한다.
--null을 포함한 연산의 결과는 항상 null이다.
SELECT userid, usernm, reg_dt, reg_dt +5 reg_dt_after5 ,reg_dt - 5 as reg_dt_before5
FROM users;

--예제
SELECT prod_id as id, prod_name as name   FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm FROM lprod;

SELECT buyer_id as 바이어아이디, buyer_name as 이름 FROM buyer;

--문자열 결합
--java의 +가 sql의 ||
--CONCAT(str, str)함수
--users테이블의 userid, usernm 결합
SELECT userid || usernm FROM users;
SELECT CONCAT(userid, usernm) FROM users;

--문자열 상수(컬럼에 담긴 데이터가 아니라 개발자가 직접 입력한 문자열)
SELECT '사용자 아이디 : ' || userid
FROM users;

--실습 sel_con1]
SELECT *
FROM user_tables;

SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY 
FROM user_tables;

-- desc table

--해당 테이블에 정의된 컬럼을 알고 싶을 때
--1. desc
--2. select *....
desc emp;

SELECT *FROM emp;


--WHERE절, 조건 연산자
SELECT *
FROM users
WHERE userid ='brown';

--usernm이 샐리인 데이터 조회
SELECT *
FROM users
WHERE usernm = '샐리';






