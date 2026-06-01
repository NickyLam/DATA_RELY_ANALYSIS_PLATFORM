: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ref_curr_para_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_curr_para_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.curr_cd
,t.curr_name
,t.curr_en_abbr
,t.curr_sign_cd
,t.start_use_flg
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.ref_curr_para t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_curr_para_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes