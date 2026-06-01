: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_feeinfo_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_mst_feeinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fee_id,chr(13),''),chr(10),'') as fee_id
,replace(replace(t1.fee_name,chr(13),''),chr(10),'') as fee_name
,replace(replace(t1.apply_type,chr(13),''),chr(10),'') as apply_type
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t1.basic_bill,chr(13),''),chr(10),'') as basic_bill
,replace(replace(t1.basis,chr(13),''),chr(10),'') as basis
,replace(replace(t1.charge_type,chr(13),''),chr(10),'') as charge_type
,replace(replace(t1.org_type,chr(13),''),chr(10),'') as org_type
,replace(replace(t1.org_type2,chr(13),''),chr(10),'') as org_type2
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_mst_feeinfo t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_feeinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
