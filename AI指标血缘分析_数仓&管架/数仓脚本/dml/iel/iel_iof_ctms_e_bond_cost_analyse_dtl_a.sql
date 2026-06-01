: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_ctms_e_bond_cost_analyse_dtl_a
CreateDate: 20250415
FileName:   ${iel_data_path}/ctms_e_bond_cost_analyse_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.settledate,chr(13),''),chr(10),'') as settledate
,replace(replace(t1.account_type,chr(13),''),chr(10),'') as account_type
,replace(replace(t1.third_type,chr(13),''),chr(10),'') as third_type
,replace(replace(t1.security_id,chr(13),''),chr(10),'') as security_id
,replace(replace(t1.security_name,chr(13),''),chr(10),'') as security_name
,replace(replace(t1.security_type,chr(13),''),chr(10),'') as security_type
,replace(replace(t1.security_type_name,chr(13),''),chr(10),'') as security_type_name
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,position
,residual_qty
,price_yield
,net_price
,term_to_maturity
,mduration
,floatingpl
,pfolio_id
,replace(replace(t1.pfolio_name,chr(13),''),chr(10),'') as pfolio_name
,dirty_market_value
,replace(replace(t1.is_qualified,chr(13),''),chr(10),'') as is_qualified
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.issuer_label,chr(13),''),chr(10),'') as issuer_label
,dmp_time

from ${iol_schema}.ctms_e_bond_cost_analyse_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_e_bond_cost_analyse_dtl.a.${batch_date}.dat" \
        charset=utf8
        safe=yes
