: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_tran_recvbl_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_tran_recvbl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lc_num,chr(13),''),chr(10),'') as lc_num
,fac_val_amt
,replace(replace(t1.inv_id,chr(13),''),chr(10),'') as inv_id
,inv_dt
,inv_exp_dt
,aging
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.bkrpt_clear_flg,chr(13),''),chr(10),'') as bkrpt_clear_flg
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.advise_acct_recvbl_flg,chr(13),''),chr(10),'') as advise_acct_recvbl_flg
,replace(replace(t1.cred_rht_prod_flg,chr(13),''),chr(10),'') as cred_rht_prod_flg
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,replace(replace(t1.rela_flg,chr(13),''),chr(10),'') as rela_flg
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,create_dt
,update_dt

from ${iml_schema}.ast_col_tran_recvbl_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_tran_recvbl_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
