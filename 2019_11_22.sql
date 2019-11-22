--����� ��������
--Ư�� ���κ��� �ڽ��� �θ��带 Ž��(Ʈ�� ��ü Ž���� �ƴϴ�.)
--��������(dept0_00_0)�� �������� �����μ��� ��ȸ
--PRIOR�� ���� ���� ���� �����͸� �ǹ� �ϳ��� ������� ȥ������ ����
SELECT *
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY PRIOR p_deptcd = deptcd;
--���� ���� �������� �θ��ڵ尡 �ٸ����� �μ��ڵ��� ��

--�ǽ�h_4
SELECT LPAD(' ',(level-1)*4,' ') || s_id AS s_id,value
FROM h_sum
START WITH s_id = '0'
CONNECT BY PRIOR s_id = ps_id;

--�ǽ�h_5
SELECT LPAD(' ',(level-1)*4,' ')|| org_cd as org_cd,no_emp
FROM no_emp
START WITH org_cd='XXȸ��'
CONNECT BY PRIOR org_cd = parent_org_cd;

--�����(���ε����ؾ���)

SELECT LPAD(' ',(level-1)*4,' ')|| org_cd as org_cd,no_emp
FROM no_emp
START WITH org_cd='����2��'
CONNECT BY PRIOR parent_org_cd = org_cd;

--pruning branch(����ġ��)
--������������ where���� start with, connect by���� ���� ����� ���Ŀ� ����ȴ�.

--dept_h ���̺��� �ֻ��� ������ ��������� ��ȸ
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

--���������� �ϼ��� ���� WHERE���� ����ȴ�.
SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
WHERE deptnm != '������ȹ��'
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd;

SELECT deptcd, LPAD(' ', 4*(level-1),' ') || deptnm deptnm
FROM dept_h
START WITH deptcd='dept0'
CONNECT BY PRIOR deptcd = p_deptcd AND deptnm != '������ȹ��';

--CONNECT_BY_ROOT(col) : col�� �ֻ��� ��� �÷� ��
--SYS_CONNECT_BY_PATH(col, ������) : col�� �������� ������ �����ڷ� ���� ���
--CONNECT_BY_ISLEAF: �ش� row�� leaf node���� �Ǻ� (1:o, 0:x)
--      .LTRIM�� ���� �ֻ��� ��� ������ �����ڸ� �����ִ� ���°� �Ϲ���
SELECT LPAD(' ',4*(level-1),' ') || org_cd org_cd,
        CONNECT_BY_ROOT(org_cd) root_org_cd,
        LTRIM(SYS_CONNECT_BY_PATH(org_cd,'-'),'-') path_org_cd,
        CONNECT_BY_ISLEAF isleaf
FROM no_emp
START WITH org_cd= 'XXȸ��'
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

--h8 �����ֽű��� ���� ������ ����
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY seq desc;
--�ú��� : ������� �� ������

--h9
SELECT seq, LPAD(' ', 4*(level-1), ' ') || title title,
        CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END o1
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
--ORDER SIBLINGS BY CASE WHEN parent_seq IS NULL THEN seq ELSE 0 END DESC,SEQ;
ORDER SIBLINGS BY o1 DESC,SEQ;


--�ܲ�
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
--�� �׷��ȣ �÷� �߰��ؼ� Ǫ�¹��
ALTER TABLE board_test ADD (gn number);

SELECT seq, LPAD(' ',4*(level-1),' ') || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER SIBLINGS BY gn DESC, seq;

--�ش� ���� ���� �ٷ� ���� �޿� ����ϱ�
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