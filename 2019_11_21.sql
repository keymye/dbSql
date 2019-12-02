--WITH
--전체 직원의 급여평균 2073.21
SELECT ROUND(AVG(sal),2)
FROM emp;

--부서별 직원의 급여 평균 10 XXXX,20 YYYY, 30 ZZZZ
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal),2)FROM emp);

--쿼리 블럭을 WITH절에 선언하여 쿼리를 간단하게 표현한다.
WITH dept_avg_sal AS(
    SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal> (SELECT ROUND(avg(sal),2) FROM emp);


--달력 만들기
--STEP1. 해당 년월의 일자 만들기
--CONNECT BY LEVEL
--iw : 목요일기준

--연습
select TO_DATE(201911, 'YYYYMM') + (level-1) 날짜, TO_CHAR(TO_DATE(201911, 'YYYYMM') + (level-1),'day') 요일,
TO_CHAR(TO_DATE(201911, 'YYYYMM') + (level-1),'d') 일
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(201911, 'YYYYMM')),'DD');

--201911
--DATE + 정수 = 일자 더하기 연산
--to_date연산 일까지 나옴
--d : 1이 일요일
-- 일자가 2일부터 나오기 때문에 level-1
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level -1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'iw') iw,
          TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'day') day,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'd')d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'); --마지막날짜 (동적으로 바뀌게끔)
--date라서 char형으로 바꿔줘야한다.


--SELECT a.*, sysdate, 'test', 
--select a.*
--그룹으로 묶으면 어차피 하나빼고 null이라서 max, min 둘 중 아무거나 해도된다.
--11월
SELECT  decode(d,1,a.iw+1,a.iw) iw,
    MAX(DECODE(D,1,dt)) sun, 
    MAX(DECODE(D,2,dt)) mon, 
    MAX(DECODE(D,3,dt)) tue,
    MAX(DECODE(D,4,dt)) wed, 
    MAX(DECODE(D,5,dt)) thur,
    MAX(DECODE(D,6,dt)) fri,
    MAX(DECODE(D,7,dt)) sat
FROM
(
    SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level -1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'iw') iw,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'd')d        
    FROM dual a
    CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD')
)
 a
GROUP BY decode(d,1,a.iw+1,a.iw)
ORDER BY decode(d,1,a.iw+1,a.iw); --마지막날짜 (동적으로 바뀌게끔)




--calendar1
SELECT * FROM SALES;
SELECT NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '01', SUM(sales))),0) jan,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '02', SUM(sales))),0) feb,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '03', SUM(sales))),0) mar,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '04', SUM(sales))),0) apr,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '05', SUM(sales))),0) may,
        NVL(MAX(DECODE(TO_CHAR(DT,'MM'), '06', SUM(sales))),0) june
FROM SALES
GROUP BY TO_CHAR(DT,'MM');

SELECT * FROM sales;


--계층쿼리
--START WITH : 계층의 시작 부분을 정의
--CONNECT BY : 계층간 연결 조건을 정의

--하향식 계층쿼리(가장 최상위 조직에서부터 모든 조직을 탐색)
--실습h_1
SELECT dept_h.* , LEVEL, LPAD(' ',(LEVEL-1)*4,' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'--START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --prior 현재 읽은 데이터(xx회사) ,부, 팀 , 파트 등등 순서대로 바뀜

--실습h_2
SELECT LEVEL lv, deptcd, LPAD(' ',(LEVEL-1)*4,' ') || deptnm as deptnm, P_DEPTCD
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;










