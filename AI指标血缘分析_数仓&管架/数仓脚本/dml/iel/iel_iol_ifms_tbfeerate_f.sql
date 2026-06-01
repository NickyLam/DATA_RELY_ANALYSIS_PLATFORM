: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbfeerate_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbfeerate.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.share_class,chr(13),''),chr(10),'') as share_class
,replace(replace(t.busin_code,chr(13),''),chr(10),'') as busin_code
,replace(replace(t.fee_type,chr(13),''),chr(10),'') as fee_type
,replace(replace(t.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t.seller_type,chr(13),''),chr(10),'') as seller_type
,replace(replace(t.sub_mode,chr(13),''),chr(10),'') as sub_mode
,t.min_amt as min_amt
,t.max_amt as max_amt
,t.min_predays as min_predays
,t.max_predays as max_predays
,t.min_holddays as min_holddays
,t.max_holddays as max_holddays
,t.fee_rate as fee_rate
,t.min_fee as min_fee
,t.max_fee as max_fee
,t.calculate_numeric as calculate_numeric
,replace(replace(t.other_prd_code,chr(13),''),chr(10),'') as other_prd_code
,replace(replace(t.targ_share_class,chr(13),''),chr(10),'') as targ_share_class
,replace(replace(t.unit,chr(13),''),chr(10),'') as unit
,replace(replace(t.unit_name,chr(13),''),chr(10),'') as unit_name
,replace(replace(t.back_flag,chr(13),''),chr(10),'') as back_flag
,replace(replace(t.fee_mode,chr(13),''),chr(10),'') as fee_mode
,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ifms_tbfeerate t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbfeerate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes