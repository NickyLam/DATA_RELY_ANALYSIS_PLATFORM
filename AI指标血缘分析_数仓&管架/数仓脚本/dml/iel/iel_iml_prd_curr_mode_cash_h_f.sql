: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_prd_curr_mode_cash_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/prd_curr_mode_cash_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,t.cash_dt as cash_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.intfc_proc_flg,chr(13),''),chr(10),'') as intfc_proc_flg
    ,t.proc_dt as proc_dt
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.prd_curr_mode_cash_h t 
 where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/prd_curr_mode_cash_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes