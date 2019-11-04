--���� where 11
--job�� salesman�̰ų� �Ի����ڰ� 1981�� 6�� 1������
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD');

--ROWNUM
SELECT ROWNUM, emp.*
FROM emp;



--ROWNUM�� ���Ĺ���
--ORDER BY���� SELECT�� ���Ŀ� ����
--ROWNUM �����÷��� ����ǰ��� ���ĵǱ� ������ �츮�� ���ϴ´�� ù��° �����ͺ���
--�������� ��ȣ �ο��� ���� �ʴ´�.
SELECT ROWNUM, e.*
FROM emp e
ORDER BY ename;

--ORDER BY���� ������ �ζ��� �並 ����
SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;
    
--ROWNUM : 1������ �о�� �ȴ�.
--WHERE���� ROWNUM���� �߰��� �д°� �Ұ���
--�Ұ����� ���̽�
--WHERE ROWNUM = 2
--WHERE ROWNUM >= 2

--������ ���̽�
--WHERE ROWNUM = 1
--WHERE ROWNUM <= 10

SELECT ROWNUM, a.*
FROM
    (SELECT e.*
    FROM emp e
    ORDER BY ename) a;

--����¡ ó���� ���� �ļ� ROWNUM�� ��Ī�� �ο�, �ش� SQL�� INLINE VIEW�� 
--���ΰ� ��Ī�� ���� ����¡ ó��

SELECT *
FROM
(SELECT ROWNUM rn, a.*
    FROM
        (SELECT e.*
        FROM emp e
        ORDER BY ename) a)
WHERE rn BETWEEN 10 AND 14;



--11/04
--CONCAT : ���ڿ� ���� - �ΰ��� ���ڿ��� �����ϴ� �Լ�
--SUBSTR : ���ڿ��� �κ� ���ڿ�
--LENGTH : ���ڿ��� ����
--INSTR : ���ڿ��� Ư�� ���ڿ��� �����ϴ� ù��° �ε���
--SELECT CONCAT('HELLO',', WORLD') CONCAT
--LPAD : ���ڿ��� Ư�� ���ڿ���  ����
SELECT CONCAT(CONCAT('HELLO',', '),'WORLD') CONCAT,
        SUBSTR('HELLO, WORLD', 0, 5) substr,
        SUBSTR('HELLO, WORLD', 1, 5) substr1, 

        --�� ��� ����
        LENGTH('HELLO, WORLD') length,
        INSTR('HELLO, WORLD', 'O') instr1,
        --ù��°�� ��Ÿ���� O�� �ε��� ��ȯ
        INSTR('HELLO, WORLD', 'O', 6) instr2,
        --6��° ���� ���Ŀ� ��Ÿ���� O�� �ε��� ��ȯ
        LPAD('HELLO, WORLD', 15, '*') lpad,
        --LPAD(���ڿ�, ��ü ���ڿ�����,���ڿ��� ��ü ���ڿ� ���̿� ��ġġ ���� ��� �߰��� ����)
        LPAD('HELLO, WORLD', 15) lpad,
        --������ ����
        RPAD('HELLO, WORLD', 15, '*') rpad,
        RPAD('HELLO, WORLD', 15) rpad,
        --REPLACE(�������ڿ�, ���� ���ڿ����� �����ϰ��� �ϴ� ��� ���ڿ�, ���湮�ڿ�)
       REPLACE( REPLACE('HELLO, WORLD', 'HELLO', 'hello'),'WORLD','world') replace,
       TRIM('  HELLO, WORLD  ') trim,
       --�յ� ���鸸 ����
       TRIM('H' FROM 'HELLO, WORLD') trim2
       --H�� ����
FROM dual;

--ROUND(������, ���� ��� �ڸ���)
SELECT ROUND(105.54,1) r1,-- �Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55,1) r2, -- �Ҽ��� ��° �ڸ����� �ݿø�
       ROUND(105.55,0) r3, -- �Ҽ��� ù° �ڸ����� �ݿø�
       ROUND(105.55,-1) r4 -- ���� ù° �ڸ����� �ݿø�
FROM dual;

SELECT empno, ename, sal, sal/1000, /* ROUND(sal/1000,0) qutient,*/ MOD(sal,1000) reminder
FROM emp;

--TRUNC
SELECT TRUNC(105.54,1) T1,-- �Ҽ��� ��° �ڸ����� ����
       TRUNC(105.55,1) T2, -- �Ҽ��� ��° �ڸ����� ����
       TRUNC(105.55,0) T3, -- �Ҽ��� ù° �ڸ����� ����
       TRUNC(105.55,-1) T4 -- ���� ù° �ڸ����� ����
FROM dual;

--SYSDATE : ����Ŭ�� ��ġ�� ������ ���� ��¥ + �ð������� ����
--������ ���ڰ� ���� �Լ�

--TO_CHAR : DATEŸ���� ���ڿ��� ��ȯ
--��¥�� ���ڿ��� ��ȯ�ÿ� ������ ����
SELECT TO_CHAR(SYSDATE + 5,'YYYY/MM/DD HH24:MI/SS')
FROM dual;

--date �ǽ�1
SELECT TO_DATE('2019/12/31','YY/MM/DD') lastday, 
TO_DATE('2019/12/31','YY/MM/DD')-5 lastday_before5,
SYSDATE now , 
SYSDATE-3 now_before3
FROM dual;

