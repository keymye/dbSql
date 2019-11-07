--emp���̺��� �μ���ȣ(deptno)�� ����
--emp���̺��� �μ����� ��ȸ�ϱ� ���ؼ��� dept���̺�� ������ ���� �μ��� ��ȸ

--���� ���� 
--ANSI : ���̺� JOIN ���̺�2 ON(���̺�.COL = ���̺�2.COL)
--      emp JOIN dept ON(emp.deptno = dept.deptno)
--ORACLE : FROM ���̺�, ���̺�2 WHERE ���̺�.COL = ���̺�2.COL
--      FROM emp, dept WHERE emp.deptno = dept.deptno

--�����ȣ, �����, �μ���ȣ, �μ���
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

--��
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
--��,��ǰ�� �ֿ�Ǽ�(���ϰ� �������)
SELECT c.cid, c1.cnm, c.pid, p.pnm,c.cnt
FROM
(SELECT cid, pid, SUM(cnt) cnt 
FROM cycle 
GROUP BY cid, pid) c 
    JOIN product p
        ON c.pid = p.pid    
    JOIN customer c1 
        ON(c.cid = c1.cid);

--�ٸ�ǥ��1
with cycle_groupby as (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)
SELECT customer.cid,cnm,product.pid,pnm,cnt
FROM cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;


--�ٸ�ǥ��2
SELECT customer.cid,cnm,product.pid,pnm,cnt
FROM (
    SELECT cid, pid, SUM(cnt) cnt
    FROM cycle
    GROUP BY cid, pid
)cycle_groupby, customer, product
WHERE cycle_groupby.cid = customer.cid AND cycle_groupby.pid = product.pid;

--�ٸ�ǥ��3
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




