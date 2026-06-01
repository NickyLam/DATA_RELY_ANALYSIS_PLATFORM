: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_i_r_otheridentitytype_i
CreateDate: 20241107
FileName:   ${iel_data_path}/cqss_i_r_otheridentitytype.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.pbc_tngncr_pts_tpcd,chr(13),''),chr(10),'') as pbc_tngncr_pts_tpcd
,replace(replace(t1.crrptenqd_psn_crdt_no,chr(13),''),chr(10),'') as crrptenqd_psn_crdt_no
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,crt_dt_tm

from ${iol_schema}.cqss_i_r_otheridentitytype t1
where to_char(crt_dt_tm,'yyyymmdd') = '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_i_r_otheridentitytype.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
