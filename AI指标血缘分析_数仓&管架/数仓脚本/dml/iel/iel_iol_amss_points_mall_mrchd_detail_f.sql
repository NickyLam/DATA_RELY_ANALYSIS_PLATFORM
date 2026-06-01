: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_points_mall_mrchd_detail_f
CreateDate: 20251017
FileName:   ${iel_data_path}/amss_points_mall_mrchd_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.serial_num,chr(13),''),chr(10),'') as serial_num
,replace(replace(t1.mrchd_id,chr(13),''),chr(10),'') as mrchd_id
,mrchd_price
,replace(replace(t1.cnsm_typ,chr(13),''),chr(10),'') as cnsm_typ
,physics_flag
,create_time
,update_time
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,replace(replace(t1.update_emp,chr(13),''),chr(10),'') as update_emp
,replace(replace(t1.undo_refund_flag,chr(13),''),chr(10),'') as undo_refund_flag
,replace(replace(t1.order_no,chr(13),''),chr(10),'') as order_no

from ${iol_schema}.amss_points_mall_mrchd_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_points_mall_mrchd_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
