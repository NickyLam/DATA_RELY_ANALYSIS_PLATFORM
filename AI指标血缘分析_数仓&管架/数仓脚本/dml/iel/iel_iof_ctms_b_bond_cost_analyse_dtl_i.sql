: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ctms_b_bond_cost_analyse_dtl_i
CreateDate: 20250416
FileName:   ${iel_data_path}/ctms_b_bond_cost_analyse_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.account_type,chr(13),''),chr(10),'') as account_type
,replace(replace(t1.third_type,chr(13),''),chr(10),'') as third_type
,replace(replace(t1.security_id,chr(13),''),chr(10),'') as security_id
,replace(replace(t1.security_name,chr(13),''),chr(10),'') as security_name
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,pfolio_id
,replace(replace(t1.pfolio_name,chr(13),''),chr(10),'') as pfolio_name
,replace(replace(t1.security_type,chr(13),''),chr(10),'') as security_type
,replace(replace(t1.security_type_name,chr(13),''),chr(10),'') as security_type_name
,replace(replace(t1.maturity_date,chr(13),''),chr(10),'') as maturity_date
,term_to_maturity
,mduration
,position
,residual_qty
,dirty_market_value
,price_yield
,net_price
,market_price_yield
,yielddata
,floatingpl
,replace(replace(t1.security_full_name,chr(13),''),chr(10),'') as security_full_name
,replace(replace(t1.bond_region,chr(13),''),chr(10),'') as bond_region
,replace(replace(t1.mk_security_code,chr(13),''),chr(10),'') as mk_security_code
,pvbp
,dmp_time

from ${iol_schema}.ctms_b_bond_cost_analyse_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_b_bond_cost_analyse_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
