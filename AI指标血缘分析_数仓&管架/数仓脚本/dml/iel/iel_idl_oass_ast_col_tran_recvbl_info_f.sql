: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_tran_recvbl_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_tran_recvbl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.lc_num as lc_num
,t1.fac_val_amt as fac_val_amt
,t1.inv_id as inv_id
,t1.inv_dt as inv_dt
,t1.inv_exp_dt as inv_exp_dt
,t1.aging as aging
,t1.payer_name as payer_name
,t1.bkrpt_clear_flg as bkrpt_clear_flg
,t1.payer_acct_id as payer_acct_id
,t1.advise_acct_recvbl_flg as advise_acct_recvbl_flg
,t1.cred_rht_prod_flg as cred_rht_prod_flg
,t1.other_comnt as other_comnt
,t1.rela_flg as rela_flg
,t1.curr_cd as curr_cd
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark
,t1.asset_id as asset_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_ast_col_tran_recvbl_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_tran_recvbl_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