--�� �ٸ� ���
SELECT LASTDAY, LASTDAY-5 AS LASTDAY_BEFORE5, NOW, NOW-3 NOW_BEFORE3
FROM
    (SELECT TO_DATE('2019/12/31','YY/MM/DD') lastday, SYSDATE now 
    FROM dual);

--DATE FORMAT
--�⵵ : YYYY, YY, RRRR, RR :���ڸ��϶��� ���ڸ��϶��� �ٸ�
--YYYY, RRRR�� ����
--�������̸� ��������� ǥ��
--D : ������ ���ڷ� ǥ��(�Ͽ���-1, ������-2,..����� -7)
SELECT TO_CHAR(TO_DATE('35/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
TO_CHAR(TO_DATE('55/03/01','RR/MM/DD'),'YYYY/MM/DD') r1,
--RR�� 50�̻��̸� 19XX�� 50�̸��϶��� 20XX������ ǥ���� ��
TO_CHAR(TO_DATE('35/03/01','YY/MM/DD'),'YYYY/MM/DD') y1,
TO_CHAR(SYSDATE, 'D') d, --������ ������ -2
TO_CHAR(SYSDATE, 'IW') iw, --����
TO_CHAR(TO_DATE('20191228','YYYYMMDD'),'IW') this_year --���� ��������
FROM dual;

--date�ǽ�2
SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH,
TO_CHAR(SYSDATE,'YYYY-MM-DD HH24:MI:SS') DT_DASH_WITH_TIME,
TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

--��¥�� �ݿø�(ROUND), ����(TRUNC)
--�� �Ⱦ���
--ROUND(DATE,'����') YYYY,MM,DD
SELECT ename,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(ROUND(hiredate,'YYYY'),'YYYY/MM/DD HH24:MI:SS') as round_yyyy,--������ �ݿø�
TO_CHAR(ROUND(hiredate,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,
TO_CHAR(ROUND(hiredate-1,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,
TO_CHAR(ROUND(hiredate-2,'MM'),'YYYY/MM/DD HH24:MI:SS') as round_mm,--�Ͽ��� �ݿø�
TO_CHAR(ROUND(hiredate,'DD'),'YYYY/MM/DD HH24:MI:SS') as round_dd --�ð������ݿø�
FROM emp
WHERE ename='SMITH';

--TRUNC
SELECT ename,TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') as hiredate,
TO_CHAR(TRUNC(hiredate,'YYYY'),'YYYY/MM/DD HH24:MI:SS') as trunc_yyyy,--������ ����
TO_CHAR(TRUNC(hiredate,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
TO_CHAR(TRUNC(hiredate-1,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,
TO_CHAR(TRUNC(hiredate-2,'MM'),'YYYY/MM/DD HH24:MI:SS') as trunc_mm,--�Ͽ��� ����
TO_CHAR(TRUNC(hiredate,'DD'),'YYYY/MM/DD HH24:MI:SS') as trunc_dd --�ð����� ����
FROM emp
WHERE ename='SMITH';

--��¥ ���� �Լ� ���� ����~!
--MONTHS_BETWEEN(DATE,DATE)
--19801217~20191104  --> 20191117
SELECT ename, TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') hiredate, MONTHS_BETWEEN(SYSDATE+13,hiredate) months_between ,
MONTHS_BETWEEN(TO_DATE('20191117','YYYYMMDD'),hiredate) months_between 
FROM emp
WHERE ename='SMITH';

--ADD_MONTHS(DATE,NUMBER)
--������ ��� ����
SELECT ename, TO_CHAR(hiredate,'YYYY/MM/DD HH24:MI:SS') hiredate,
ADD_MONTHS(hiredate,467) add_months,
ADD_MONTHS(hiredate,-467) add_months
FROM emp
WHERE ename='SMITH';

--NEXT_DAY(DATE,����) : DATE���� ù��° ������ ��¥
SELECT SYSDATE, NEXT_DAY(SYSDATE, 7) first_sat, --���ó�¥���� ù ����� ����
NEXT_DAY(SYSDATE, '�����') first_sat
FROM dual;

--LAST_DAY(DATE)
SELECT LAST_DAY(SYSDATE) last_day, LAST_DAY(ADD_MONTHS(SYSDATE,1)) last_day_12
FROM dual;

--DATE + ���� = DATE(DATE���� ������ŭ ������ DATE)
--D1 + ���� = D2
--�纯���� D2 ����
--D1 + ���� - D2 = D2 - D2
--D1 + ���� - D2 = 0
--D1 + ���� = D2
--�纯���� D1 ����
--D1 + ���� - D1 = D2 - D1
-- ���� = D2 - D1
-- ��¥���� ��¥�� ���� ���ڰ� ���´�.
SELECT TO_DATE('20191104','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D1,
TO_DATE('20191201','YYYYMMDD') - TO_DATE('20191101','YYYYMMDD') D2,
--201908: 2019�� 8���� �ϼ� : 31
TO_DATE('201908','YYYYMM'),
ADD_MONTHS(TO_DATE('201908','YYYYMM'),1),
ADD_MONTHS(TO_DATE('201908','YYYYMM'),1) - TO_DATE('201908','YYYYMM') D3
FROM dual;


