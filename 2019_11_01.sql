--����
--WHERE
--������
--�� : =, !=, <>, >=, >, <=, <
--BETWEEN start AND end
--IN (set)
--LIKE 'S%' (% : �ټ��� ���ڿ��� ��Ī, _ : ��Ȯ�� �ѱ��� ��Ī)
--IS NULL (!= NULL)
--AND, OR, NOT

--emp ���̺��� �Ի����ڰ� 1981�� 6�� 1�Ϻ��� 1986�� 12�� 31�� ���̿� �ִ� ���� ��ȸ
SELECT *
FROM emp
WHERE hiredate BETWEEN TO_DATE('1981/06/01','YYYY/MM/DD') AND  TO_DATE('1986/12/31','YYYY/MM/DD');

SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD') AND  hiredate <= TO_DATE('1986/12/31','YYYY/MM/DD');

--emp ���̺��� ������(mgr)�� �ִ� ������ ��ȸ
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

--�ǽ�13(LIKE���X)
SELECT *
FROM emp
WHERE job = 'SALESMAN' OR empno =78 OR (empno BETWEEN 780 AND 789) OR  (empno BETWEEN 7800 AND 7899);

--�ǽ�14
SELECT *
FROM emp
WHERE job = 'SALESMAN'
OR (empno LIKE ('78%') AND hiredate >= TO_DATE('1981/06/01','YYYY/MM/DD'));


--order by �÷��� | ��Ī | �÷��ε��� [ASC | DESC]
--order by ������ WHERE�� ������ ���
--WHERE���� ���� ��� FROM�� ������ ���

--job�� �������� ������������ ����, ���� job�� ���� ���
--���(empno)���� �ø����� ����
SELECT *
FROM emp
ORDER BY job DESC, empno ASC;

--��Ī���� �����ϱ�
--��� ��ȣ(empno), �����(ename), ����(sal * 12) as year_sal
--year_sal ��Ī���� �������� ����
SELECT empno, ename, sal, sal* 12 as year_sal
FROM emp
ORDER BY year_sal;

--SELECT�� �÷� ���� �ε����� ����
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
--���� ���� ���� �����Ͱ� �����ϴ� ������ �ȵ�
--1������ �о����!!!!!
SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM < 10;

--emp���̺��� ���(empno), �̸�(ename)�� �޿��������� �������� �����ϰ� ���ĵ� ��������� ROWNUM
SELECT  empno, ename, sal, ROWNUM
FROM emp
ORDER BY sal;

SELECT ROWNUM, a.*
FROM(SELECT  empno, ename, sal FROM emp ORDER BY sal) a;
-- FROM�� ��ü�� a��� ��Ī���´�.

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
--DUAL ���̺� ��ȸ
SELECT 'HELLO WORLD' as msg
FROM DUAL;

SELECT 'HELLO WORLD'
FROM emp;

--���ڿ� ��ҹ��� ���� �Լ�
--LOWER,UPPER,INITCAP
SELECT LOWER('Hello, World'), UPPER('Hello, World'),INITCAP('hello, world')
FROM dual;


SELECT LOWER('Hello, World'), UPPER('Hello, World'),INITCAP('hello, world')
FROM emp
WHERE job = 'SALESMAN';

--FUNCTION�� WHERE�������� ��밡��
SELECT *
FROM emp
WHERE ename = UPPER('smith');

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith';
--������ SQL ĥ������
--1. �º��� �������� ���ƶ�.
--�º�(TABLE�� �÷�)�� �����ϰ� �Ǹ� INDEX�� ���������� ������� ����
--Function Based Index -> FBI

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
        RPAD('HELLO, WORLD', 15) rpad
FROM dual;

dd







