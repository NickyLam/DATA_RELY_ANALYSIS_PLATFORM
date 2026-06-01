: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_messageheader_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_messageheader.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,replace(replace(t.idv_cr_rpt_file_id,chr(13),''),chr(10),'') as idv_cr_rpt_file_id
    ,t.msgrp_gen_tm as msgrp_gen_tm
    ,t.cnrt_exrt as cnrt_exrt
    ,replace(replace(t.exrt_vld_dt,chr(13),''),chr(10),'') as exrt_vld_dt
    ,replace(replace(t.cr_enqd_insid,chr(13),''),chr(10),'') as cr_enqd_insid
    ,replace(replace(t.entnm,chr(13),''),chr(10),'') as entnm
    ,t.entp_idnt_idr_num as entp_idnt_idr_num
    ,replace(replace(t.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
    ,t.cr_objtn_num as cr_objtn_num
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_e_r_messageheader t
  where to_char(t.crt_dt_tm,'yyyymmdd')='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_messageheader.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes