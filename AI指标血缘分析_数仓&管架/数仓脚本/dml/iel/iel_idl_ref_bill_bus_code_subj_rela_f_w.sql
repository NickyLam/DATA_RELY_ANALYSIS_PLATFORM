: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ref_bill_bus_code_subj_rela_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_bill_bus_code_subj_rela_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.subj_id
,t.subj_name
,case when trim(t.bus_code) is null then '-' else t.bus_code end
,t.amt_type_cd
,t.create_dt
,t.update_dt
,t.id_mark
from ${idl_schema}.ref_bill_bus_code_subj_rela t
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_bill_bus_code_subj_rela_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes