: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_enquiryrecordinfo_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cqss_i_r_enquiryrecordinfo_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.msgidno,chr(13),''),chr(10),'') as msgidno
,t.cr_enqr_dt as cr_enqr_dt
,replace(replace(t.inst_tp,chr(13),''),chr(10),'') as inst_tp
,replace(replace(t.cr_enqd_insid,chr(13),''),chr(10),'') as cr_enqd_insid
,replace(replace(t.pbc_enqr_rscd,chr(13),''),chr(10),'') as pbc_enqr_rscd
,replace(replace(t.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,t.crt_dt_tm as crt_dt_tm
from ${iol_schema}.cqss_i_r_enquiryrecordinfo t
where to_char(crt_dt_tm,'yyyymmdd') <= '${batch_date}' and to_char(crt_dt_tm,'yyyymmdd') >= '${batch_date}' -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_enquiryrecordinfo_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes