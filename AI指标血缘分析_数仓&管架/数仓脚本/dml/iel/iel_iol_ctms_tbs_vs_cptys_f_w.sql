: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_cptys_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_cptys_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(cptys_id,chr(10),''),chr(13),'') as cptys_id
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(cptys_shortname,chr(10),''),chr(13),'') as cptys_shortname
,replace(replace(cptys_name,chr(10),''),chr(13),'') as cptys_name
,replace(replace(cptys_name2,chr(10),''),chr(13),'') as cptys_name2
,replace(replace(name_src,chr(10),''),chr(13),'') as name_src
,replace(replace(key_src,chr(10),''),chr(13),'') as key_src
,replace(replace(islink_src,chr(10),''),chr(13),'') as islink_src
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(datasymbolconfig_id,chr(10),''),chr(13),'') as datasymbolconfig_id
,replace(replace(label,chr(10),''),chr(13),'') as label
,replace(replace(rating_level,chr(10),''),chr(13),'') as rating_level
,replace(replace(field1,chr(10),''),chr(13),'') as field1
,replace(replace(field2,chr(10),''),chr(13),'') as field2
,replace(replace(field3,chr(10),''),chr(13),'') as field3
,replace(replace(counterparty_ename,chr(10),''),chr(13),'') as counterparty_ename
,replace(replace(counterparty_short_ename,chr(10),''),chr(13),'') as counterparty_short_ename
,replace(replace(contact_name,chr(10),''),chr(13),'') as contact_name
,replace(replace(telephone,chr(10),''),chr(13),'') as telephone
,replace(replace(fax,chr(10),''),chr(13),'') as fax
,replace(replace(is_issuer,chr(10),''),chr(13),'') as is_issuer
,replace(replace(is_bank,chr(10),''),chr(13),'') as is_bank
,replace(replace(is_guarantee,chr(10),''),chr(13),'') as is_guarantee
,replace(replace(is_custody,chr(10),''),chr(13),'') as is_custody
,replace(replace(customer_type_code,chr(10),''),chr(13),'') as customer_type_code
,replace(replace(customer_type_name,chr(10),''),chr(13),'') as customer_type_name
,replace(replace(parent,chr(10),''),chr(13),'') as parent
,replace(replace(ex_code,chr(10),''),chr(13),'') as ex_code
,replace(replace(ex_account,chr(10),''),chr(13),'') as ex_account
,replace(replace(swift_code,chr(10),''),chr(13),'') as swift_code
,replace(replace(ref_issuer_id,chr(10),''),chr(13),'') as ref_issuer_id
,replace(replace(issuer_name,chr(10),''),chr(13),'') as issuer_name
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_vs_cptys
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_cptys_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes