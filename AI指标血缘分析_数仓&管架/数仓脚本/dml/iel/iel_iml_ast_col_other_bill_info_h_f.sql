: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_other_bill_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ast_col_other_bill_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd
,replace(replace(t1.drawer_type_cd,chr(13),''),chr(10),'') as drawer_type_cd
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_acct_id,chr(13),''),chr(10),'') as drawer_acct_id
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_type_cd,chr(13),''),chr(10),'') as accptor_type_cd
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_type_cd,chr(13),''),chr(10),'') as recver_type_cd
,replace(replace(t1.bill_rher_flg,chr(13),''),chr(10),'') as bill_rher_flg
,replace(replace(t1.bill_rher_name,chr(13),''),chr(10),'') as bill_rher_name
,replace(replace(t1.bill_rher_type_cd,chr(13),''),chr(10),'') as bill_rher_type_cd
,fac_val_amt
,bill_issue_dt
,bill_exp_dt
,replace(replace(t1.drawer_local_cty_or_rg_cd,chr(13),''),chr(10),'') as drawer_local_cty_or_rg_cd
,replace(replace(t1.drawer_ext_rating_rest_cd,chr(13),''),chr(10),'') as drawer_ext_rating_rest_cd
,replace(replace(t1.accptor_local_cty_or_rg_cd,chr(13),''),chr(10),'') as accptor_local_cty_or_rg_cd
,replace(replace(t1.accptor_ext_rating_rest_cd,chr(13),''),chr(10),'') as accptor_ext_rating_rest_cd
,replace(replace(t1.bank_ensure_discount_flg,chr(13),''),chr(10),'') as bank_ensure_discount_flg
,replace(replace(t1.bank_ensure_discount_name,chr(13),''),chr(10),'') as bank_ensure_discount_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd

from ${iml_schema}.ast_col_other_bill_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_other_bill_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
