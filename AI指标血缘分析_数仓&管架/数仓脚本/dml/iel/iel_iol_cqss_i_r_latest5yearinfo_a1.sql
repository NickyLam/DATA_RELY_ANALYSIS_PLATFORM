: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_latest5yearinfo_a1
CreateDate: 20241119
FileName:   ${iel_data_path}/cqss_i_r_latest5yearinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.cr_supr_rcrd_id,chr(13),''),chr(10),'') as cr_supr_rcrd_id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.mo,chr(13),''),chr(10),'') as mo
    ,replace(replace(t.cr_ln_repy_st,chr(13),''),chr(10),'') as cr_ln_repy_st
    ,t.cur_odue_tamt as cur_odue_tamt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
    ,replace(replace(t.odue_cnu_mo_num_cd,chr(13),''),chr(10),'') as odue_cnu_mo_num_cd
from iol.cqss_i_r_latest5yearinfo t
  where to_char(t.crt_dt_tm, 'yyyymmdd') between to_char(to_date('${batch_date}', 'yyyymmdd') - 365, 'yyyymmdd') and '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_latest5yearinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes