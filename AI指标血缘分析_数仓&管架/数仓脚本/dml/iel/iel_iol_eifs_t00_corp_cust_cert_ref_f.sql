: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t00_corp_cust_cert_ref_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eifs_t00_corp_cust_cert_ref.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cert_index_seq,chr(13),''),chr(10),'') as cert_index_seq
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cert_effect_dt,chr(13),''),chr(10),'') as cert_effect_dt
,replace(replace(t1.cert_valid,chr(13),''),chr(10),'') as cert_valid
,replace(replace(t1.cert_invalid_dt,chr(13),''),chr(10),'') as cert_invalid_dt
,replace(replace(t1.cert_rgst_addr,chr(13),''),chr(10),'') as cert_rgst_addr
,replace(replace(t1.is_main_cert,chr(13),''),chr(10),'') as is_main_cert
,replace(replace(t1.cert_issue_province,chr(13),''),chr(10),'') as cert_issue_province
,replace(replace(t1.cert_issue_zone_cd,chr(13),''),chr(10),'') as cert_issue_zone_cd
,replace(replace(t1.cert_issue_org_name,chr(13),''),chr(10),'') as cert_issue_org_name
,replace(replace(t1.annual_insp_ind,chr(13),''),chr(10),'') as annual_insp_ind
,replace(replace(t1.recnt_year_check_dt,chr(13),''),chr(10),'') as recnt_year_check_dt
,replace(replace(t1.is_net_check,chr(13),''),chr(10),'') as is_net_check
,replace(replace(t1.network_verif,chr(13),''),chr(10),'') as network_verif
,replace(replace(t1.check_date,chr(13),''),chr(10),'') as check_date
,replace(replace(t1.create_te,chr(13),''),chr(10),'') as create_te
,replace(replace(t1.create_org,chr(13),''),chr(10),'') as create_org
,replace(replace(t1.init_system_id,chr(13),''),chr(10),'') as init_system_id
,t1.init_created_ts as init_created_ts
,t1.created_ts as created_ts
,t1.updated_ts as updated_ts
,replace(replace(t1.last_updated_te,chr(13),''),chr(10),'') as last_updated_te
,replace(replace(t1.last_updated_org,chr(13),''),chr(10),'') as last_updated_org
,replace(replace(t1.last_system_id,chr(13),''),chr(10),'') as last_system_id
,t1.last_updated_ts as last_updated_ts
,replace(replace(t1.cert_issue_zone_name,chr(13),''),chr(10),'') as cert_issue_zone_name
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
from ${iol_schema}.eifs_t00_corp_cust_cert_ref t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t00_corp_cust_cert_ref.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes