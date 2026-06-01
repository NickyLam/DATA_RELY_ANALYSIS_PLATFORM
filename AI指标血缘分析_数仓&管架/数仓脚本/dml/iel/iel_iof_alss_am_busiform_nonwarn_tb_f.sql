: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_busiform_nonwarn_tb_f
CreateDate: 20241219
FileName:   ${iel_data_path}/alss_am_busiform_nonwarn_tb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.form_id,chr(13),''),chr(10),'') as form_id
,replace(replace(t1.warn_id,chr(13),''),chr(10),'') as warn_id
,replace(replace(t1.order_mainstay_no,chr(13),''),chr(10),'') as order_mainstay_no
,replace(replace(t1.is_accno_deal,chr(13),''),chr(10),'') as is_accno_deal
,replace(replace(t1.deal_date,chr(13),''),chr(10),'') as deal_date
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.deal_type,chr(13),''),chr(10),'') as deal_type

from ${iol_schema}.alss_am_busiform_nonwarn_tb t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_busiform_nonwarn_tb.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
