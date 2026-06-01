: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_credit_operation_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rtis_credit_operation.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,t1.id_ as id_
,replace(replace(t1.tenant_id,chr(13),''),chr(10),'') as tenant_id
,replace(replace(t1.user_id,chr(13),''),chr(10),'') as user_id
,replace(replace(t1.oper_no,chr(13),''),chr(10),'') as oper_no
,replace(replace(t1.oper_type,chr(13),''),chr(10),'') as oper_type
,replace(replace(t1.apply_chnl,chr(13),''),chr(10),'') as apply_chnl
,t1.oper_time as oper_time
,replace(replace(t1.oper_status,chr(13),''),chr(10),'') as oper_status
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t1.col_cust_id,chr(13),''),chr(10),'') as col_cust_id
,replace(replace(t1.col_cust_name,chr(13),''),chr(10),'') as col_cust_name
,t1.amount as amount
,replace(replace(t1.account_id,chr(13),''),chr(10),'') as account_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.bank_card_no,chr(13),''),chr(10),'') as bank_card_no
,replace(replace(t1.bank_card_type,chr(13),''),chr(10),'') as bank_card_type
,replace(replace(t1.ip_addr,chr(13),''),chr(10),'') as ip_addr
,replace(replace(t1.ip_prv,chr(13),''),chr(10),'') as ip_prv
,replace(replace(t1.ip_city,chr(13),''),chr(10),'') as ip_city
,replace(replace(t1.mac,chr(13),''),chr(10),'') as mac
,replace(replace(t1.imei,chr(13),''),chr(10),'') as imei
,replace(replace(t1.sim,chr(13),''),chr(10),'') as sim
,replace(replace(t1.device_finger,chr(13),''),chr(10),'') as device_finger
,t1.create_time as create_time
,replace(replace(t1.id_card,chr(13),''),chr(10),'') as id_card
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.phone_addr,chr(13),''),chr(10),'') as phone_addr
,replace(replace(t1.phone_prv,chr(13),''),chr(10),'') as phone_prv
,replace(replace(t1.phone_city,chr(13),''),chr(10),'') as phone_city
,replace(replace(t1.phone_company,chr(13),''),chr(10),'') as phone_company
,replace(replace(t1.oper_from,chr(13),''),chr(10),'') as oper_from
,replace(replace(t1.location_x,chr(13),''),chr(10),'') as location_x
,replace(replace(t1.location_y,chr(13),''),chr(10),'') as location_y
,t1.last_update_time as last_update_time
,replace(replace(t1.last_status,chr(13),''),chr(10),'') as last_status
,t1.create_at as create_at
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,t1.last_update_at as last_update_at
,replace(replace(t1.last_update_by,chr(13),''),chr(10),'') as last_update_by
,replace(replace(t1.regiser_address,chr(13),''),chr(10),'') as regiser_address
,replace(replace(t1.company_tel,chr(13),''),chr(10),'') as company_tel
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.rn_auth_phone,chr(13),''),chr(10),'') as rn_auth_phone
,replace(replace(t1.rn_auth_card_no,chr(13),''),chr(10),'') as rn_auth_card_no
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.corporate_business_no,chr(13),''),chr(10),'') as corporate_business_no
,replace(replace(t1.product_application,chr(13),''),chr(10),'') as product_application
,t1.org_rec_amount as org_rec_amount
,t1.registered_amount as registered_amount
,replace(replace(t1.id_card_type,chr(13),''),chr(10),'') as id_card_type
,replace(replace(t1.id_card_number,chr(13),''),chr(10),'') as id_card_number
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.phone_prov,chr(13),''),chr(10),'') as phone_prov
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.latitude,chr(13),''),chr(10),'') as latitude
,replace(replace(t1.phone_1_7,chr(13),''),chr(10),'') as phone_1_7
,replace(replace(t1.id_card_number_1_4,chr(13),''),chr(10),'') as id_card_number_1_4
,replace(replace(t1.id_card_county,chr(13),''),chr(10),'') as id_card_county
,replace(replace(t1.id_card_prov,chr(13),''),chr(10),'') as id_card_prov
,replace(replace(t1.age,chr(13),''),chr(10),'') as age
,replace(replace(t1.shareholder_id_card_type,chr(13),''),chr(10),'') as shareholder_id_card_type
,replace(replace(t1.shareholder_id_card_no,chr(13),''),chr(10),'') as shareholder_id_card_no
,replace(replace(t1.cust_occu,chr(13),''),chr(10),'') as cust_occu
,replace(replace(t1.cust_linkman_card_type,chr(13),''),chr(10),'') as cust_linkman_card_type
,replace(replace(t1.cust_linkman_card_no,chr(13),''),chr(10),'') as cust_linkman_card_no
,replace(replace(t1.cust_famliy_name,chr(13),''),chr(10),'') as cust_famliy_name
,replace(replace(t1.cust_delegate_card_type,chr(13),''),chr(10),'') as cust_delegate_card_type
,replace(replace(t1.cust_delegate_card_no,chr(13),''),chr(10),'') as cust_delegate_card_no
,replace(replace(t1.cust_receiptor_card_type,chr(13),''),chr(10),'') as cust_receiptor_card_type
,replace(replace(t1.cust_receiptor_card_no,chr(13),''),chr(10),'') as cust_receiptor_card_no
,replace(replace(t1.cust_principal_card_type,chr(13),''),chr(10),'') as cust_principal_card_type
,replace(replace(t1.cust_principal_card_no,chr(13),''),chr(10),'') as cust_principal_card_no
,replace(replace(t1.corporate_type,chr(13),''),chr(10),'') as corporate_type
,replace(replace(t1.corporate_no,chr(13),''),chr(10),'') as corporate_no
,replace(replace(t1.address_anthenticity_score,chr(13),''),chr(10),'') as address_anthenticity_score
,replace(replace(t1.address_similarity,chr(13),''),chr(10),'') as address_similarity
,replace(replace(t1.cust_address,chr(13),''),chr(10),'') as cust_address
,replace(replace(t1.agent_id_card_no,chr(13),''),chr(10),'') as agent_id_card_no
,replace(replace(t1.coordinate_type,chr(13),''),chr(10),'') as coordinate_type
,replace(replace(t1.lot_lat_city,chr(13),''),chr(10),'') as lot_lat_city
,replace(replace(t1.longitude,chr(13),''),chr(10),'') as longitude
,replace(replace(t1.id_card_country,chr(13),''),chr(10),'') as id_card_country
,replace(replace(t1.is_false_no,chr(13),''),chr(10),'') as is_false_no
,replace(replace(t1.corporate_bussiness_no,chr(13),''),chr(10),'') as corporate_bussiness_no
,replace(replace(t1.corporate_phone_no,chr(13),''),chr(10),'') as corporate_phone_no
,replace(replace(t1.proxy_ip_flag,chr(13),''),chr(10),'') as proxy_ip_flag
,replace(replace(t1.idc_ip_flag,chr(13),''),chr(10),'') as idc_ip_flag
,replace(replace(t1.virtual_operator_no,chr(13),''),chr(10),'') as virtual_operator_no
,replace(replace(t1.oper_prov,chr(13),''),chr(10),'') as oper_prov
,replace(replace(t1.oper_city,chr(13),''),chr(10),'') as oper_city
,replace(replace(t1.oper_site,chr(13),''),chr(10),'') as oper_site
,replace(replace(t1.biz_code,chr(13),''),chr(10),'') as biz_code
,replace(replace(t1.oper_county,chr(13),''),chr(10),'') as oper_county
,replace(replace(t1.finance_manager_no,chr(13),''),chr(10),'') as finance_manager_no
,replace(replace(t1.finance_manager_business_no,chr(13),''),chr(10),'') as finance_manager_business_no
,replace(replace(t1.bind_card_no,chr(13),''),chr(10),'') as bind_card_no
,replace(replace(t1.account_holder_name,chr(13),''),chr(10),'') as account_holder_name
,replace(replace(t1.business_scope,chr(13),''),chr(10),'') as business_scope
,replace(replace(t1.prove_paper_indate,chr(13),''),chr(10),'') as prove_paper_indate
,replace(replace(t1.prove_paper_no,chr(13),''),chr(10),'') as prove_paper_no
,replace(replace(t1.corporate_name,chr(13),''),chr(10),'') as corporate_name
,replace(replace(t1.oper_ip,chr(13),''),chr(10),'') as oper_ip
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.id_card_indate,chr(13),''),chr(10),'') as id_card_indate
,t1.open_at as open_at
from ${iol_schema}.rtis_credit_operation t1
where etl_dt <= to_date('${batch_date}', 'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_credit_operation.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes