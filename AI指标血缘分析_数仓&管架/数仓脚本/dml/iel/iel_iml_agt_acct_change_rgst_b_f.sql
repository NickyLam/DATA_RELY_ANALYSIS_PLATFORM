: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_acct_change_rgst_b_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_acct_change_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.old_acct_id,chr(13),''),chr(10),'') as old_acct_id
    ,replace(replace(t.new_acct_id,chr(13),''),chr(10),'') as new_acct_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.advised_midgrod_flg,chr(13),''),chr(10),'') as advised_midgrod_flg
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,replace(replace(t.job_cd,chr(13),''),chr(10),'') as job_cd
from iml.agt_acct_change_rgst_b t" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_acct_change_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes