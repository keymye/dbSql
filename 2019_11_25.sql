--member 테이블을 이용하여 member2 테이블을 생성
--member2 테이블에서
--김은대 회원(mem_id = 'a001')의 직업(mem_job)을 '군인'으로 변경후
--commit하고 조회
CREATE TABLE member2 AS
SELECT* FROM member;

UPDATE member2 SET mem_job = '군인' WHERE mem_id = 'a001';
commit;

SELECT mem_id, mem_name, mem_job
FROM member2 WHERE mem_id = 'a001';



--제품별 제품 구매 수량 합계, 제품 구입 금액 합계
--VW_PROD_BUY(view생성)
CREATE OR REPLACE VIEW VW_PROD_BUY AS
(SELECT  buy_prod, prod_name, buy_qty, buy_cost
FROM prod,
(SELECT buy_prod, SUM(buy_qty) buy_qty, sum(buy_cost) buy_cost
FROM buyprod
GROUP BY buy_prod) a
WHERE prod_id = a.buy_prod);

SELECT * FROM user_views;

