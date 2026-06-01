: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_margin_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_margin.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.col_acct_num as col_acct_num
,t1.begin_dt as begin_dt
,t1.closing_dt as closing_dt
,t1.acct_bal as acct_bal
,t1.margin_flow_id as margin_flow_id
,t1.is_cmplt_froz_flg as is_cmplt_froz_flg
,t1.margin_froz_amt as margin_froz_amt
,t1.remark as remark
,t1.sub_acct_id as sub_acct_id
,t1.open_acct_org as open_acct_org
,t1.aval_bal as aval_bal
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_margin t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_margin.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
