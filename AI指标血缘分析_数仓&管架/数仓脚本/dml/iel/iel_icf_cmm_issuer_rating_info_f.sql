: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_issuer_rating_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_issuer_rating_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_cust_id,chr(13),''),chr(10),'') as issuer_cust_id
,replace(replace(t1.issuer_cn_name,chr(13),''),chr(10),'') as issuer_cn_name
,replace(replace(t1.issuer_en_name,chr(13),''),chr(10),'') as issuer_en_name
,replace(replace(t1.rating_corp_id,chr(13),''),chr(10),'') as rating_corp_id
,replace(replace(t1.rating_corp_cn_name,chr(13),''),chr(10),'') as rating_corp_cn_name
,replace(replace(t1.rating_rest_cd,chr(13),''),chr(10),'') as rating_rest_cd
,replace(replace(t1.rating_type_cd,chr(13),''),chr(10),'') as rating_type_cd
,t1.rating_dt as rating_dt
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
from ${icl_schema}.cmm_issuer_rating_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_issuer_rating_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes