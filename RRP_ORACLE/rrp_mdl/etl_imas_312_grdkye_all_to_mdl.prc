CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_IMAS_312_GRDKYE_ALL_TO_MDL (I_P_DATE IN INTEGER , O_ERRCODE OUT VARCHAR2)
IS
V_P_DATE  VARCHAR2(8);


BEGIN

V_P_DATE := TO_CHAR(I_P_DATE);
EXECUTE IMMEDIATE 'TRUNCATE TABLE IMAS_312_GRDKYE_ALL';
IF TO_DATE(V_P_DATE,'YYYYMMDD') = ADD_MONTHS(TRUNC(TO_DATE('20230308','YYYY-MM-DD'),'MM'),1) - 1
  THEN


INSERT INTO IMAS_312_GRDKYE_ALL
(
rid,
data_dt,
loan_no,
cust_no,
org_no,
curr_cd,
bal,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify


)
       SELECT
rid,
data_dt,
loan_no,
cust_no,
org_no,
curr_cd,
bal,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify


FROM  RRP_IMAS.IMAS_312_GRDKYE_ALL
WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD')
;
COMMIT;

END IF ;
O_ERRCODE := '0';

END;
/

