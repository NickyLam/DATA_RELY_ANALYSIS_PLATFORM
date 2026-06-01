: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_vi_cms_avg_cost_analyse_dtl_bond_i
CreateDate: 20240111
FileName:   ${iel_data_path}/ctms_vi_cms_avg_cost_analyse_dtl_bond.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.query_end_date,chr(13),''),chr(10),'') as query_end_date
,replace(replace(t1.security_id,chr(13),''),chr(10),'') as security_id
,replace(replace(t1.security_name,chr(13),''),chr(10),'') as security_name
,replace(replace(t1.start_date,chr(13),''),chr(10),'') as start_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,position
,residualqty
,averagecost
,dpaprice
,accruedinterest
,replace(replace(t1.assettype,chr(13),''),chr(10),'') as assettype
,replace(replace(t1.cname,chr(13),''),chr(10),'') as cname
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,mduration
,pvbp
,pfolio_id
,replace(replace(t1.pfolio_name,chr(13),''),chr(10),'') as pfolio_name
,replace(replace(t1.buztype,chr(13),''),chr(10),'') as buztype
,keepfolder_id
,replace(replace(t1.keepfolder_code,chr(13),''),chr(10),'') as keepfolder_code
,replace(replace(t1.keepfolder_shortname,chr(13),''),chr(10),'') as keepfolder_shortname
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.product_code,chr(13),''),chr(10),'') as product_code
,yield
,replace(replace(t1.security_term_to_maturity,chr(13),''),chr(10),'') as security_term_to_maturity
,replace(replace(t1.security_type,chr(13),''),chr(10),'') as security_type
,couponinterestamt
,dpa
,spread
,urpl

from ${iol_schema}.ctms_vi_cms_avg_cost_analyse_dtl_bond t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_vi_cms_avg_cost_analyse_dtl_bond.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
