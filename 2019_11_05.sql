--��� �Ķ���Ͱ� �־����� �� �ش����� �ϼ��� ���ϴ� ����
--201911 --> 30 / 201912 -->31

--�� �� ���� �� �������� ���� = �ϼ�
--������ ��¥ ���� �� --> DD�� ����
SELECT TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')),'DD') day_cnt
FROM dual;

SELECT :yyyymm as param,TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') dt
FROM dual; --���ε� �Է� �� ����

--������ ����ȯ
SELECT *
FROM emp
WHERE empno = '7369';

--�����ȹ ���¹��
explain plan for
SELECT *
FROM emp
WHERE empno = '7369';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

--NUMBER����ȯ
SELECT empno, ename, sal, TO_CHAR(sal,'L000999,999.99') sal_fmt
FROM emp;

--function null
--nvl(coll, coll�� null�� ��� ��ü�� ��)
--nvl(comm,0) -> comm�� ���̸� 0���� �ٲ��
SELECT empno, ename, sal, comm, nvl(comm, 0) nvl_comm, 
sal + comm, 
sal + nvl(comm,0),
nvl(sal + comm,0)
FROM emp;

--nvl2(coll,coll�� null�� �ƴ� ��� ǥ���Ǵ� ��, coll null�� ��� ǥ���Ǵ� ��)
SELECT empno, ename, sal, comm, NVL2(comm,comm,0) + sal
FROM emp;

--NULLIF(expr1, expr2)
--expr1 == expr2 ������ null
--else : expr1
SELECT empno, ename, sal, comm, NULLIF(sal, 1250)
FROM emp;

--COALESCE(expr1, expr2, expr3...) 
--�Լ� ���� �� ���� ó������ �����ϴ� null�� �ƴѰ� 
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
--����⵵ �������!
SELECT empno, ename, hiredate, 
    CASE
        WHEN MOD(TO_CHAR(hiredate,'YY')-TO_CHAR(SYSDATE,'YY'),2)=0 THEN '�ǰ����� �����'
        ELSE '�ǰ����� ������'
    END contacttodoctor
FROM emp;

SELECT empno,ename,hiredate, 
DECODE(MOD(TO_CHAR(hiredate,'YY')-TO_CHAR(SYSDATE,'YY'),2),0,'�ǰ����� �����',1,'�ǰ����� ������')
contacttodoctor
FROM emp;

--���ش� ¦���ΰ� Ȧ���ΰ�
--1.���� �⵵ ���ϱ�
--2.���� �⵵�� ¦������ ���
--����� 2�� ������ ���������׻� 2���� �۴�
SELECT DECODE(MOD(TO_CHAR(SYSDATE,'YYYY'),2),0,'¦����',1,'Ȧ����') year
FROM dual;

--emp ���̺��� �Ի����ڰ� Ȧ�������� ¦��������Ȯ��
SELECT empno, ename, hiredate,
    case
        when MOD(TO_CHAR(SYSDATE,'YYYY'),2) = MOD(TO_CHAR(hiredate,'YYYY'),2) then '�ǰ����� ���'
        else '�ǰ����� ����'
    end contact_to_doctor
FROM emp;

--cond3
SELECT userid,usernm,alias,reg_dt,
CASE
        WHEN MOD(TO_CHAR(SYSDATE,'YYYY'),2) = MOD(TO_CHAR(reg_dt,'YYYY'),2) then '�ǰ����� ���'
        ELSE '�ǰ����� ����'
END contact_to_doctor
FROM users;

--�ٸ����
SELECT userid,usernm,alias,reg_dt,
DECODE(MOD(TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(reg_dt,'YYYY'),2),0,'�ǰ����� ���','�ǰ����� ����')
FROM users;


--�׷��Լ�(AVG,MAX,MIN,SUM,COUNT)
--�׷��Լ��� null���� ����󿡼� �����Ѵ�.
--sum(comm), count(*), count(mgr)
--������ ���� ���� �޿��� �޴»��
--������ ���� ���� �޿��� �޴»��
--������ �޿� ���(�Ҽ��� ��°�ڸ������������� --> �Ҽ��� ��°�ڸ����� �ݿø�)
SELECT MAX(sal) max_sal, MIN(sal) min_sal,ROUND(AVG(sal),2) avg_sal,sum(sal) sum_sal,
COUNT(*) emp_cnt, COUNT(sal) sal_cnt, COUNT(mgr) mgr_cnt, SUM(comm) comm_sum
FROM emp;

--�μ��� ���� ���� �޿��� �޴� ����� �޿�
--GROUP BY���� ������� ���� �÷��� SELECT���� ����� ��� ����
--�׷�ȭ�� ������� ���ڿ��̳� ����� �ü��ִ�.
SELECT deptno, 'test', 1,MAX(sal) max_sal, MIN(sal) min_sal,
ROUND(AVG(sal),2) avg_sal,
sum(sal) sum_sal,
COUNT(*) emp_cnt, 
COUNT(sal) sal_cnt, 
COUNT(mgr) mgr_cnt, 
SUM(comm) comm_sum
FROM emp
GROUP BY deptno;

--�μ��� �ִ� �޿�
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











