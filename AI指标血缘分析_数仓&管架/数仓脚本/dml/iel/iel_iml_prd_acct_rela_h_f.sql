: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_acct_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_acct_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.rela_id,chr(13),''),chr(10),'') as rela_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.acct_open_bank_name,chr(13),''),chr(10),'') as acct_open_bank_name
    ,replace(replace(t.acct_owner_id,chr(13),''),chr(10),'') as acct_owner_id
    ,t.acct_bal as acct_bal
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_acct_rela_h t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_acct_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes