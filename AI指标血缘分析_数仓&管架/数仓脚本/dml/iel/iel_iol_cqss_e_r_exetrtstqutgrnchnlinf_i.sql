: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_exetrtstqutgrnchnlinf_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_exetrtstqutgrnchnlinf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.msgidno,chr(13),''),chr(10),'') as msgidno
,replace(replace(t1.multi_tenancy_id,chr(13),''),chr(10),'') as multi_tenancy_id
,replace(replace(t1.cr_inf_id,chr(13),''),chr(10),'') as cr_inf_id
,replace(replace(t1.rtfd_dept_nm,chr(13),''),chr(10),'') as rtfd_dept_nm
,replace(replace(t1.excmdt_nm,chr(13),''),chr(10),'') as excmdt_nm
,efdt
,crt_dt_tm

from ${iol_schema}.cqss_e_r_exetrtstqutgrnchnlinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_exetrtstqutgrnchnlinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
