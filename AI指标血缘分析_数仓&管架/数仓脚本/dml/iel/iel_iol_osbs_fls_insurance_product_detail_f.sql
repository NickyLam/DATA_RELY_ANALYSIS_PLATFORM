: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_fls_insurance_product_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/osbs_fls_insurance_product_detail.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.fip_prdct_code,chr(13),''),chr(10),'') as fip_prdct_code
,replace(replace(t.fip_prdct_name,chr(13),''),chr(10),'') as fip_prdct_name
,replace(replace(t.fip_prdct_pic1,chr(13),''),chr(10),'') as fip_prdct_pic1
,replace(replace(t.fip_prdct_pic2,chr(13),''),chr(10),'') as fip_prdct_pic2
,replace(replace(t.fip_prdct_brief,chr(13),''),chr(10),'') as fip_prdct_brief
,replace(replace(t.fip_prdct_age,chr(13),''),chr(10),'') as fip_prdct_age
,replace(replace(t.fip_risk_level,chr(13),''),chr(10),'') as fip_risk_level
,replace(replace(t.fip_prdct_feature,chr(13),''),chr(10),'') as fip_prdct_feature
,replace(replace(t.fip_prdct_illustration,chr(13),''),chr(10),'') as fip_prdct_illustration
,replace(replace(t.fip_special_notice,chr(13),''),chr(10),'') as fip_special_notice
,replace(replace(t.fip_exemp_clause,chr(13),''),chr(10),'') as fip_exemp_clause
,replace(replace(t.fip_customer_notify,chr(13),''),chr(10),'') as fip_customer_notify
,replace(replace(t.fip_buy_tip,chr(13),''),chr(10),'') as fip_buy_tip
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.osbs_fls_insurance_product_detail t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_fls_insurance_product_detail.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes