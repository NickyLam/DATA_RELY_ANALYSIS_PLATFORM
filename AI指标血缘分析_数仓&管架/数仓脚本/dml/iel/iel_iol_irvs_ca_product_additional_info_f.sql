: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_irvs_ca_product_additional_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/irvs_ca_product_additional_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.id,chr(13),''),chr(10),'') as id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prd_cd,chr(13),''),chr(10),'') as prd_cd
,replace(replace(t.prd_name,chr(13),''),chr(10),'') as prd_name
,replace(replace(t.prod_desc,chr(13),''),chr(10),'') as prod_desc
,replace(replace(t.invest_direction,chr(13),''),chr(10),'') as invest_direction
,replace(replace(t.invt_range,chr(13),''),chr(10),'') as invt_range
,replace(replace(t.inc_measr,chr(13),''),chr(10),'') as inc_measr
,replace(replace(t.purch_rule,chr(13),''),chr(10),'') as purch_rule
,replace(replace(t.income_rule,chr(13),''),chr(10),'') as income_rule
,replace(replace(t.rede_rule,chr(13),''),chr(10),'') as rede_rule
,replace(replace(t.liqdt_cash,chr(13),''),chr(10),'') as liqdt_cash
,t.created_time as created_time
,replace(replace(t.created_by,chr(13),''),chr(10),'') as created_by
,t.updated_time as updated_time
,replace(replace(t.updated_by,chr(13),''),chr(10),'') as updated_by
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.irvs_ca_product_additional_info t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/irvs_ca_product_additional_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes