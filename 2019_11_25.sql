--member ���̺��� �̿��Ͽ� member2 ���̺��� ����
--member2 ���̺���
--������ ȸ��(mem_id = 'a001')�� ����(mem_job)�� '����'���� ������
--commit�ϰ� ��ȸ
CREATE TABLE member2 AS
SELECT* FROM member;

UPDATE member2 SET mem_job = '����' WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2 WHERE mem_id = 'a001';



--��ǰ�� ��ǰ ���� ���� �հ�, ��ǰ ���� �ݾ� �հ�
--VW_PROD_BUY(view����)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
(SELECT  buy_prod, prod_name, buy_qty, buy_cost
FROM prod,
(SELECT buy_prod, SUM(buy_qty) buy_qty, sum(buy_cost) buy_cost
FROM buyprod
GROUP BY buy_prod) a
WHERE prod_id = a.buy_prod);

SELECT * FROM user_views;

