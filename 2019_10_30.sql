-- SELECT : ��ȸ�� �÷��� ���
--          -��ü �÷� ��ȸ : *
--          -�Ϻ� �÷� : �ش� �÷��� ����(,����)
-- FROM : ��ȸ�� ���̺� ���
-- ������ �����ٿ� ����� �ۼ��ص� �������.
-- �� keyword�� �ٿ��� �ۼ�

-- ��� �÷��� ��ȸ
SELECT * FROM prod;

-- Ư�� �÷��� ��ȸ
SELECT prod_id, prod_name
FROM prod;

--1] 1prod���̺��� ��� �÷���ȸ
SELECT *
FROM 1prod;

--2] buyer���̺��� buyer_id, buyer_name ��ȸ
SELECT buyer_id, buyer_name
FROM buyer;

--3] cart ���̺��� ��� ������ ��ȸ
SELECT *
FROM cart;

--4] member���̺��� mem_id, mem_pass, mem_name ��ȸ
SELECT mem_id, mem_pass, mem_nam FROM member;

--5]remain ���̺��� remain_year, remain_prod, remain_date ��ȸ
-- SELECT remain_year, remain_prod, remain_date FROM remain;

--������ / ��¥����
--date type + ���� : ���ڸ� ���Ѵ�.
--null�� ������ ������ ����� �׻� null�̴�.
SELECT userid, usernm, reg_dt, reg_dt +5 reg_dt_after5 ,reg_dt - 5 as reg_dt_before5
FROM users;

--����
SELECT prod_id as id, prod_name as name   FROM prod;

SELECT lprod_gu as gu, lprod_nm as nm FROM lprod;

SELECT buyer_id as ���̾���̵�, buyer_name as �̸� FROM buyer;

--���ڿ� ����
--java�� +�� sql�� ||
--CONCAT(str, str)�Լ�
--users���̺��� userid, usernm ����
SELECT userid || usernm FROM users;
SELECT CONCAT(userid, usernm) FROM users;

--���ڿ� ���(�÷��� ��� �����Ͱ� �ƴ϶� �����ڰ� ���� �Է��� ���ڿ�)
SELECT '����� ���̵� : ' || userid
FROM users;

--�ǽ� sel_con1]
SELECT *
FROM user_tables;

SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';' as QUERY 
FROM user_tables;

-- desc table

--�ش� ���̺� ���ǵ� �÷��� �˰� ���� ��
--1. desc
--2. select *....
desc emp;

SELECT *FROM emp;


--WHERE��, ���� ������
SELECT *
FROM users
WHERE userid ='brown';

--usernm�� ������ ������ ��ȸ
SELECT *
FROM users
WHERE usernm = '����';






