: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_acct_approval_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_acct_approval_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.approval_id,chr(13),''),chr(10),'') as approval_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.open_dt as open_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.approval_type_cd,chr(13),''),chr(10),'') as approval_type_cd
,replace(replace(t1.approval_cap_use_usage,chr(13),''),chr(10),'') as approval_cap_use_usage
,replace(replace(t1.approval_cap_src,chr(13),''),chr(10),'') as approval_cap_src
,t1.approval_open_amt as approval_open_amt
,replace(replace(t1.apprv_acct_imp_item,chr(13),''),chr(10),'') as apprv_acct_imp_item
,replace(replace(t1.acct_type_descb,chr(13),''),chr(10),'') as acct_type_descb
,replace(replace(t1.expns_range,chr(13),''),chr(10),'') as expns_range
,replace(replace(t1.inco_range,chr(13),''),chr(10),'') as inco_range
,replace(replace(t1.tran_memo_descb,chr(13),''),chr(10),'') as tran_memo_descb
,t1.tran_tm as tran_tm
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
from ${iml_schema}.evt_acct_approval_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_acct_approval_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes