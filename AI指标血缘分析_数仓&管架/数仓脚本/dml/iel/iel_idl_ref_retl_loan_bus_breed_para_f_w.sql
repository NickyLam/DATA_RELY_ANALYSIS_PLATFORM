: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ref_retl_loan_bus_breed_para_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_retl_loan_bus_breed_para_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.bus_breed_cd
,t.bus_breed_name
,t.asset_thd_cls_cd
,t.comp_flg
,t.loan_bus_kind_cd
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.ref_retl_loan_bus_breed_para t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_retl_loan_bus_breed_para_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes