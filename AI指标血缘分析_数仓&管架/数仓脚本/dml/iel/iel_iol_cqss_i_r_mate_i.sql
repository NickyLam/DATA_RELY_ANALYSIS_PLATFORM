: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_mate_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_mate.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.pbc_cr_mar_sttn,chr(13),''),chr(10),'') as pbc_cr_mar_sttn
    ,replace(replace(t.sps_nm,chr(13),''),chr(10),'') as sps_nm
    ,replace(replace(t.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
    ,replace(replace(t.sps_crdt_no,chr(13),''),chr(10),'') as sps_crdt_no
    ,replace(replace(t.wrk_unit_nm,chr(13),''),chr(10),'') as wrk_unit_nm
    ,replace(replace(t.move_telno,chr(13),''),chr(10),'') as move_telno
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_mate t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_mate.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes