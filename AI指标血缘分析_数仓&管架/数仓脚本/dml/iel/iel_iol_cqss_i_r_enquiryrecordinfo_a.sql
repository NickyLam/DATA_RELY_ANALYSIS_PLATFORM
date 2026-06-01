: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_enquiryrecordinfo_a
CreateDate: 20241111
FileName:   ${iel_data_path}/cqss_i_r_enquiryrecordinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    t.etl_dt
    ,replace(replace(t.id,chr(13),''),chr(10),'') as id
    ,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
    ,t.cr_enqr_dt as cr_enqr_dt
    ,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
    ,replace(replace(t.cr_enqd_insid,chr(13),''),chr(10),'') as cr_enqd_insid
    ,replace(replace(t.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
    ,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
    ,t.crt_dt_tm as crt_dt_tm
from iol.cqss_i_r_enquiryrecordinfo t
  where to_char(t.crt_dt_tm,'yyyymmdd')<='${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_enquiryrecordinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes