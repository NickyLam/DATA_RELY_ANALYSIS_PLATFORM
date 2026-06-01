: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_ifs_sub_acct_provi_rgst_b_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ifs_sub_acct_provi_rgst_b.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.provi_dt as provi_dt
,replace(replace(t1.dep_acct_id,chr(13),''),chr(10),'') as dep_acct_id
,replace(replace(t1.dep_prod_sub_acct_id,chr(13),''),chr(10),'') as dep_prod_sub_acct_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,t1.dep_bal as dep_bal
,t1.exec_int_rat as exec_int_rat
,t1.td_int_paybl as td_int_paybl
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
from ${iml_schema}.evt_ifs_sub_acct_provi_rgst_b t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ifs_sub_acct_provi_rgst_b.i.${batch_date}.dat" \
        charset=utf8
        safe=yes