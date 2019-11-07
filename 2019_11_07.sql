--emp테이블에는 부서번호(deptno)만 존재
--emp테이블에서 부서명을 조회하기 위해서는 dept테이블과 조인을 통해 부서명 조회

--조인 문법 
--ANSI : 테이블 JOIN 테이블2 ON(테이블.COL = 테이블2.COL)
--      emp JOIN dept ON(emp.deptno = dept.deptno)
--ORACLE : FROM 테이블, 테이블2 WHERE 테이블.COL = 테이블2.COL
--      FROM emp, dept WHERE emp.deptno = dept.deptno

--사원번호, 사원명, 부서번호, 부서명
SELECT empno, ename, dept.deptno, dept.dname
FROM emp JOIN dept ON(emp.deptno = dept.deptno);

SELECT empno, ename, dept.deptno, dept.dname
FROM emp ,dept
WHERE emp.deptno = dept.deptno;

SELECT empno, ename, deptno, dept.dname
FROM emp JOIN dept USING(deptno);

--JOIN2
SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer ,prod 
WHERE buyer_id = prod_buyer
ORDER BY prod_id;

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer JOIN prod ON (buyer_id = prod_buyer)
ORDER BY prod_id;

--JOIN3
SELECT mem_id, mem_name, prod_id, prod_name, cart.cart_qty
FROM member,cart,prod
WHERE mem_id = cart_member AND cart_prod= prod_id;

--쌤
SELECT mem_id, mem_name, prod_id, prod_name, cart.cart_qty
FROM member join cart ON(member.mem_id = cart.cart_member)
JOIN prod ON(cart_prod= prod_id);

--JOIN4
SELECT cycle.cid, cnm,pid,day,cnt
FROM customer JOIN cycle ON cycle.cid = customer.cid AND cnm = 'brown' or cnm ='sally'
ORDER BY cnm, day;

--JOIN5
SELECT cycle.cid, cnm, product.pid, pnm,day,cnt
FROM customer JOIN cycle ON cycle.cid = customer.cid AND cnm = 'brown' or cnm ='sally' 
JOIN product on cycle.pid = product.pid
ORDER BY cnm, day;


--JOIN6
--고객,제품별 애움건수(요일과 관계없이)
SELECT c.cid, c1.cnm, c.pid, p.pnm,c.cnt
FROM
(SELECT cid, pid, SUM(cnt) cnt 
FROM cycle 
GROUP BY cid, pid) c 
    JOIN product p
        ON c.pid = p.pid    
    JOIN customer c1 
        ON(c.cid = c1.cid);

--다른표현1
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid,cnm,product.pid,pnm,cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;


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
SELECT *
FROM product,
(SELECT pid, sum(cnt) cnt
FROM cycle 
GROUP BY pid)a
WHERE a.pid = product.pid;

SELECT product.pid, product.pnm, sum(cnt) cnt
FROM product, cycle
WHERE product.pid =cycle.pid
group by product.pid,  product.pnm;

SELECT product.pid, product.pnm, sum(cnt) cnt
FROM product, cycle
WHERE product.pid = cycle.pid
group by product.pnm, product.pid ;
--JOIN8




