: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_bond_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_bond_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.col_id,chr(13),''),chr(10),'') as col_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bond_id,chr(13),''),chr(10),'') as bond_id
,replace(replace(t1.bond_name,chr(13),''),chr(10),'') as bond_name
,bond_qtty
,replace(replace(t1.bond_have_ext_bond_item_rating_flg,chr(13),''),chr(10),'') as bond_have_ext_bond_item_rating_flg
,replace(replace(t1.bond_ext_rating_cd,chr(13),''),chr(10),'') as bond_ext_rating_cd
,fac_val_amt
,fac_val_nv
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,int_rat
,issue_dt
,exp_dt
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt

from ${iml_schema}.ast_col_bond_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_bond_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
