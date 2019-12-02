--WITH
--��ü ������ �޿���� 2073.21
SELECT ROUND(AVG(sal),2)
FROM emp;

--�μ��� ������ �޿� ��� 10 XXXX,20 YYYY, 30 ZZZZ
SELECT *
FROM
    (SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
WHERE d_avgsal > (SELECT ROUND(AVG(sal),2)FROM emp);

--���� ���� WITH���� �����Ͽ� ������ �����ϰ� ǥ���Ѵ�.
WITH dept_avg_sal AS(
    SELECT deptno, ROUND(AVG(sal),2) d_avgsal
    FROM emp
    GROUP BY deptno)
SELECT *
FROM dept_avg_sal
WHERE d_avgsal> (SELECT ROUND(avg(sal),2) FROM emp);


--�޷� �����
--STEP1. �ش� ����� ���� �����
--CONNECT BY LEVEL
--iw : ����ϱ���

--����
select TO_DATE(201911, 'YYYYMM') + (level-1) ��¥, TO_CHAR(TO_DATE(201911, 'YYYYMM') + (level-1),'day') ����,
TO_CHAR(TO_DATE(201911, 'YYYYMM') + (level-1),'d') ��
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(201911, 'YYYYMM')),'DD');

--201911
--DATE + ���� = ���� ���ϱ� ����
--to_date���� �ϱ��� ����
--d : 1�� �Ͽ���
-- ���ڰ� 2�Ϻ��� ������ ������ level-1
SELECT TO_DATE(:YYYYMM, 'YYYYMM') + (level -1) dt,
        TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'iw') iw,
          TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'day') day,
            TO_CHAR(TO_DATE(:YYYYMM, 'YYYYMM') + (level -1), 'd')d
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')),'DD'); --��������¥ (�������� �ٲ�Բ�)
--date�� char������ �ٲ�����Ѵ�.


--SELECT a.*, sysdate, 'test', 
--select a.*
--�׷����� ������ ������ �ϳ����� null�̶� max, min �� �� �ƹ��ų� �ص��ȴ�.
--11��
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
ORDER BY decode(d,1,a.iw+1,a.iw); --��������¥ (�������� �ٲ�Բ�)




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


--��������
--START WITH : ������ ���� �κ��� ����
--CONNECT BY : ������ ���� ������ ����

--����� ��������(���� �ֻ��� ������������ ��� ������ Ž��)
--�ǽ�h_1
SELECT dept_h.* , LEVEL, LPAD(' ',(LEVEL-1)*4,' ') || dept_h.deptnm
FROM dept_h
START WITH deptcd = 'dept0'--START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd; --prior ���� ���� ������(xxȸ��) ,��, �� , ��Ʈ ��� ������� �ٲ�

--�ǽ�h_2
SELECT LEVEL lv, deptcd, LPAD(' ',(LEVEL-1)*4,' ') || deptnm as deptnm, P_DEPTCD
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;










