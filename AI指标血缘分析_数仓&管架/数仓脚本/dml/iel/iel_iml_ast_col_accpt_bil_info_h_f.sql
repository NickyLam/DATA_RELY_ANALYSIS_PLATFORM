: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_accpt_bil_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ast_col_accpt_bil_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_orgnz_cd,chr(13),''),chr(10),'') as drawer_orgnz_cd
,replace(replace(t1.drawer_type_cd,chr(13),''),chr(10),'') as drawer_type_cd
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_type_cd,chr(13),''),chr(10),'') as accptor_type_cd
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_type_cd,chr(13),''),chr(10),'') as recver_type_cd
,replace(replace(t1.bill_rher_flg,chr(13),''),chr(10),'') as bill_rher_flg
,replace(replace(t1.bill_rher_name,chr(13),''),chr(10),'') as bill_rher_name
,replace(replace(t1.bill_rher_type_cd,chr(13),''),chr(10),'') as bill_rher_type_cd
,t1.fac_val_amt as fac_val_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.bill_issue_dt as bill_issue_dt
,t1.bill_exp_dt as bill_exp_dt
,replace(replace(t1.drawer_cty_or_rg_cd,chr(13),''),chr(10),'') as drawer_cty_or_rg_cd
,replace(replace(t1.accptor_cty_or_rg_cd,chr(13),''),chr(10),'') as accptor_cty_or_rg_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.ast_col_accpt_bil_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_accpt_bil_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes