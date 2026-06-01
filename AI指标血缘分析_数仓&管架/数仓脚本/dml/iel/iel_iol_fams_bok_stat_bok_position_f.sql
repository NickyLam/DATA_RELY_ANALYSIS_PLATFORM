: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_bok_stat_bok_position_f
CreateDate: 20240702
FileName:   ${iel_data_path}/fams_bok_stat_bok_position.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bookset_id,chr(13),''),chr(10),'') as bookset_id
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,happen_date
,book_date
,bookset_date
,replace(replace(t1.profit_type,chr(13),''),chr(10),'') as profit_type
,capital
,profit_amt
,tot_profit_amt
,int_rate
,net_asset_value_bef
,net_asset_value
,net_unit_value_bef
,net_unit_value
,p_yield_bef
,p_yield
,tdy_yield_bef
,tdy_yield
,yield_term_bef
,yield_term
,yield_7_bef
,yield_7
,tot_bouns_amt
,tdy_bouns_amt
,tot_bouns_net
,tdy_bouns_net
,replace(replace(t1.is_sub_prd,chr(13),''),chr(10),'') as is_sub_prd
,replace(replace(t1.layering_id,chr(13),''),chr(10),'') as layering_id
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time

from ${iol_schema}.fams_bok_stat_bok_position t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_bok_stat_bok_position.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
