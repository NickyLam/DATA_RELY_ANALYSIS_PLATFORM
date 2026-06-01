: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_ast_col_recvbl_rent_info_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_ast_col_recvbl_rent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.rent_cnt as rent_cnt
,t1.rent_type_cd as rent_type_cd
,t1.everytime_fix_rent_amt as everytime_fix_rent_amt
,t1.float_rent_amt_comnt as float_rent_amt_comnt
,t1.lease_effect_dt as lease_effect_dt
,t1.lease_invalid_dt as lease_invalid_dt
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

from ${idl_schema}.oass_ast_col_recvbl_rent_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_ast_col_recvbl_rent_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
