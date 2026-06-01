: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_cptys_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_vs_cptys.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cptys_id as cptys_id
,t1.aspclient_id as aspclient_id
,replace(replace(t1.cptys_shortname,chr(13),''),chr(10),'') as cptys_shortname
,replace(replace(t1.cptys_name,chr(13),''),chr(10),'') as cptys_name
,replace(replace(t1.cptys_name2,chr(13),''),chr(10),'') as cptys_name2
,replace(replace(t1.name_src,chr(13),''),chr(10),'') as name_src
,replace(replace(t1.key_src,chr(13),''),chr(10),'') as key_src
,replace(replace(t1.islink_src,chr(13),''),chr(10),'') as islink_src
,t1.lastmodified as lastmodified
,t1.datasymbolconfig_id as datasymbolconfig_id
,replace(replace(t1.label,chr(13),''),chr(10),'') as label
,t1.rating_level as rating_level
,replace(replace(t1.field1,chr(13),''),chr(10),'') as field1
,replace(replace(t1.field2,chr(13),''),chr(10),'') as field2
,replace(replace(t1.field3,chr(13),''),chr(10),'') as field3
,replace(replace(t1.counterparty_ename,chr(13),''),chr(10),'') as counterparty_ename
,replace(replace(t1.counterparty_short_ename,chr(13),''),chr(10),'') as counterparty_short_ename
,replace(replace(t1.contact_name,chr(13),''),chr(10),'') as contact_name
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,replace(replace(t1.is_issuer,chr(13),''),chr(10),'') as is_issuer
,replace(replace(t1.is_bank,chr(13),''),chr(10),'') as is_bank
,replace(replace(t1.is_guarantee,chr(13),''),chr(10),'') as is_guarantee
,replace(replace(t1.is_custody,chr(13),''),chr(10),'') as is_custody
,replace(replace(t1.customer_type_code,chr(13),''),chr(10),'') as customer_type_code
,replace(replace(t1.customer_type_name,chr(13),''),chr(10),'') as customer_type_name
,t1.parent as parent
,replace(replace(t1.ex_code,chr(13),''),chr(10),'') as ex_code
,replace(replace(t1.ex_account,chr(13),''),chr(10),'') as ex_account
,replace(replace(t1.swift_code,chr(13),''),chr(10),'') as swift_code
,replace(replace(t1.ref_issuer_id,chr(13),''),chr(10),'') as ref_issuer_id
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.cfets_member_attr,chr(13),''),chr(10),'') as cfets_member_attr
,replace(replace(t1.master_short_cname,chr(13),''),chr(10),'') as master_short_cname
,replace(replace(t1.master_cfets_id,chr(13),''),chr(10),'') as master_cfets_id
,replace(replace(t1.master_cnty_seq,chr(13),''),chr(10),'') as master_cnty_seq

from ${iol_schema}.ctms_tbs_vs_cptys t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_cptys.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
