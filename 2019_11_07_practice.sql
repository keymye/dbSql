1번
SELECT lprod_gu,lprod_nm,prod_id,prod_name
FROM prod JOIN lprod ON prod_lgu = lprod_gu;

2번
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON prod_buyer = buyer_id
ORDER BY prod_id;
--
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer ,prod
WHERE prod_buyer = buyer_id
ORDER BY prod_id;

3번
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON mem_id = cart_member JOIN
prod ON cart_prod = prod_id;
--
SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member,cart,prod 
WHERE mem_id = cart_member AND cart_prod = prod_id;

4번
SELECT cycle.cid,cnm,pid,day,cnt
FROM customer,cycle
WHERE customer.cid = cycle.cid AND cnm IN('brown','sally');
--같은 속성 조건에 넣어~~!!
--
SELECT cid,cnm,pid,day,cnt
FROM customer JOIN cycle USING(cid)
WHERE cnm IN('brown','sally');
--
SELECT cycle.cid,cnm,pid,day,cnt
FROM customer JOIN cycle ON(customer.cid = cycle.cid AND cnm IN('brown','sally'));

5번
SELECT cycle.cid,cnm,product.pid,pnm,day,cnt
FROM customer,cycle,product
WHERE customer.cid = cycle.cid AND cnm IN('brown','sally') AND
cycle.pid = product.pid;
--
SELECT cid,cnm,pid,pnm,day,cnt
FROM customer JOIN cycle USING (cid)
JOIN product USING(pid) 
WHERE cnm IN('brown','sally');
--
SELECT cycle.cid,cnm,product.pid,pnm,day,cnt
FROM customer JOIN cycle ON (customer.cid = cycle.cid AND (cnm ='brown' OR cnm = 'sally'))
JOIN product ON cycle.pid = product.pid;

6번
SELECT a.cid, b.cnm, c.pid, c.pnm,a.cnt
FROM 
(SELECT cid,pid,SUM(cnt) cnt
FROM cycle
GROUP BY cid, pid) a
JOIN product c ON c.pid = a.pid
JOIN customer b ON b.cid = a.cid;

--with cycle_groupby as (
--    SELECT cid, pid, SUM(cnt) cnt
--    FROM cycle
--    GROUP BY cid, pid
--)
--SELECT customer.cid,cnm,product.pid,pnm,cnt
--FROM cycle_groupby, customer, product
--WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;

with cycle_groupby as(
    SELECT cid,pid,SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid, cnm, product.pid, pnm, cnt
--왜 그룹바이의 cid와 pid는 안되는가
FROM cycle_groupby,customer, product
WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;


-- SELECT cid,pid,SUM(cnt) cnt
--    FROM cycle
--    GROUP BY cid, pid;
--select cid 
--FROM customer
--group by cid;

--다른표현2
SELECT customer.cid,cnm,product.pid,pnm,cnt
FROM (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;


--다른표현3
SELECT customer.cid, cnm, cycle.pid, pnm, sum(cnt) cnt
FROM customer, cycle, product
WHERE cycle.cid = customer.cid AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm;

--JOIN7
SELECT a.pid ,pnm, a.cnt
FROM product,
(SELECT pid, sum(cnt) cnt
FROM cycle 
GROUP BY pid)a
WHERE a.pid = product.pid;


SELECT product.pid, pnm, sum(cnt)
FROM cycle,product
WHERE cycle.pid = product.pid
GROUP BY product.pid, pnm;



