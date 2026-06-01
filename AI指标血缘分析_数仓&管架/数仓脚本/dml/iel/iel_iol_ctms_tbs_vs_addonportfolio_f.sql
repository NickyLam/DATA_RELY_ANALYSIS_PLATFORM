: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_addonportfolio_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_addonportfolio.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.addonportfolio_id as addonportfolio_id
,t1.aspclient_id as aspclient_id
,t1.owner_number as owner_number
,replace(replace(t1.owner_code,chr(13),''),chr(10),'') as owner_code
,replace(replace(t1.owner_name,chr(13),''),chr(10),'') as owner_name
,t1.portfolio_id as portfolio_id
,replace(replace(t1.portfolioname,chr(13),''),chr(10),'') as portfolioname
,t1.keepfolder_id_default as keepfolder_id_default
,t1.assettype_id_default as assettype_id_default
,t1.lastmodified as lastmodified
,t1.datasymbol_id as datasymbol_id
,t1.buztype_id_default as buztype_id_default
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,t1.nstd_id_default as nstd_id_default
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.ctms_tbs_vs_addonportfolio t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_addonportfolio.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes