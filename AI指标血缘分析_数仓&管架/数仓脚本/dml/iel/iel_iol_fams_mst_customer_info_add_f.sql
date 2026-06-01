: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_mst_customer_info_add_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_mst_customer_info_add.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(customer_id,chr(13),''),chr(10),'') as customer_id
      ,replace(replace(party_type3,chr(13),''),chr(10),'') as party_type3
      ,replace(replace(party_type2,chr(13),''),chr(10),'') as party_type2
      ,replace(replace(party_type1,chr(13),''),chr(10),'') as party_type1
      ,replace(replace(industry,chr(13),''),chr(10),'') as industry
      ,replace(replace(industry2,chr(13),''),chr(10),'') as industry2
      ,replace(replace(insititute_code,chr(13),''),chr(10),'') as insititute_code
      ,replace(replace(is_gov,chr(13),''),chr(10),'') as is_gov
      ,main_capital
      ,register_capital
      ,replace(replace(province,chr(13),''),chr(10),'') as province
      ,replace(replace(city,chr(13),''),chr(10),'') as city
      ,replace(replace(county,chr(13),''),chr(10),'') as county
      ,replace(replace(holding_type,chr(13),''),chr(10),'') as holding_type
      ,replace(replace(customer_obj_type,chr(13),''),chr(10),'') as customer_obj_type
      ,replace(replace(is_listed_company,chr(13),''),chr(10),'') as is_listed_company
      ,replace(replace(is_group_customer,chr(13),''),chr(10),'') as is_group_customer
      ,replace(replace(parent_customer_id,chr(13),''),chr(10),'') as parent_customer_id
      ,replace(replace(parent_customer_name,chr(13),''),chr(10),'') as parent_customer_name
      ,replace(replace(is_private,chr(13),''),chr(10),'') as is_private
      ,replace(replace(is_escape_dept,chr(13),''),chr(10),'') as is_escape_dept
      ,replace(replace(credit_type,chr(13),''),chr(10),'') as credit_type
      ,replace(replace(is_credit_related_trd,chr(13),''),chr(10),'') as is_credit_related_trd
      ,replace(replace(struct_adjust_type,chr(13),''),chr(10),'') as struct_adjust_type
      ,replace(replace(indus_upgrate_type,chr(13),''),chr(10),'') as indus_upgrate_type
      ,'' as busi_scope
      ,'' as main_busi
      ,replace(replace(sex,chr(13),''),chr(10),'') as sex
      ,replace(replace(person_id,chr(13),''),chr(10),'') as person_id
      ,replace(replace(m_phone,chr(13),''),chr(10),'') as m_phone
      ,replace(replace(phone,chr(13),''),chr(10),'') as phone
      ,replace(replace(position,chr(13),''),chr(10),'') as position
      ,replace(replace(company_name,chr(13),''),chr(10),'') as company_name
      ,replace(replace(address,chr(13),''),chr(10),'') as address
      ,replace(replace(mail,chr(13),''),chr(10),'') as mail
      ,replace(replace(property,chr(13),''),chr(10),'') as property
      ,replace(replace(company_nature,chr(13),''),chr(10),'') as company_nature
      ,replace(replace(link_id1,chr(13),''),chr(10),'') as link_id1
      ,replace(replace(link_id2,chr(13),''),chr(10),'') as link_id2
      ,replace(replace(link_id3,chr(13),''),chr(10),'') as link_id3
      ,replace(replace(remark,chr(13),''),chr(10),'') as remark
      ,replace(replace(create_user,chr(13),''),chr(10),'') as create_user
      ,replace(replace(create_dept,chr(13),''),chr(10),'') as create_dept
      ,create_time
      ,replace(replace(update_user,chr(13),''),chr(10),'') as update_user
      ,update_time
      ,replace(replace(hs_type,chr(13),''),chr(10),'') as hs_type
      ,replace(replace(is_fin_licence,chr(13),''),chr(10),'') as is_fin_licence
      ,start_dt
      ,end_dt
      ,replace(replace(id_mark,chr(13),''),chr(10),'') as id_mark
  from ${iol_schema}.fams_mst_customer_info_add
 where start_dt <= to_date('${batch_date}','yyyymmdd')
   and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_mst_customer_info_add.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes