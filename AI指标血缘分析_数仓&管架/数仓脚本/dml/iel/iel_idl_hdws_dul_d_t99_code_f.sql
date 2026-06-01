: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_t99_code_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_t99_code.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
cd_id
,cd_cn_name
,cd_en_name
,cd_val
,cd_desc
,memo
from ${idl_schema}.hdws_iml_t99_code ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_t99_code.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes