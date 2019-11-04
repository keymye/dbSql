--복습 where 11
--job이 salesman이거나 입사일자가 1981년 6월 1일이후
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--ROWNUM
SELECT ROWNUM, emp.*
FROM emp;



--ROWNUM과 정렬문제
--ORDER BY절은 SELECT절 이후에 동작
--ROWNUM 가상컬럼이 적용되고나서 정렬되기 때문에 우리가 원하는대로 첫번째 데이터부터
--순차적인 번호 부여가 되질 않는다.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY절을 포함한 인라인 뷰를 구성
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1번부터 읽어야 된다.
--WHERE절에 ROWNUM값을 중간만 읽는건 불가능
--불가능한 케이스
--WHERE ROWNUM = 2
--WHERE ROWNUM >= 2

--가능한 케이스
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

--페이징 처리를 위한 꼼수 ROWNUM에 별칭을 부여, 해당 SQL을 INLINE VIEW로 
--감싸고 별칭을 통해 페이징 처리

SELECT *
FROM
(SELECT ROWNUM rn, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;



--11/04
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
        RPAD('HELLO, WORLD', 15) rpad,
        --REPLACE(원본문자열, 원본 문자열에서 변경하고자 하는 대상 문자열, 변경문자열)
       REPLACE( REPLACE('HELLO, WORLD', 'HELLO', 'hello'),'WORLD','world') replace,
       TRIM('  HELLO, WORLD  ') trim,
       --앞뒤 공백만 제거
       TRIM('H' FROM 'HELLO, WORLD') trim2
       --H만 제거
FROM dual;

--ROUND(대상숫자, 절삭 결과 자리수)
SELECT ROUND(105.54,1) r1,-- 소수점 둘째 자리에서 반올림
       ROUND(105.55,1) r2, -- 소수점 둘째 자리에서 반올림
       ROUND(105.55,0) r3, -- 소수점 첫째 자리에서 반올림
       ROUND(105.55,-1) r4 -- 정수 첫째 자리에서 반올림
FROM dual;

SELECT empno, ename, sal, sal/1000, /* ROUND(sal/1000,0) qutient,*/ MOD(sal,1000) reminder
FROM emp;

--TRUNC
SELECT TRUNC(105.54,1) T1,-- 소수점 둘째 자리에서 절삭
       TRUNC(105.55,1) T2, -- 소수점 둘째 자리에서 절삭
       TRUNC(105.55,0) T3, -- 소수점 첫째 자리에서 절삭
       TRUNC(105.55,-1) T4 -- 정수 첫째 자리에서 절삭
FROM dual;

--SYSDATE : 오라클이 설치된 서버의 현재 날짜 + 시간정보를 리턴
--별도의 인자가 없는 함수

--TO_CHAR : DATE타입을 문자열로 변환
--날짜를 문자열로 변환시에 포맷을 지정
SELECT TO_CHAR(SYSDATE + 5,'YYYY/MM/DD HH24:MI/SS')
FROM dual;

--date 실습1
SELECT TO_DATE('2019/12/31','YY/MM/DD') lastday, 
TO_DATE('2019/12/31','YY/MM/DD')-5 lastday_before5,
SYSDATE now , 
SYSDATE-3 now_before3
FROM dual;

--또 다른 방법
SELECT LASTDAY, LASTDAY-5 AS LASTDAY_BEFORE5, NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31','YY/MM/DD') lastday, SYSDATE now 
    FROM dual);

--DATE FORMAT
--년도 : YYYY, YY, RRRR, RR :두자리일때랑 네자리일때랑 다름
--YYYY, RRRR은 동일
--가급적이면 명시적으로 표현
--D : 요일을 숫자로 표기(일요일-1, 월요일-2,..토요일 -7)
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
--RR은 50이상이면 19XX년 50미만일때는 20XX년으로 표현이 됨
TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'),'YYYY/MM/DD') y1,
TO_CHAR(SYSDATE, 'D') d, --오늘은 월요일 -2
TO_CHAR(SYSDATE, 'IW') iw, --주차
TO_CHAR(TO_DATE('20191228','YYYYMMDD'),'IW') this_year --올해 마지막주
FROM dual;

--date실습2
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH,
TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

--날짜의 반올림(ROUND), 절삭(TRUNC)
--잘 안쓰임
--ROUND(DATE,'포맷') YYYY,MM,DD
SELECT ename,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(ROUND(hiredate,'YYYY'),'YYYY/MM/DD HH24:MI:SS') as round_yyyy,--월에서 반올림
TO_CHAR(ROUND(hiredate,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,
TO_CHAR(ROUND(hiredate-1,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,
TO_CHAR(ROUND(hiredate-2,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,--일에서 반올림
TO_CHAR(ROUND(hiredate,'DD'),'YYYY/MM/DD HH24:MI:SS') as round_dd --시간에서반올림
FROM emp
WHERE ename='SMITH';

--TRUNC
SELECT ename,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(TRUNC(hiredate,'YYYY'),'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,--월에서 절삭
TO_CHAR(TRUNC(hiredate,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
TO_CHAR(TRUNC(hiredate-1,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
TO_CHAR(TRUNC(hiredate-2,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,--일에서 절삭
TO_CHAR(TRUNC(hiredate,'DD'),'YYYY/MM/DD HH24:MI:SS') as trunc_dd --시간에서 절삭
FROM emp
WHERE ename='SMITH';

--날짜 연산 함수 자주 사용됨~!
--MONTHS_BETWEEN(DATE,DATE)
--19801217~20191104  --> 20191117
SELECT ename, TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') hiredate, MONTHS_BETWEEN(SYSDATE+13,hiredate) months_between ,
MONTHS_BETWEEN(TO_DATE('20191117','YYYYMMDD'),hiredate) months_between 
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE,NUMBER)
--음수일 경우 과거
SELECT ename, TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') hiredate,
ADD_MONTHS(hiredate,467) add_months,
ADD_MONTHS(hiredate,-467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(DATE,요일) : DATE이후 첫번째 요일의 날짜
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --오늘날짜이후 첫 토요일 일자
NEXT_DAY(SYSDATE, '토요일') first_sat
FROM dual;

--LAST_DAY(DATE)
SELECT LAST_DAY(SYSDATE) last_day, LAST_DAY(ADD_MONTHS(SYSDATE,1)) last_day_12
FROM dual;

--DATE + 정수 = DATE(DATE에서 정수만큼 이후의 DATE)
--D1 + 정수 = D2
--양변에서 D2 차감
--D1 + 정수 - D2 = D2 - D2
--D1 + 정수 - D2 = 0
--D1 + 정수 = D2
--양변에서 D1 차감
--D1 + 정수 - D1 = D2 - D1
-- 정수 = D2 - D1
-- 날짜에서 날짜를 빼면 일자가 나온다.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D1,
TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D2,
--201908: 2019년 8월의 일수 : 31
TO_DATE('201908','YYYYMM'),
ADD_MONTHS(TO_DATE('201908','YYYYMM'),1),
ADD_MONTHS(TO_DATE('201908','YYYYMM'),1) - TO_DATE('201908','YYYYMM') D3
FROM dual;


