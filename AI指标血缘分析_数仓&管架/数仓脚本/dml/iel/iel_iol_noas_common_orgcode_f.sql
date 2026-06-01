: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_noas_common_orgcode_f
CreateDate: 20180529
FileName:   ${iel_data_path}/noas_common_orgcode.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.organ_code_key,chr(13),''),chr(10),'') as organ_code_key 
,replace(replace(t1.organ_code,chr(13),''),chr(10),'') as organ_code 
,replace(replace(t1.fun_organ,chr(13),''),chr(10),'') as fun_organ 
,replace(replace(t1.fun_dep,chr(13),''),chr(10),'') as fun_dep 
,replace(replace(t1.zoneno,chr(13),''),chr(10),'') as zoneno 
,replace(replace(t1.p_bo_c_financial_code,chr(13),''),chr(10),'') as p_bo_c_financial_code 
,replace(replace(t1.financial_code,chr(13),''),chr(10),'') as financial_code 
,replace(replace(t1.s_w_i_f_t_code,chr(13),''),chr(10),'') as s_w_i_f_t_code 
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code 
,replace(replace(t1.legal,chr(13),''),chr(10),'') as legal 
,replace(replace(t1.business_license,chr(13),''),chr(10),'') as business_license 
,replace(replace(t1.organization_code,chr(13),''),chr(10),'') as organization_code 
,replace(replace(t1.tax_id,chr(13),''),chr(10),'') as tax_id 
,replace(replace(t1.organ_cn_full_name,chr(13),''),chr(10),'') as organ_cn_full_name 
,replace(replace(t1.organ_cn_short_name,chr(13),''),chr(10),'') as organ_cn_short_name 
,replace(replace(t1.organ_en_full_name,chr(13),''),chr(10),'') as organ_en_full_name 
,replace(replace(t1.organ_en_short_name,chr(13),''),chr(10),'') as organ_en_short_name 
,replace(replace(t1.organ_state_code,chr(13),''),chr(10),'') as organ_state_code 
,replace(replace(t1.organ_status,chr(13),''),chr(10),'') as organ_status 
,replace(replace(t1.organ_founding_date,chr(13),''),chr(10),'') as organ_founding_date 
,replace(replace(t1.organ_close_date,chr(13),''),chr(10),'') as organ_close_date 
,replace(replace(t1.organ_type,chr(13),''),chr(10),'') as organ_type 
,replace(replace(t1.is_st,chr(13),''),chr(10),'') as is_st 
,replace(replace(t1.is_hs,chr(13),''),chr(10),'') as is_hs 
,replace(replace(t1.is_yy,chr(13),''),chr(10),'') as is_yy 
,replace(replace(t1.is_xz,chr(13),''),chr(10),'') as is_xz 
,replace(replace(t1.is_zw,chr(13),''),chr(10),'') as is_zw 
,replace(replace(t1.organ_level,chr(13),''),chr(10),'') as organ_level 
,replace(replace(t1.leaf_note_flag,chr(13),''),chr(10),'') as leaf_note_flag 
,replace(replace(t1.xzup_organ_code,chr(13),''),chr(10),'') as xzup_organ_code 
,replace(replace(t1.zwup_organ_code,chr(13),''),chr(10),'') as zwup_organ_code 
,replace(replace(t1.hsup_organ_code,chr(13),''),chr(10),'') as hsup_organ_code 
,replace(replace(t1.seque,chr(13),''),chr(10),'') as seque 
,replace(replace(t1.post_code,chr(13),''),chr(10),'') as post_code 
,replace(replace(t1.country,chr(13),''),chr(10),'') as country 
,replace(replace(t1.province,chr(13),''),chr(10),'') as province 
,replace(replace(t1.city,chr(13),''),chr(10),'') as city 
,replace(replace(t1.county,chr(13),''),chr(10),'') as county 
,replace(replace(t1.address,chr(13),''),chr(10),'') as address 
,replace(replace(t1.email,chr(13),''),chr(10),'') as email 
,replace(replace(t1.u_r_l,chr(13),''),chr(10),'') as u_r_l 
,replace(replace(t1.country_code,chr(13),''),chr(10),'') as country_code 
,replace(replace(t1.area_code,chr(13),''),chr(10),'') as area_code 
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone 
,replace(replace(t1.sub_phone,chr(13),''),chr(10),'') as sub_phone 
,replace(replace(t1.service_phone,chr(13),''),chr(10),'') as service_phone 
,replace(replace(t1.financial_lic_num,chr(13),''),chr(10),'') as financial_lic_num 
,replace(replace(t1.organ_system,chr(13),''),chr(10),'') as organ_system 
,t1.last_updated_stamp as last_updated_stamp 
,t1.last_updated_tx_stamp as last_updated_tx_stamp 
,t1.created_stamp as created_stamp 
,t1.created_tx_stamp as created_tx_stamp 
,replace(replace(t1.orderno,chr(13),''),chr(10),'') as orderno 
,replace(replace(t1.cbrcfininstt_id,chr(13),''),chr(10),'') as cbrcfininstt_id 
,replace(replace(t1.union_financial_code,chr(13),''),chr(10),'') as union_financial_code 
,replace(replace(t1.isxnhs,chr(13),''),chr(10),'') as isxnhs 
,replace(replace(t1.head_emply_id,chr(13),''),chr(10),'') as head_emply_id 
,replace(replace(t1.is_business_division,chr(13),''),chr(10),'') as is_business_division 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iol_schema}.noas_common_orgcode t1 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/noas_common_orgcode.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes