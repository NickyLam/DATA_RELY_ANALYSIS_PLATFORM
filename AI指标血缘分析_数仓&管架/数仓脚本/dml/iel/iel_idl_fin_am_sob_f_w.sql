: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_fin_am_sob_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_am_sob_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.sob_id as sob_id
,t.lp_id as lp_id
,t.sob_name as sob_name
,t.sob_fname as sob_fname
,t.sob_cate_cd as sob_cate_cd
,t.curr_cd as curr_cd
,t.tepla_sob_id as tepla_sob_id
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
from ${idl_schema}.fin_am_sob t 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_sob_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes