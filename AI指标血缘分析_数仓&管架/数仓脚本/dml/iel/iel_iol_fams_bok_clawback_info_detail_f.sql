: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_clawback_info_detail_f
CreateDate: 20240613
FileName:   ${iel_data_path}/fams_bok_clawback_info_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.layering_id,chr(13),''),chr(10),'') as layering_id
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,branch
,happen_date
,book_date
,bookset_date
,replace(replace(t1.fee_type,chr(13),''),chr(10),'') as fee_type
,clawback_amt
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_bok_clawback_info_detail t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_clawback_info_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
