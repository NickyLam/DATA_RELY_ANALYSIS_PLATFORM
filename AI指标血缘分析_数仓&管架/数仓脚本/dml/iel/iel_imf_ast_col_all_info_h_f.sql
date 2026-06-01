: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_all_info_h_f
CreateDate: 20251010
FileName:   ${iel_data_path}/ast_col_all_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.all_cust_id,chr(13),''),chr(10),'') as all_cust_id
,replace(replace(t1.all_cust_name,chr(13),''),chr(10),'') as all_cust_name
,replace(replace(t1.col_all_type_cd,chr(13),''),chr(10),'') as col_all_type_cd
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.pmo_obg_brwer_rela_cd,chr(13),''),chr(10),'') as pmo_obg_brwer_rela_cd
,replace(replace(t1.col_belong_ps_trdpty_flg,chr(13),''),chr(10),'') as col_belong_ps_trdpty_flg

from ${iml_schema}.ast_col_all_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_all_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
