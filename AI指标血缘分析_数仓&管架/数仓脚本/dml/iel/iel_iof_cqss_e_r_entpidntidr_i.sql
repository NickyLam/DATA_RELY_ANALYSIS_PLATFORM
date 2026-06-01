: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_cqss_e_r_entpidntidr_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_e_r_entpidntidr.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.entp_idnt_idr_tp,chr(13),''),chr(10),'') as entp_idnt_idr_tp
,replace(replace(t1.entp_idnt_idr_no,chr(13),''),chr(10),'') as entp_idnt_idr_no
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t1.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_e_r_entpidntidr t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_entpidntidr.i.${batch_date}.dat" \
        charset=utf8
        safe=yes