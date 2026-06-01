: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_eifs_t01_corp_cust_ext_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/eifs_t01_corp_cust_ext_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.cust_card_level_cd,chr(13),''),chr(10),'') as cust_card_level_cd
,replace(replace(t1.cust_asset_level_cd,chr(13),''),chr(10),'') as cust_asset_level_cd
,replace(replace(t1.cust_risk_level_cd,chr(13),''),chr(10),'') as cust_risk_level_cd
,replace(replace(t1.bad_rec_reason,chr(13),''),chr(10),'') as bad_rec_reason
,replace(replace(t1.blklist_cust_ind,chr(13),''),chr(10),'') as blklist_cust_ind
,replace(replace(t1.up_blklist_dt,chr(13),''),chr(10),'') as up_blklist_dt
,replace(replace(t1.blklist_type,chr(13),''),chr(10),'') as blklist_type
,t1.credit_limit_flag_cd as credit_limit_flag_cd
,t1.used_crdt_limit as used_crdt_limit
,t1.avail_crdt_limit as avail_crdt_limit
,replace(replace(t1.loan_card_num,chr(13),''),chr(10),'') as loan_card_num
,replace(replace(t1.resdnt_char_cd,chr(13),''),chr(10),'') as resdnt_char_cd
,replace(replace(t1.group_cust_ind,chr(13),''),chr(10),'') as group_cust_ind
,replace(replace(t1.belong_group_num,chr(13),''),chr(10),'') as belong_group_num
,replace(replace(t1.belong_group_name,chr(13),''),chr(10),'') as belong_group_name
,replace(replace(t1.eco_type,chr(13),''),chr(10),'') as eco_type
,replace(replace(t1.list_corp_ind,chr(13),''),chr(10),'') as list_corp_ind
,replace(replace(t1.shares_code,chr(13),''),chr(10),'') as shares_code
,replace(replace(t1.listed_address,chr(13),''),chr(10),'') as listed_address
,replace(replace(t1.national_treatment,chr(13),''),chr(10),'') as national_treatment
,replace(replace(t1.first_credit_rela_time,chr(13),''),chr(10),'') as first_credit_rela_time
,t1.admin_number as admin_number
,replace(replace(t1.lei,chr(13),''),chr(10),'') as lei
,replace(replace(t1.lei_role,chr(13),''),chr(10),'') as lei_role
,replace(replace(t1.dig_econ,chr(13),''),chr(10),'') as dig_econ
,replace(replace(t1.new_str_eme,chr(13),''),chr(10),'') as new_str_eme
,replace(replace(t1.int_crdt_rating_cd,chr(13),''),chr(10),'') as int_crdt_rating_cd
,replace(replace(t1.org_status_cd,chr(13),''),chr(10),'') as org_status_cd
,replace(replace(t1.eco_type_cd,chr(13),''),chr(10),'') as eco_type_cd
,replace(replace(t1.rgst_dt,chr(13),''),chr(10),'') as rgst_dt
,replace(replace(t1.indus_type_cd_level5_cls,chr(13),''),chr(10),'') as indus_type_cd_level5_cls
,replace(replace(t1.indus_type_cd_crdt_rating,chr(13),''),chr(10),'') as indus_type_cd_crdt_rating
,t1.open_cap as open_cap
,replace(replace(t1.lmt_or_encrge_indus_cd,chr(13),''),chr(10),'') as lmt_or_encrge_indus_cd
,replace(replace(t1.loan_card_num_status,chr(13),''),chr(10),'') as loan_card_num_status
,replace(replace(t1.indus_type_cd_nat_stan,chr(13),''),chr(10),'') as indus_type_cd_nat_stan
,replace(replace(t1.industry_type,chr(13),''),chr(10),'') as industry_type
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
,replace(replace(t1.owner_type,chr(13),''),chr(10),'') as owner_type
,replace(replace(t1.legal_name,chr(13),''),chr(10),'') as legal_name
,replace(replace(t1.legal_org_type,chr(13),''),chr(10),'') as legal_org_type
,replace(replace(t1.legal_cust_num,chr(13),''),chr(10),'') as legal_cust_num
,replace(replace(t1.superior_cust_num,chr(13),''),chr(10),'') as superior_cust_num
,replace(replace(t1.technology_org_type,chr(13),''),chr(10),'') as technology_org_type
,t1.technology_org_affirm_ts as technology_org_affirm_ts
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_sys_num,chr(13),''),chr(10),'') as src_sys_num
,replace(replace(t1.last_updated_src_sys_num,chr(13),''),chr(10),'') as last_updated_src_sys_num
from ${iol_schema}.eifs_t01_corp_cust_ext_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/eifs_t01_corp_cust_ext_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes