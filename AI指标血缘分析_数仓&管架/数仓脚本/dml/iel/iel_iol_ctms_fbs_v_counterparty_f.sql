: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_fbs_v_counterparty_f
CreateDate: 20251022
FileName:   ${iel_data_path}/ctms_fbs_v_counterparty.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,counterparty_seq
,cus_number
,replace(replace(t1.label,chr(13),''),chr(10),'') as label
,replace(replace(t1.counterparty_cname,chr(13),''),chr(10),'') as counterparty_cname
,replace(replace(t1.counterparty_ename,chr(13),''),chr(10),'') as counterparty_ename
,replace(replace(t1.contact_name,chr(13),''),chr(10),'') as contact_name
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.fax,chr(13),''),chr(10),'') as fax
,update_user
,update_time
,replace(replace(t1.is_issuer,chr(13),''),chr(10),'') as is_issuer
,replace(replace(t1.is_bank,chr(13),''),chr(10),'') as is_bank
,replace(replace(t1.is_guarantee,chr(13),''),chr(10),'') as is_guarantee
,replace(replace(t1.is_custody,chr(13),''),chr(10),'') as is_custody
,replace(replace(t1.customer_type,chr(13),''),chr(10),'') as customer_type
,parent
,replace(replace(t1.rating_level,chr(13),''),chr(10),'') as rating_level
,replace(replace(t1.ex_code,chr(13),''),chr(10),'') as ex_code
,replace(replace(t1.ex_account,chr(13),''),chr(10),'') as ex_account
,replace(replace(t1.swift_code,chr(13),''),chr(10),'') as swift_code
,replace(replace(t1.ref_issuer_id,chr(13),''),chr(10),'') as ref_issuer_id
,replace(replace(t1.cfets_member_id,chr(13),''),chr(10),'') as cfets_member_id
,replace(replace(t1.counterparty_short_cname,chr(13),''),chr(10),'') as counterparty_short_cname
,replace(replace(t1.counterparty_short_ename,chr(13),''),chr(10),'') as counterparty_short_ename
,replace(replace(t1.cfets_fx_member_id,chr(13),''),chr(10),'') as cfets_fx_member_id
,replace(replace(t1.cfets_member_attr,chr(13),''),chr(10),'') as cfets_member_attr
,replace(replace(t1.counterparty_fx_short_ename,chr(13),''),chr(10),'') as counterparty_fx_short_ename
,replace(replace(t1.interbanktype,chr(13),''),chr(10),'') as interbanktype
,replace(replace(t1.overseas,chr(13),''),chr(10),'') as overseas

from ${iol_schema}.ctms_fbs_v_counterparty t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_fbs_v_counterparty.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
