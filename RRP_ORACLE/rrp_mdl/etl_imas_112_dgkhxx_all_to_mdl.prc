CREATE OR REPLACE PROCEDURE RRP_MDL.ETL_IMAS_112_DGKHXX_ALL_TO_MDL (I_P_DATE IN INTEGER , O_ERRCODE OUT VARCHAR2)
IS
V_P_DATE  VARCHAR2(8);


BEGIN

V_P_DATE := TO_CHAR(I_P_DATE);
EXECUTE IMMEDIATE 'TRUNCATE TABLE IMAS_112_DGKHXX_ALL';
IF TO_DATE(V_P_DATE,'YYYYMMDD') = ADD_MONTHS(TRUNC(TO_DATE('20230308','YYYY-MM-DD'),'MM'),1) - 1
  THEN


INSERT INTO IMAS_112_DGKHXX_ALL
(
rid,
data_dt,
cust_no,
org_no,
prin_econ_dept,
fin_org_type_no,
ent_scale,
holding_type,
domestic_overseas_signs,
area_cd,
reg_addr,
credit_amt,
use_credit_amt,
ind_cd,
rural_city_sign,
c_cust_type,
cust_nm,
org_nm,
lp_org_cust_id,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify

)
       SELECT
rid,
data_dt,
cust_no,
org_no,
prin_econ_dept,
fin_org_type_no,
ent_scale,
holding_type,
domestic_overseas_signs,
area_cd,
reg_addr,
credit_amt,
use_credit_amt,
ind_cd,
rural_city_sign,
c_cust_type,
cust_nm,
org_nm,
lp_org_cust_id,
dept_no,
issued_no,
rpt_org_no,
data_ources,
data_modify

FROM  RRP_IMAS.IMAS_112_DGKHXX_ALL
WHERE DATA_DT = TO_CHAR(TO_DATE(V_P_DATE,'YYYYMMDD'),'YYYY-MM-DD')
;
COMMIT;

END IF ;
O_ERRCODE := '0';

END;
/

