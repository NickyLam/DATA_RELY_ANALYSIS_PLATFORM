: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_margin_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_margin_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.col_acct_num as col_acct_num
,t.begin_dt as begin_dt
,t.closing_dt as closing_dt
,t.acct_bal as acct_bal
,t.margin_flow_id as margin_flow_id
,t.is_cmplt_froz_flg as is_cmplt_froz_flg
,t.margin_froz_amt as margin_froz_amt
,t.remark as remark
,t.sub_acct_id as sub_acct_id
,t.open_acct_org as open_acct_org
,t.aval_bal as aval_bal
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_margin t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_margin_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes