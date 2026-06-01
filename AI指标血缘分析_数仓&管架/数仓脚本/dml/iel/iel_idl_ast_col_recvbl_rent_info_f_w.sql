: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ast_col_recvbl_rent_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_recvbl_rent_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.asset_id as asset_id
,t.lp_id as lp_id
,t.rent_cnt as rent_cnt
,t.rent_type_cd as rent_type_cd
,t.everytime_fix_rent_amt as everytime_fix_rent_amt
,t.float_rent_amt_comnt as float_rent_amt_comnt
,t.lease_effect_dt as lease_effect_dt
,t.lease_invalid_dt as lease_invalid_dt
,t.advise_acct_recvbl_flg as advise_acct_recvbl_flg
,t.cred_rht_prod_flg as cred_rht_prod_flg
,t.other_comnt as other_comnt
,t.rela_flg as rela_flg
,t.curr_cd as curr_cd
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.ast_col_recvbl_rent_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_recvbl_rent_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes