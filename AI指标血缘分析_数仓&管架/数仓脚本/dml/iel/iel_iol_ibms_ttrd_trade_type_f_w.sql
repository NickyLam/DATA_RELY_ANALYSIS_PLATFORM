: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_trade_type_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_trade_type_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(trd_type,chr(10),''),chr(13),'') as trd_type
,replace(replace(description,chr(10),''),chr(13),'') as description
,replace(replace(isperiod_inst,chr(10),''),chr(13),'') as isperiod_inst
,replace(replace(ordernum,chr(10),''),chr(13),'') as ordernum
,replace(replace(word_template_code,chr(10),''),chr(13),'') as word_template_code
,replace(replace(batch_word_template_code,chr(10),''),chr(13),'') as batch_word_template_code
,replace(replace(word_template_code_trade,chr(10),''),chr(13),'') as word_template_code_trade
,replace(replace(batch_word_template_code_trade,chr(10),''),chr(13),'') as batch_word_template_code_trade
,replace(replace(need_access,chr(10),''),chr(13),'') as need_access
,replace(replace(need_credit_risk,chr(10),''),chr(13),'') as need_credit_risk
,replace(replace(need_bond_access,chr(10),''),chr(13),'') as need_bond_access
,replace(replace(parent_id,chr(10),''),chr(13),'') as parent_id
,replace(replace(leaf,chr(10),''),chr(13),'') as leaf
,replace(replace(need_sppi_check,chr(10),''),chr(13),'') as need_sppi_check
,replace(replace(need_bw_list,chr(10),''),chr(13),'') as need_bw_list
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_trade_type
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_trade_type_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes