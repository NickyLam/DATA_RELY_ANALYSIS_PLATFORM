: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ifs_acct_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ifs_acct_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_char(t1.etl_dt,'yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_id,chr(13),''),chr(10),'') as tran_flow_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.call_sys_id,chr(13),''),chr(10),'') as call_sys_id
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,t1.tran_amt as tran_amt
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_org_id,chr(13),''),chr(10),'') as cntpty_org_id
,t1.dep_rcpt_bal as dep_rcpt_bal
,replace(replace(t1.provi_flg_cd,chr(13),''),chr(10),'') as provi_flg_cd
,t1.provi_tm as provi_tm
,replace(replace(t1.ext_flow_id,chr(13),''),chr(10),'') as ext_flow_id
from ${iml_schema}.evt_ifs_acct_tran_dtl t1
where etl_dt >= to_date('20210601','yyyymmdd') AND etl_dt <= to_date('20210630','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ifs_acct_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes