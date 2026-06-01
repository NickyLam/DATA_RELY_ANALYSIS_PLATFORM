: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_residence_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_residence.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.cr_rsdnc_sttn_cd,chr(13),''),chr(10),'') as cr_rsdnc_sttn_cd
    ,replace(replace(t.cr_rsdnc_adr,chr(13),''),chr(10),'') as cr_rsdnc_adr
    ,replace(replace(t.move_telno,chr(13),''),chr(10),'') as move_telno
    ,t.cr_inf_udt_dt as cr_inf_udt_dt
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_residence t
  where to_char(t.crt_dt_tm,'yyyymmdd') <= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_residence.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes