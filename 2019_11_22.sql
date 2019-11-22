--상향식 계층쿼리
--특정 노드로부터 자신의 부모노드를 탐색(트리 전체 탐색이 아니다.)
--디자인팀(dept0_00_0)을 시작으로 상위부서를 조회
--PRIOR는 내가 현재 읽은 데이터를 의미 하나의 예약어라고 혼동하지 말기
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
--내가 읽은 데이터의 부모코드가 다른행의 부서코드인 것

--실습h_4
SELECT LPAD(' ',(level-1)*4,' ') || s_id AS s_id,value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

--실습h_5
SELECT LPAD(' ',(level-1)*4,' ')|| org_cd as org_cd,no_emp
FROM no_emp
START WITH org_cd='XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;

--상향식(따로따로해야함)

SELECT LPAD(' ',(level-1)*4,' ')|| org_cd as org_cd,no_emp
FROM no_emp
START WITH org_cd='개발2팀'
CONNECT BY PRIOR parent_org_cd = org_cd;

--pruning branch(가지치기)
--계층쿼리에서 where절은 start with, connect by절이 전부 적용된 이후에 실행된다.

--dept_h 테이블을 최상위 노드부터 하향식으로 조회
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--계층쿼리가 완성된 이후 WHERE절이 적용된다.
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '정보기획부'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '정보기획부';

--CONNECT_BY_ROOT(col) : col의 최상위 노드 컬럼 값
--SYS_CONNECT_BY_PATH(col, 구분자) : col의 계층구조 순서를 구분자로 이은 경로
--CONNECT_BY_ISLEAF: 해당 row가 leaf node인지 판별 (1:o, 0:x)
--      .LTRIM을 통해 최상위 노드 왼쪽의 구분자를 없애주는 형태가 일반적
SELECT LPAD(' ',4*(level-1),' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd= 'XX회사'
CONNECT BY PRIOR org_cd = parent_org_cd;


--h6
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq;

--h7 
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER BY seq desc;

--h8 가장최신글이 위로 오도록 정렬
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;
--시블링즈 : 형제노드 잘 유지함

--h9
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title,
        CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
--ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END DESC,SEQ;
ORDER SIBLINGS BY o1 DESC,SEQ;


--쌤꺼
SELECT *
FROM
(SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title,
        CONNECT_BY_ROOT(seq) r_seq
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
ORDER BY r_seq DESC, seq;


SELECT *
FROM board_test;
--글 그룹번호 컬럼 추가해서 푸는방법
ALTER TABLE board_test ADD (gn number);

SELECT seq, LPAD(' ',4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

--해당 행의 옆에 바로 다음 급여 출력하기
SELECT a.ename, a.sal, b.sal l_sal
FROM
    (select ename, sal, rownum rn
        from 
            (select ename, sal
            from emp
            order by sal desc)) a
LEFT OUTER JOIN
    (select ename, sal, rownum rn
        from 
            (select ename, sal
            from emp
            order by sal desc)) b
ON(a.rn+1 = b.rn);