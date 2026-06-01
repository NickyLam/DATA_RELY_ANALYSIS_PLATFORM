: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_corp_stl_acct_apprv_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_corp_stl_acct_apprv_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.apprv_status_cd,chr(13),''),chr(10),'') as apprv_status_cd
    ,t.apprv_dt as apprv_dt
    ,t.effect_dt as effect_dt
    ,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
    ,replace(replace(t.acct_apprv_type_cd,chr(13),''),chr(10),'') as acct_apprv_type_cd
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_corp_stl_acct_apprv_info t
  where t.create_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_corp_stl_acct_apprv_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes