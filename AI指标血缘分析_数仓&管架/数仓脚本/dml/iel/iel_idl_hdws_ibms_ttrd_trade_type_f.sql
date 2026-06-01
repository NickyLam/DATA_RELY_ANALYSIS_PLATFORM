: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_ttrd_trade_type_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_ttrd_trade_type.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.trd_type
,t1.description
,t1.isperiod_inst
,t1.ordernum
,t1.word_template_code
,t1.batch_word_template_code
,t1.word_template_code_trade
,t1.batch_word_template_code_trade
,t1.need_access
,t1.need_credit_risk
,t1.need_bond_access
,t1.parent_id
,t1.leaf
,t1.need_sppi_check
,t1.need_bw_list
,t1.def_transfer_type
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ibms_ttrd_trade_type t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_ttrd_trade_type.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes