: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_fin_product_valuation_f
CreateDate: 20240704
FileName:   ${iel_data_path}/fams_fin_product_valuation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finprod_id,chr(13),''),chr(10),'') as finprod_id
,replace(replace(t1.finprod_type,chr(13),''),chr(10),'') as finprod_type
,replace(replace(t1.finprod_type2,chr(13),''),chr(10),'') as finprod_type2
,val_date
,publish_date
,valuation
,day7_year_yield
,year_yield
,total_value
,replace(replace(t1.input_type,chr(13),''),chr(10),'') as input_type
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.create_user,chr(13),''),chr(10),'') as create_user
,replace(replace(t1.create_dept,chr(13),''),chr(10),'') as create_dept
,create_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,update_time
,rest_net_value
,f_price_valuation
,c_shares
,replace(replace(t1.full_valuation,chr(13),''),chr(10),'') as full_valuation
,replace(replace(t1.value_source,chr(13),''),chr(10),'') as value_source

from ${iol_schema}.fams_fin_product_valuation t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_fin_product_valuation.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
