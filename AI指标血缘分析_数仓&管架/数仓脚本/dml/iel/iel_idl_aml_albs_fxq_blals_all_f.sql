: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_albs_fxq_blals_all_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_albs_fxq_blals_all.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,black_id
,original_id
,bla_type
,bla_type_detail
,gender
,is_china_limit
,bla_name
,bla_identity
,source_desc
,source_program
,active_date
,input_type
,id
,blacklist_type
from idl.aml_albs_fxq_blals_all
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_albs_fxq_blals_all.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes