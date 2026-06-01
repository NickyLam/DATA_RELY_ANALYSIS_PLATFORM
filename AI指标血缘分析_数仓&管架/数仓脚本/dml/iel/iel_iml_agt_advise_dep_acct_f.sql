: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_advise_dep_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_advise_dep_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.dep_tenor_cd,chr(13),''),chr(10),'') as dep_tenor_cd
    ,replace(replace(t.free_precon_flg_cd,chr(13),''),chr(10),'') as free_precon_flg_cd
    ,replace(replace(t.advise_dep_type_cd,chr(13),''),chr(10),'') as advise_dep_type_cd
    ,t.auto_clos_acct_dt as auto_clos_acct_dt
    ,t.create_dt as create_dt
    ,t.update_dt as update_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_advise_dep_acct t
where etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_advise_dep_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes