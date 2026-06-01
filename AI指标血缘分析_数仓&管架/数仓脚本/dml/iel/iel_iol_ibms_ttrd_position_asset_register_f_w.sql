: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_position_asset_register_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_position_asset_register_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(id,chr(10),''),chr(13),'') as id
,replace(replace(p_type,chr(10),''),chr(13),'') as p_type
,replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,replace(replace(effective_date,chr(10),''),chr(13),'') as effective_date
,replace(replace(ftp_rate,chr(10),''),chr(13),'') as ftp_rate
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(start_date,chr(10),''),chr(13),'') as start_date
,replace(replace(mtr_date,chr(10),''),chr(13),'') as mtr_date
,replace(replace(register_type,chr(10),''),chr(13),'') as register_type
,replace(replace(project,chr(10),''),chr(13),'') as project
,replace(replace(risk_weight,chr(10),''),chr(13),'') as risk_weight
,replace(replace(risk_assets_amount,chr(10),''),chr(13),'') as risk_assets_amount
,replace(replace(register_date,chr(10),''),chr(13),'') as register_date
,replace(replace(market_inst,chr(10),''),chr(13),'') as market_inst
,replace(replace(customer_manager,chr(10),''),chr(13),'') as customer_manager
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(obj_id,chr(10),''),chr(13),'') as obj_id
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,etl_dt
,etl_timestamp
from iol.ibms_ttrd_position_asset_register 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_position_asset_register_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes