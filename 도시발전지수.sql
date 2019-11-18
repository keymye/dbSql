SELECT* FROM FASTFOOD;

CREATE VIEW f1 AS
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb = '�Ե�����'
GROUP BY sido, sigungu;

CREATE VIEW f2 AS
SELECT sido, sigungu, COUNT(*) cnt
FROM fastfood
WHERE gb IN ('����ŷ','�Ƶ�����','KFC')
GROUP BY sido, sigungu;


SELECT f1.sido, f1.sigungu, ROUND(f2.cnt / f1.cnt,1)avg1
FROM f1 JOIN f2 ON f1.sido = f2.sido AND f1.sigungu = f2.sigungu
ORDER BY avg1 desc;



SELECT a.sido, a.sigungu, ROUND(a.nmg / b.lo,1) ���ù�������
FROM
(SELECT sido, sigungu, count(*) nmg
FROM fastfood
WHERE gb IN ('����ŷ','KFC','�Ƶ�����')
GROUP BY sido, sigungu) a,
(SELECT sido, sigungu, count(*) lo
FROM fastfood
WHERE gb = '�Ե�����'
GROUP BY sido, sigungu) b
WHERE a.sido = b.sido
AND a.sigungu = b.sigungu
ORDER BY ���ù������� desc;

