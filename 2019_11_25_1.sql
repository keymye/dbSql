--ºÎ¼­º° ·©Å·
SELECT a.ename, a.sal, a.deptno, b.rn
FROM
    (SELECT a.ename, a.sal, a.deptno, rownum j_rn
    FROM
    (SELECT ename, sal, deptno
    FROM emp
    ORDER BY deptno, sal desc) a)a,
    (SELECT b.rn, ROWNUM j_rn
    FROM
    (SELECT a.deptno, b.rn
    FROM
        (SELECT deptno , COUNT(*) cnt-- 3, 5, 6
        FROM emp
        GROUP BY deptno)a,
        (SELECT ROWNUM rn -- 1~14
        FROM emp) b
WHERE a.cnt >= b.rn
ORDER BY a.deptno, b.rn)b)b
WHERE a.j_rn = b.j_rn;


SELECT ename, sal, deptno, ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp;

