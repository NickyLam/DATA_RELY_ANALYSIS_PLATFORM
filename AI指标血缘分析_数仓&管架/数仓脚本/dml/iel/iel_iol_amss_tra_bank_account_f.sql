: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amss_tra_bank_account_f
CreateDate: 20250508
FileName:   ${iel_data_path}/amss_tra_bank_account.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.account_id,chr(13),''),chr(10),'') as account_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.account_code,chr(13),''),chr(10),'') as account_code
,bank_id
,replace(replace(t1.account_name,chr(13),''),chr(10),'') as account_name
,account_type
,replace(replace(t1.contact_line,chr(13),''),chr(10),'') as contact_line
,replace(replace(t1.remit_account_code,chr(13),''),chr(10),'') as remit_account_code
,is_inline
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.province,chr(13),''),chr(10),'') as province
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,id_card_type
,replace(replace(t1.id_card,chr(13),''),chr(10),'') as id_card
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.tel,chr(13),''),chr(10),'') as tel
,examine_status
,examine_time
,replace(replace(t1.examine_status_remark,chr(13),''),chr(10),'') as examine_status_remark
,replace(replace(t1.examine_emp,chr(13),''),chr(10),'') as examine_emp
,enabled
,replace(replace(t1.data_sign,chr(13),''),chr(10),'') as data_sign
,data_source
,replace(replace(t1.fld_s1,chr(13),''),chr(10),'') as fld_s1
,replace(replace(t1.fld_s2,chr(13),''),chr(10),'') as fld_s2
,replace(replace(t1.fld_s3,chr(13),''),chr(10),'') as fld_s3
,fld_n1
,fld_n2
,fld_n3
,fld_d1
,create_user
,replace(replace(t1.create_emp,chr(13),''),chr(10),'') as create_emp
,create_time
,update_time
,check_auth
,replace(replace(t1.e_account_code,chr(13),''),chr(10),'') as e_account_code
,replace(replace(t1.account_en_name,chr(13),''),chr(10),'') as account_en_name
,account_expired_date
,replace(replace(t1.account_postcode,chr(13),''),chr(10),'') as account_postcode
,replace(replace(t1.check_auth3,chr(13),''),chr(10),'') as check_auth3
,replace(replace(t1.check_auth4,chr(13),''),chr(10),'') as check_auth4
,e_account_enabled
,replace(replace(t1.sft_merchant_id,chr(13),''),chr(10),'') as sft_merchant_id
,replace(replace(t1.fee_code,chr(13),''),chr(10),'') as fee_code
,replace(replace(t1.fee_code2,chr(13),''),chr(10),'') as fee_code2
,replace(replace(t1.subject_account,chr(13),''),chr(10),'') as subject_account
,replace(replace(t1.unit_prop,chr(13),''),chr(10),'') as unit_prop
,replace(replace(t1.new_account_code,chr(13),''),chr(10),'') as new_account_code
,account_properties
,replace(replace(t1.new_remit_account_code,chr(13),''),chr(10),'') as new_remit_account_code
,point_payment
,points_offer

from ${iol_schema}.amss_tra_bank_account t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amss_tra_bank_account.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
