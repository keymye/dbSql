--년월 파라미터가 주어졌을 때 해당년월의 일수를 구하는 문제
--201911 --> 30 / 201912 -->31

--한 달 더한 후 원래값을 빼면 = 일수
--마지막 날짜 구한 후 --> DD만 추출
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')),'DD') day_cnt
FROM dual;

SELECT :yyyymm as param,TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') dt
FROM dual; --바인드 입력 후 적용

--묵시적 형변환
SELECT *
FROM emp
WHERE empno = '7369';

--실행계획 보는방법
explain plan for
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--NUMBER형변환
SELECT empno, ename, sal, TO_CHAR(sal,'L000999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll이 null일 경우 대체할 값)
--nvl(comm,0) -> comm이 널이면 0으로 바꿔라
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, 
sal + comm, 
sal + nvl(comm,0),
nvl(sal + comm,0)
FROM emp;

--nvl2(coll,coll이 null이 아닐 경우 표현되는 값, coll null일 경우 표현되는 값)
SELECT empno, ename, sal, comm, NVL2(comm,comm,0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 같으면 null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...) 
--함수 인자 중 가장 처음으로 등장하는 null이 아닌값 
SELECT empno, ename, sal, comm, COALESCE(comm, sal)
FROM emp;

--null fn4
SELECT empno, ename, mgr, NVL(mgr,9999) mgr_n,NVL2(mgr,mgr,9999) mgr_n, coalesce(mgr,9999)mgr_n
FROM emp;

SELECT userid, usernm, NVL2(reg_dt,reg_dt,sysdate)
FROM users;

--case when
SELECT empno,ename, job, sal,
    CASE
        WHEN job='SALESMAN' THEN sal *1.05
        WHEN job='MANAGER' THEN sal *1.10
        WHEN job='PRESIDENT' THEN sal *1.20
        ELSE sal
    END case_sal
FROM emp;

--decode(col,search1,return1,search2, return2...default)
SELECT empno, ename, job, sal, DECODE(job,'SALESMAN',sal*1.05,'MANAGER',sal*1.10,'RESIDENT',sal*1.20,sal) decode_sal
FROM emp;

--con1
SELECT empno, ename, DECODE(deptno,10,'ACCOUNTING',20,'RESEARCH',30,'SALES',40,'OPERATIONS','DDIT') dname
FROM emp;

--cond2
--현재년도 상관없이!
SELECT empno, ename, hiredate, 
    CASE
        WHEN MOD(TO_CHAR(hiredate,'YY')-TO_CHAR(SYSDATE,'YY'),2)=0 THEN '건강검진 대상자'
        ELSE '건강검진 비대상자'
    END contacttodoctor
FROM emp;

SELECT empno,ename,hiredate, 
DECODE(MOD(TO_CHAR(hiredate,'YY')-TO_CHAR(SYSDATE,'YY'),2),0,'건강검진 대상자',1,'건강검진 비대상자')
contacttodoctor
FROM emp;

--올해는 짝수인가 홀수인가
--1.올해 년도 구하기
--2.올해 년도가 짝수인지 계산
--어떤수를 2로 나누면 나머지는항상 2보다 작다
SELECT DECODE(MOD(TO_CHAR(SYSDATE,'YYYY'),2),0,'짝수년',1,'홀수년') year
FROM dual;

--emp 테이블에서 입사일자가 홀수년인지 짝수년인지확인
SELECT empno, ename, hiredate,
    case
        when MOD(TO_CHAR(SYSDATE,'YYYY'),2) = MOD(TO_CHAR(hiredate,'YYYY'),2) then '건강검진 대상'
        else '건강검진 비대상'
    end contact_to_doctor
FROM emp;

--cond3
SELECT userid,usernm,alias,reg_dt,
CASE
        WHEN MOD(TO_CHAR(SYSDATE,'YYYY'),2) = MOD(TO_CHAR(reg_dt,'YYYY'),2) then '건강검진 대상'
        ELSE '건강검진 비대상'
END contact_to_doctor
FROM users;

--다른방법
SELECT userid,usernm,alias,reg_dt,
DECODE(MOD(TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(reg_dt,'YYYY'),2),0,'건강검진 대상','건강검진 비대상')
FROM users;


--그룹함수(AVG,MAX,MIN,SUM,COUNT)
--그룹함수는 null값을 계산대상에서 제외한다.
--sum(comm), count(*), count(mgr)
--직원중 가장 높은 급여를 받는사람
--직원중 가장 낮은 급여를 받는사람
--직원의 급여 평균(소수점 둘째자리까지만나오게 --> 소수점 셋째자리에서 반올림)
SELECT MAX(sal) max_sal, MIN(sal) min_sal,ROUND(AVG(sal),2) avg_sal,sum(sal) sum_sal,
COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt, SUM(comm) comm_sum
FROM emp;

--부서별 가장 높은 급여를 받는 사람의 급여
--GROUP BY절에 기술되지 않은 컬럼이 SELECT절에 기술될 경우 에러
--그룹화와 상관없는 문자열이나 상수는 올수있다.
SELECT deptno, 'test', 1,MAX(sal) max_sal, MIN(sal) min_sal,
ROUND(AVG(sal),2) avg_sal,
sum(sal) sum_sal,
COUNT(*) emp_cnt, 
COUNT(sal) sal_cnt, 
COUNT(mgr) mgr_cnt, 
SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--부서별 최대 급여
SELECT deptno, MAX(sal) max_sal
FROM emp
GROUP BY deptno
HAVING MAX(sal)>3000;

--grp1
SELECT MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal,
COUNT(mgr) count_mgr, 
COUNT(*) count_all
FROM emp;

--grp2
SELECT DEPTNO,MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, SUM(sal) sum_sal, COUNT(sal) count_sal,
COUNT(mgr) count_mgr, 
COUNT(*) count_all
FROM emp
GROUP BY DEPTNO;

--grp3
SELECT DECODE(deptno,10,'ACCOUNTING',
                    20,'RESEARCH',
                    30,'SALES',
                    40,'OPERATIONS'
                    ,'DDIT') dname,
MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
SUM(sal) sum_sal, COUNT(sal) count_sal,
COUNT(mgr) count_mgr, 
COUNT(*) count_all
FROM emp
GROUP BY deptno
ORDER BY dname;


SELECT DECODE(deptno,10,'ACCOUNTING',
                    20,'RESEARCH',
                    30,'SALES',
                    40,'OPERATIONS'
                    ,'DDIT') dname,
MAX(sal) max_sal, MIN(sal) min_sal, ROUND(AVG(sal),2) avg_sal, 
SUM(sal) sum_sal, COUNT(sal) count_sal,
COUNT(mgr) count_mgr, 
COUNT(*) count_all
FROM emp
GROUP BY DECODE(deptno,10,'ACCOUNTING',
                    20,'RESEARCH',
                    30,'SALES',
                    40,'OPERATIONS'
                    ,'DDIT')
ORDER BY dname;
 
--grp4
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm , COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM');











