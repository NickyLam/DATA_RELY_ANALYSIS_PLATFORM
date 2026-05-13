CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_IMAS_412_GRCKYE_ALL_TO_MDL (I_P_DATE IN INTEGER , O_ERRCODE OUT VARCHAR2)
IS
V_P_DATE  VARCHAR2(8);


BEGIN

V_P_DATE := TO_CHAR(I_P_DATE);
EXECUTE IMMEDIATE 'TRUNCATE TABLE IMAS_412_GRCKYE_ALL';
IF TO_DATE(V_P_DATE,'YYYYMMDD') = ADD_MONTHS(TRUNC(TO_DATE(V_P_DATE,'YYYY-MM-DD'),'MM'),1) - 1
  THEN


INSERT INTO IMAS_412_GRCKYE_ALL
(
rid,
data_dt,
acct_no,
acct_id,
org_no,
cust_no,
curr_cd,
bal,
prod_name,
dep_prod_cd,
subj_id,
sav_type_cd,
webank_flg,
indv_indu_com_acct_flg,
data_src,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify
)
       SELECT
rid,
data_dt,
acct_no,
acct_id,
org_no,
cust_no,
curr_cd,
bal,
prod_name,
dep_prod_cd,
subj_id,
sav_type_cd,
webank_flg,
indv_indu_com_acct_flg,
data_src,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify

FROM  RRP_IMAS.IMAS_412_GRCKYE_ALL
WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD')
;
COMMIT;

END IF ;
O_ERRCODE := '0';

END;
/

