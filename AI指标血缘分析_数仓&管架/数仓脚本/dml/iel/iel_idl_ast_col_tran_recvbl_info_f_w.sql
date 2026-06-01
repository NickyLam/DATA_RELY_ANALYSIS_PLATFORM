: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_tran_recvbl_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_tran_recvbl_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.lc_num as lc_num
,t.fac_val_amt as fac_val_amt
,t.inv_id as inv_id
,t.inv_dt as inv_dt
,t.inv_exp_dt as inv_exp_dt
,t.aging as aging
,t.payer_name as payer_name
,t.bkrpt_clear_flg as bkrpt_clear_flg
,t.payer_acct_id as payer_acct_id
,t.advise_acct_recvbl_flg as advise_acct_recvbl_flg
,t.cred_rht_prod_flg as cred_rht_prod_flg
,t.other_comnt as other_comnt
,t.rela_flg as rela_flg
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_tran_recvbl_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_tran_recvbl_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes