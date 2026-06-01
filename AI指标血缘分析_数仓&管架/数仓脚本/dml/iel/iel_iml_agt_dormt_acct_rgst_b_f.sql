: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dormt_acct_rgst_b_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dormt_acct_rgst_b.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.pre_proc_rgst_num,chr(13),''),chr(10),'') as pre_proc_rgst_num
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
    ,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
    ,t.dormt_acct_dt as dormt_acct_dt
    ,t.pre_proc_dormt_acct_dt as pre_proc_dormt_acct_dt
    ,replace(replace(t.check_status_cd,chr(13),''),chr(10),'') as check_status_cd
    ,t.check_dt as check_dt
    ,replace(replace(t.check_flow_num,chr(13),''),chr(10),'') as check_flow_num
    ,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
    ,t.nomal_acct_dt as nomal_acct_dt
    ,replace(replace(t.nomal_acct_flow_num,chr(13),''),chr(10),'') as nomal_acct_flow_num
    ,replace(replace(t.nomal_acct_type_cd,chr(13),''),chr(10),'') as nomal_acct_type_cd
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_dormt_acct_rgst_b t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dormt_acct_rgst_b.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes