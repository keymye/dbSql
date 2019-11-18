SELECT *
FROM USER_VIEWS;

SELECT *
FROM ALL_VIEWS
WHERE OWNER = 'PC15';

SELECT *
FROM pc15.V_EMP_DEPT;

--sem�������� ��ȸ������ ���� v_emp_dept view�� hr�������� ��ȸ�ϱ� ���ؼ���
--������.view�̸� �������� ����ؾ��Ѵ�.
--�Ź� �������� ����ϱ� �������Ƿ� synonym�� ���� �ٸ� ��Ī�� ����

CREATE SYNONYM V_EMP_DEPT FOR pc15.V_EMP_DEPT;

--sem.V_EMP_DEPT -->V_EMP_DEPT
SELECT *
FROM V_EMP_DEPT;

--�ó�� ����
DROP SYNONYM �ó�Ը�;

--hr���� ��й�ȣ : java
--hr���� ��й�ȣ ���� : hr
ALTER USER hr IDENTIFIED BY hr;
--ALTER USER pc15 IDENTIFIED BY java; --���� ������ �ƴ϶� ����
ALTER USER hr IDENTIFIED BY java;

--dictionary
--���ξ� : USER : ����� ���� ��ü
-- ALL : ����ڰ� ��밡���� ��ü
-- DBA : ������ ������ ��ü ��ü(�Ϲ� ����ڴ� ��� �Ұ�)
-- V$ : �ý��۰� ���õ� view (�Ϲ� ����ڴ� ��� �Ұ�)

SELECT *
FROM USER_TABLES;

SELECT *
FROM ALL_TABLES;

SELECT *
FROM DBA_TABLES
WHERE OWNER IN ('PC15','HR'); 
--system�������� ��ȸ����

SELECT *
FROM emp
WHERE empno = 7369;


--����Ŭ���� ������ SQL�̶�?
--���ڰ� �ϳ��� Ʋ���� �ȵ�
--���� SQL���� ���� ����� ����� ���� ���� DBMS������
--���� �ٸ� SQL�� �νĵȴ�.
--(system������ ���� ����)
SELECT /*bind_test */ * FROM emp;
Select /*bind_test */ * FROM emp; --����� ������ ���� �ٸ� sql�� �ν�
Select /*bind_test */ *  FROM emp; --����� ������ ���� �ٸ� sql�� �ν�

Select /*bind_test */ * FROM emp WHERE empno = 7369;
Select /*bind_test */ * FROM emp WHERE empno = 7499;
Select /*bind_test */ * FROM emp WHERE empno = 7521; --�����ȹ�� ���� ����
Select /*bind_test */ * FROM emp WHERE empno = :empno; --���ε庯�� ����� sql�� �����ȹ�� �ϳ��� ���� , ���� ���� ���� ���� ������ ����