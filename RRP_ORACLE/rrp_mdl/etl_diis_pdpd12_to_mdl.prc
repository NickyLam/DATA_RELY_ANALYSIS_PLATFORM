CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_DIIS_PDPD12_TO_MDL (I_P_DATE IN INTEGER , O_ERRCODE OUT VARCHAR2)
IS
V_P_DATE  VARCHAR2(8);

BEGIN
V_P_DATE := TO_CHAR(I_P_DATE);
EXECUTE IMMEDIATE 'TRUNCATE TABLE DIIS_PDPD12';

INSERT INTO DIIS_PDPD12
(
rid,
cust_seq,
name,
cust_id,
fin_org_type,
fin_org_code,
uscc,
obj_name,
obj_id_type,
obj_id_no,
dpst_tot_amt,
acct_seq,
prod_type,
acct_no,
corp_name,
acct_type,
dpst_sts,
id_type,
id_no,
id_valid_dt,
tel_no,
addr,
prin_amt,
int_amt,
tot_amt,
note,
data_dt,
org_no,
curr_cd,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify,
is_seq,
subj_id
)
       SELECT
rid,
cust_seq,
name,
cust_id,
fin_org_type,
fin_org_code,
uscc,
obj_name,
obj_id_type,
obj_id_no,
dpst_tot_amt,
acct_seq,
prod_type,
acct_no,
corp_name,
acct_type,
dpst_sts,
id_type,
id_no,
id_valid_dt,
tel_no,
addr,
prin_amt,
int_amt,
tot_amt,
note,
data_dt,
org_no,
curr_cd,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify,
is_seq,
subj_id
FROM  RRP_DIIS.DIIS_PDPD12
WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD')
;
COMMIT;

O_ERRCODE := '0';

END;
/

