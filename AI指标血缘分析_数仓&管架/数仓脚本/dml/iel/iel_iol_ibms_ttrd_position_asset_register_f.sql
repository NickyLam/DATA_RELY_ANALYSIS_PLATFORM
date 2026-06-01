: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_position_asset_register_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ibms_ttrd_position_asset_register.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,replace(replace(p_type,chr(13),''),chr(10),'')
,replace(replace(i_code,chr(13),''),chr(10),'')
,replace(replace(i_name,chr(13),''),chr(10),'')
,replace(replace(effective_date,chr(13),''),chr(10),'')
,ftp_rate
,replace(replace(remark,chr(13),''),chr(10),'')
,replace(replace(start_date,chr(13),''),chr(10),'')
,replace(replace(mtr_date,chr(13),''),chr(10),'')
,replace(replace(register_type,chr(13),''),chr(10),'')
,replace(replace(project,chr(13),''),chr(10),'')
,replace(replace(risk_weight,chr(13),''),chr(10),'')
,risk_assets_amount
,replace(replace(register_date,chr(13),''),chr(10),'')
,replace(replace(market_inst,chr(13),''),chr(10),'')
,replace(replace(customer_manager,chr(13),''),chr(10),'')
,replace(replace(a_type,chr(13),''),chr(10),'')
,replace(replace(m_type,chr(13),''),chr(10),'')
,replace(replace(obj_id,chr(13),''),chr(10),'')
,amount
,replace(replace(field1,chr(13),''),chr(10),'')
,replace(replace(field2,chr(13),''),chr(10),'')
,replace(replace(check_user,chr(13),''),chr(10),'')
,usable_flag
,replace(replace(update_user,chr(13),''),chr(10),'')
,replace(replace(secu_acct_id,chr(13),''),chr(10),'')
,provision_accrual_prop
,ensure_amt
,deposit_receipt_amt
,wealth_treasure_amt
,government_bond_amt
,policy_bank_amt
,common_department_amt
,other_amt

from ${iol_schema}.ibms_ttrd_position_asset_register t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_position_asset_register.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
