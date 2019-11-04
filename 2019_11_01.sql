--복습
--WHERE
--연산자
--비교 : =, !=, <>, >=, >, <=, <
--BETWEEN start AND end
--IN (set)
--LIKE 'S%' (% : 다수의 문자열과 매칭, _ : 정확히 한글자 매칭)
--IS NULL (!= NULL)
--AND, OR, NOT

--emp 테이블에서 입사일자가 1981년 6월 1일부터 1986년 12월 31일 사이에 있는 직원 조회
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01','YYYY/MM/DD') AND  TO_DATE('1986/12/31','YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') AND  hiredate <= TO_DATE('1986/12/31','YYYY/MM/DD');

--emp 테이블에서 관리자(mgr)이 있는 직원만 조회
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--실습13(LIKE사용X)
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno =78 OR (empno BETWEEN 780 AND 789) OR  (empno BETWEEN 7800 AND 7899);

--실습14
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));


--order by 컬럼명 | 별칭 | 컬럼인덱스 [ASC | DESC]
--order by 구문은 WHERE절 다음에 기술
--WHERE절이 없을 경우 FROM절 다음에 기술

--job을 기준으로 내림차순으로 정렬, 만약 job이 같을 경우
--사번(empno)으로 올림차순 정렬
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--별칭으로 정렬하기
--사원 번호(empno), 사원명(ename), 연봉(sal * 12) as year_sal
--year_sal 별칭으로 오름차순 정렬
SELECT empno, ename, sal, sal* 12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT절 컬럼 순서 인덱스로 정렬
SELECT empno, ename, sal, sal* 12 as year_sal
FROM emp
ORDER BY 4;

--orderby1
SELECT * 
FROM dept
ORDER BY DNAME;


commit;
SELECT * 
FROM dept
ORDER BY DNAME desc;

--orderby2
SELECT *
FROM emp
ORDER BY comm desc, empno asc;

--orderby3
SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job , empno desc;

--orderby4
SELECT *
FROM emp
WHERE deptno in(10,30) and sal > 1500
ORDER BY ename desc;

--ROUNUM 
--아직 읽지 않은 데이터가 존재하는 조건은 안됨
--1번부터 읽어야함!!!!!
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM < 10;

--emp테이블에서 사번(empno), 이름(ename)을 급여기준으로 오름차순 정렬하고 정렬된 결과순으로 ROWNUM
SELECT  empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM(SELECT  empno, ename, sal FROM emp ORDER BY sal) a;
-- FROM절 자체를 a라고 별칭짓는다.

--row_1
SELECT rownum, A.*
FROM (SELECT empno,ename,sal FROM emp ORDER BY sal)A 
WHERE rownum <=10;

--row_2
SELECT *
FROM
(SELECT ROWNUM rn, B.*
FROM (SELECT empno, ename,sal FROM emp ORDER BY sal) B)
WHERE rn >= 11 and rn <= 14;

--FUNCTION
--DUAL 테이블 조회
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--문자열 대소문자 관련 함수
--LOWER,UPPER,INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'),INITCAP('hello, world')
FROM dual;


SELECT LOWER('Hello, World'), UPPER('Hello, World'),INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION은 WHERE절에서도 사용가능
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
--개발자 SQL 칠거지악
--1. 좌변을 가공하지 말아라.
--좌변(TABLE의 컬럼)을 가공하게 되면 INDEX를 정상적으로 사용하지 못함
--Function Based Index -> FBI

--CONCAT : 문자열 결합 - 두개의 문자열을 결합하는 함수
--SUBSTR : 문자열의 부분 문자열
--LENGTH : 문자열의 길이
--INSTR : 문자열에 특정 문자열이 등장하는 첫번째 인덱스
--SELECT CONCAT('HELLO',', WORLD') CONCAT
--LPAD : 문자열에 특정 문자열을  삽입
SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1, 

        --둘 결과 같음
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr1,
        --첫번째로 나타나는 O의 인덱스 반환
        INSTR('HELLO, WORLD', 'O', 6) instr2,
        --6번째 글자 이후에 나타나는 O의 인덱스 반환
        LPAD('HELLO, WORLD', 15, '*') lpad,
        --LPAD(문자열, 전체 문자열길이,문자열이 전체 문자열 길이에 미치치 못할 경우 추가할 문자)
        LPAD('HELLO, WORLD', 15) lpad,
        --저절로 공백
        RPAD('HELLO, WORLD', 15, '*') rpad,
        RPAD('HELLO, WORLD', 15) rpad
FROM dual;

dd







