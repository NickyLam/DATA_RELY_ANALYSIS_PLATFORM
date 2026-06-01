: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_bil_commercial_voucher_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_bil_commercial_voucher_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.id as id
,t1.draft_id as draft_id
,replace(replace(t1.draft_number,chr(13),''),chr(10),'') as draft_number
,replace(replace(t1.voucher_no,chr(13),''),chr(10),'') as voucher_no
,replace(replace(t1.voucher_curcd,chr(13),''),chr(10),'') as voucher_curcd
,t1.voucher_amt as voucher_amt
,replace(replace(t1.voucher_type,chr(13),''),chr(10),'') as voucher_type
,replace(replace(t1.voucher_source,chr(13),''),chr(10),'') as voucher_source
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_bil_commercial_voucher_info t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_bil_commercial_voucher_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes