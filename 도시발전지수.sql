SELECT* FROM FASTFOOD;

CREATE VIEW f1 AS
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu;

CREATE VIEW f2 AS
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('버거킹','맥도날드','KFC')
GROUP BY sido, sigungu;


SELECT f1.sido, f1.sigungu, ROUND(f2.cnt / f1.cnt,1)avg1
FROM f1 JOIN f2 ON f1.sido = f2.sido AND f1.sigungu = f2.sigungu
ORDER BY avg1 desc;



SELECT a.sido, a.sigungu, ROUND(a.nmg / b.lo,1) 도시발전지수
FROM
(SELECT sido, sigungu, count(*) nmg
FROM fastfood
WHERE gb IN ('버거킹','KFC','맥도날드')
GROUP BY sido, sigungu) a,
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb = '롯데리아'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY 도시발전지수 desc;

