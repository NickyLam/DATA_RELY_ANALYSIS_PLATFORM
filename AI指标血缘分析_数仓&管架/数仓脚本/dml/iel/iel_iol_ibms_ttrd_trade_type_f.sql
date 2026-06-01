: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_trade_type_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_trade_type.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trd_type,chr(13),''),chr(10),'') as trd_type
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.isperiod_inst,chr(13),''),chr(10),'') as isperiod_inst
,t1.ordernum as ordernum
,replace(replace(t1.word_template_code,chr(13),''),chr(10),'') as word_template_code
,replace(replace(t1.batch_word_template_code,chr(13),''),chr(10),'') as batch_word_template_code
,replace(replace(t1.word_template_code_trade,chr(13),''),chr(10),'') as word_template_code_trade
,replace(replace(t1.batch_word_template_code_trade,chr(13),''),chr(10),'') as batch_word_template_code_trade
,t1.need_access as need_access
,t1.need_credit_risk as need_credit_risk
,replace(replace(t1.need_bond_access,chr(13),''),chr(10),'') as need_bond_access
,replace(replace(t1.parent_id,chr(13),''),chr(10),'') as parent_id
,t1.leaf as leaf
,replace(replace(t1.need_sppi_check,chr(13),''),chr(10),'') as need_sppi_check
,replace(replace(t1.need_bw_list,chr(13),''),chr(10),'') as need_bw_list
,t1.def_transfer_type as def_transfer_type

from ${iol_schema}.ibms_ttrd_trade_type t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_trade_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
