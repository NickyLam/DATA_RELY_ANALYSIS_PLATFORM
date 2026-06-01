: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_bank_cust_corp_f
CreateDate: 20240506
FileName:   ${iel_data_path}/rtis_bank_cust_corp.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,biz_lic_exp_date
,open_at
,create_at
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,last_update_at
,replace(replace(t1.last_update_by,chr(13),''),chr(10),'') as last_update_by
,replace(replace(t1.cust_surname,chr(13),''),chr(10),'') as cust_surname
,replace(replace(t1.cust_middle_name,chr(13),''),chr(10),'') as cust_middle_name
,replace(replace(t1.cust_first_name,chr(13),''),chr(10),'') as cust_first_name
,replace(replace(t1.id_card_type,chr(13),''),chr(10),'') as id_card_type
,replace(replace(t1.id_card_number,chr(13),''),chr(10),'') as id_card_number
,replace(replace(t1.mobile_number,chr(13),''),chr(10),'') as mobile_number
,age
,replace(replace(t1.cust_open_inst_prov,chr(13),''),chr(10),'') as cust_open_inst_prov
,replace(replace(t1.cust_open_inst_city,chr(13),''),chr(10),'') as cust_open_inst_city
,replace(replace(t1.id_card_prov,chr(13),''),chr(10),'') as id_card_prov
,replace(replace(t1.id_card_city,chr(13),''),chr(10),'') as id_card_city
,replace(replace(t1.mobile_prov,chr(13),''),chr(10),'') as mobile_prov
,replace(replace(t1.mobile_city,chr(13),''),chr(10),'') as mobile_city
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.cust_build_channel,chr(13),''),chr(10),'') as cust_build_channel
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.register_address,chr(13),''),chr(10),'') as register_address
,replace(replace(t1.business_address,chr(13),''),chr(10),'') as business_address
,replace(replace(t1.operation_no,chr(13),''),chr(10),'') as operation_no
,replace(replace(t1.corporate_card_indate,chr(13),''),chr(10),'') as corporate_card_indate
,replace(replace(t1.cust_principal_name,chr(13),''),chr(10),'') as cust_principal_name
,replace(replace(t1.cust_principal_card_type,chr(13),''),chr(10),'') as cust_principal_card_type
,cust_principal_card_indate
,replace(replace(t1.cust_receiptor_name,chr(13),''),chr(10),'') as cust_receiptor_name
,replace(replace(t1.cust_receiptor_card_type,chr(13),''),chr(10),'') as cust_receiptor_card_type
,replace(replace(t1.cust_receiptor_card_no,chr(13),''),chr(10),'') as cust_receiptor_card_no
,replace(replace(t1.cust_linkman_name,chr(13),''),chr(10),'') as cust_linkman_name
,replace(replace(t1.cust_linkman_card_type,chr(13),''),chr(10),'') as cust_linkman_card_type
,replace(replace(t1.cust_linkman_card_no,chr(13),''),chr(10),'') as cust_linkman_card_no
,replace(replace(t1.cust_agent_name,chr(13),''),chr(10),'') as cust_agent_name
,replace(replace(t1.cust_agent_card_type,chr(13),''),chr(10),'') as cust_agent_card_type
,replace(replace(t1.cust_agent_card_no,chr(13),''),chr(10),'') as cust_agent_card_no
,replace(replace(t1.cust_charater,chr(13),''),chr(10),'') as cust_charater
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t1.corporate_phone_no,chr(13),''),chr(10),'') as corporate_phone_no
,replace(replace(t1.finance_mgr_phone_no,chr(13),''),chr(10),'') as finance_mgr_phone_no
,replace(replace(t1.posta_addr,chr(13),''),chr(10),'') as posta_addr
,replace(replace(t1.iden_addr,chr(13),''),chr(10),'') as iden_addr
,replace(replace(t1.work_unit_addr,chr(13),''),chr(10),'') as work_unit_addr
,replace(replace(t1.if_acct_black,chr(13),''),chr(10),'') as if_acct_black
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_stat,chr(13),''),chr(10),'') as cust_stat
,replace(replace(t1.cust_open_inst_no,chr(13),''),chr(10),'') as cust_open_inst_no
,replace(replace(t1.cust_open_inst_name,chr(13),''),chr(10),'') as cust_open_inst_name
,replace(replace(t1.corp_cert_type,chr(13),''),chr(10),'') as corp_cert_type
,replace(replace(t1.corp_cert_no,chr(13),''),chr(10),'') as corp_cert_no
,replace(replace(t1.cust_kind,chr(13),''),chr(10),'') as cust_kind
,replace(replace(t1.country,chr(13),''),chr(10),'') as country
,replace(replace(t1.ind_type,chr(13),''),chr(10),'') as ind_type
,replace(replace(t1.corp_scale,chr(13),''),chr(10),'') as corp_scale
,replace(replace(t1.corp_scope,chr(13),''),chr(10),'') as corp_scope
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,replace(replace(t1.fex,chr(13),''),chr(10),'') as fex
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.reg_capital,chr(13),''),chr(10),'') as reg_capital
,replace(replace(t1.contrib_capital,chr(13),''),chr(10),'') as contrib_capital
,reg_date
,replace(replace(t1.legal_name,chr(13),''),chr(10),'') as legal_name
,replace(replace(t1.legal_cert_type,chr(13),''),chr(10),'') as legal_cert_type
,replace(replace(t1.legal_cert_no,chr(13),''),chr(10),'') as legal_cert_no
,replace(replace(t1.financial_name,chr(13),''),chr(10),'') as financial_name
,replace(replace(t1.financial_cert_type,chr(13),''),chr(10),'') as financial_cert_type
,replace(replace(t1.financial_cert_no,chr(13),''),chr(10),'') as financial_cert_no
,replace(replace(t1.manager_no,chr(13),''),chr(10),'') as manager_no
,replace(replace(t1.manager_name,chr(13),''),chr(10),'') as manager_name
,replace(replace(t1.manager_mobile,chr(13),''),chr(10),'') as manager_mobile

from ${iol_schema}.rtis_bank_cust_corp t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_bank_cust_corp.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
