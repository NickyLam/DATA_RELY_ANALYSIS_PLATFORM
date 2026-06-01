: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cqss_e_r_impexpcmdtyexptchkinf_i
CreateDate: 20241216
FileName:   ${iel_data_path}/cqss_e_r_impexpcmdtyexptchkinf.i.${batch_date}.dat
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
,replace(replace(t1.exmpt_chk_cmdty_nm,chr(13),''),chr(10),'') as exmpt_chk_cmdty_nm
,replace(replace(t1.exmpt_chk_no,chr(13),''),chr(10),'') as exmpt_chk_no
,endto_dt
,crt_dt_tm

from ${iol_schema}.cqss_e_r_impexpcmdtyexptchkinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cqss_e_r_impexpcmdtyexptchkinf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
