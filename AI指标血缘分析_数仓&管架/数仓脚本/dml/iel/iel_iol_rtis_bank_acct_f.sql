: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rtis_bank_acct_f
CreateDate: 20240506
FileName:   ${iel_data_path}/rtis_bank_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,replace(replace(t1.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd
,asset_under_management
,replace(replace(t1.emply_flg,chr(13),''),chr(10),'') as emply_flg
,m_avg_bal
,aum_m_avg_bal
,replace(replace(t1.acct_belong_org_id,chr(13),''),chr(10),'') as acct_belong_org_id
,replace(replace(t1.control_type,chr(13),''),chr(10),'') as control_type
,replace(replace(t1.restraint_type,chr(13),''),chr(10),'') as restraint_type
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.open_inst_no,chr(13),''),chr(10),'') as open_inst_no
,acct_opene_at
,replace(replace(t1.acct_type,chr(13),''),chr(10),'') as acct_type
,replace(replace(t1.card_type,chr(13),''),chr(10),'') as card_type
,replace(replace(t1.acct_medium,chr(13),''),chr(10),'') as acct_medium
,daily_balance
,replace(replace(t1.id_card_type,chr(13),''),chr(10),'') as id_card_type
,replace(replace(t1.id_card_number,chr(13),''),chr(10),'') as id_card_number
,create_at
,replace(replace(t1.create_by,chr(13),''),chr(10),'') as create_by
,last_update_at
,replace(replace(t1.last_update_by,chr(13),''),chr(10),'') as last_update_by
,replace(replace(t1.acct_stat,chr(13),''),chr(10),'') as acct_stat
,replace(replace(t1.cry_type,chr(13),''),chr(10),'') as cry_type
,replace(replace(t1.acct_kind,chr(13),''),chr(10),'') as acct_kind
,replace(replace(t1.open_inst_name,chr(13),''),chr(10),'') as open_inst_name
,replace(replace(t1.open_agent,chr(13),''),chr(10),'') as open_agent
,replace(replace(t1.open_agent_id_type,chr(13),''),chr(10),'') as open_agent_id_type
,replace(replace(t1.open_agent_id_no,chr(13),''),chr(10),'') as open_agent_id_no
,replace(replace(t1.open_agent_tel,chr(13),''),chr(10),'') as open_agent_tel
,replace(replace(t1.company_contact,chr(13),''),chr(10),'') as company_contact
,replace(replace(t1.company_contact_id_type,chr(13),''),chr(10),'') as company_contact_id_type
,replace(replace(t1.company_contact_id_no,chr(13),''),chr(10),'') as company_contact_id_no
,replace(replace(t1.company_contact_tel,chr(13),''),chr(10),'') as company_contact_tel
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.card_city,chr(13),''),chr(10),'') as card_city
,card_indate
,limit_amount
,replace(replace(t1.phone_number,chr(13),''),chr(10),'') as phone_number
,last_update_time
,replace(replace(t1.is_dormancy_account,chr(13),''),chr(10),'') as is_dormancy_account
,replace(replace(t1.e_acct_type,chr(13),''),chr(10),'') as e_acct_type
,replace(replace(t1.cust_type,chr(13),''),chr(10),'') as cust_type

from ${iol_schema}.rtis_bank_acct t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rtis_bank_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
