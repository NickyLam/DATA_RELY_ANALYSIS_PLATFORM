: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_mims_coll_marg_pled_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_mims_coll_marg_pled_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.dpst_acct_num,chr(13),''),chr(10),'') as dpst_acct_num
,replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,replace(replace(t1.sub_num,chr(13),''),chr(10),'') as sub_num
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,t1.open_dt as open_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.int_start_dt as int_start_dt
,t1.due_dt as due_dt
,t1.acct_bal as acct_bal
,t1.usable_bal as usable_bal
,t1.dacct_acct_frz_amt as dacct_acct_frz_amt
from ${idl_schema}.hdws_dul_d_mims_coll_marg_pled_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_mims_coll_marg_pled_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes