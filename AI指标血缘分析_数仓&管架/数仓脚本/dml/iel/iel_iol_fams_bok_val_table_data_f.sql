: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_val_table_data_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_bok_val_table_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_no,chr(13),''),chr(10),'') as seq_no
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.bookset_name,chr(13),''),chr(10),'') as bookset_name
,replace(replace(t1.profit_type,chr(13),''),chr(10),'') as profit_type
,val_date
,replace(replace(t1.detail_dist,chr(13),''),chr(10),'') as detail_dist
,replace(replace(t1.layering_id,chr(13),''),chr(10),'') as layering_id
,replace(replace(t1.subject_no,chr(13),''),chr(10),'') as subject_no
,replace(replace(t1.subject_name,chr(13),''),chr(10),'') as subject_name
,replace(replace(t1.fsubject_id,chr(13),''),chr(10),'') as fsubject_id
,num_amt
,unit_cost
,cost
,cost_percent
,close_price
,market_value
,value_percent
,value_increment
,replace(replace(t1.bal_flag,chr(13),''),chr(10),'') as bal_flag
,shadow_price_value
,market_val_date
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,replace(replace(t1.o_ccy,chr(13),''),chr(10),'') as o_ccy
,exchange_rate
,o_cost
,o_market_value

from ${iol_schema}.fams_bok_val_table_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_val_table_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
