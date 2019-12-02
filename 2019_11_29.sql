--cursor�� ��������� �������� �ʰ� loop���� inline���·� cursor���
set serveroutput on;
--�͸���
DECLARE
    --CURSOR����-->LOOP���� inline����
BEGIN
    --for(String str : list)
    FOR rec IN (SELECT deptno, dname FROM dept) LOOP
        dbms_output.put_line(rec.deptno|| ',' || rec.dname);
    END LOOP;
END;
/

--pro_3
CREATE OR REPLACE PROCEDURE avgdt 
IS 
    --�����
    prev_dt DATE;
    ind NUMBER := 0;
    diff NUMBER := 0;
BEGIN
    --dt ���̺��� ��� ������ ��ȸ
    FOR rec IN (SELECT * FROM dt ORDER BY dt DESC) LOOP
        --rec : dt�÷�
        --���� ���� ������(dt) - ���� ������(dt) : 
        
        IF ind = 0 THEN --loop�� ù�κ�
            prev_dt := rec.dt;
        ELSE
            diff := diff + (prev_dt - rec.dt);
            prev_dt := rec.dt;
        END IF;
        ind := ind +1;      
    END LOOP; 
    dbms_output.put_line(diff/(ind-1));
END;
/
exec avgdt;

--pro_4
--���� -1 �Ͽ��Ϻ���
--�ش���� ���� ���ϱ�
SELECT TO_CHAR(TO_DATE('201911','YYYYMM')+ (LEVEL-1),'YYYYMMDD') dt ,
        TO_CHAR(TO_DATE('201911','YYYYMM')+ (LEVEL-1),'D') d 
FROM dual 
CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE('201911','YYYYMM')), 'DD'));
--���ڵ�Ÿ��, ���̺�Ÿ��, ��Ÿ���� �ʿ���


CREATE OR REPLACE PROCEDURE create_daily_sales(p_yyyymm VARCHAR2)
IS
    --�޷��� �������� ������ RECORD TYPE
    TYPE cal_row IS RECORD(
        dt VARCHAR2(8),
        d VARCHAR2(1));
    
    --�޷������� ������ table type
    TYPE calendar IS TABLE OF cal_row;
    cal calendar;
    
    --�����ֱ� cursor
    CURSOR cycle_cursor IS
        SELECT *
        FROM cycle;
        
BEGIN
    SELECT TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM')+ (LEVEL-1),'YYYYMMDD') dt ,
        TO_CHAR(TO_DATE(p_yyyymm,'YYYYMM')+ (LEVEL-1),'D') d 
        BULK COLLECT INTO cal
    FROM dual 
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(p_yyyymm,'YYYYMM')), 'DD'));
    
    --�����Ϸ��� �ϴ� ����� ���� �����͸� �����Ѵ�.
    DELETE daily
    WHERE dt LIKE p_yyyymm || '%';
    
    --�����ֱ� loop
    FOR rec IN cycle_cursor LOOP
        dbms_output.put_line(rec.day); --�����ֱ� ���̺� �Ǽ���ŭ ���;���
         FOR i IN 1..cal.count LOOP
         --�����ֱ��� �����̶� ������ �����̶� ������ ��
            IF rec.day = cal(i).d THEN
                INSERT INTO daily VALUES(rec.cid, rec.pid,cal(i).dt,rec.cnt);
            END IF;
        END LOOP;
    END LOOP;
    
   COMMIT;
END;
/
exec CREATE_DAILY_SALES('201911');

select * from daily;

INSERT INTO daily
SELECT cycle.cid, cycle.pid, cal.dt, cycle.cnt
FROM 
    cycle,
    (SELECT TO_CHAR(TO_DATE(:p_yyyymm,'YYYYMM')+ (LEVEL-1),'YYYYMMDD') dt ,
        TO_CHAR(TO_DATE(:p_yyyymm,'YYYYMM')+ (LEVEL-1),'D') d 
    FROM dual 
    CONNECT BY LEVEL <= TO_NUMBER(TO_CHAR(LAST_DAY(TO_DATE(:p_yyyymm,'YYYYMM')), 'DD'))
where cycle.day = cal.d;