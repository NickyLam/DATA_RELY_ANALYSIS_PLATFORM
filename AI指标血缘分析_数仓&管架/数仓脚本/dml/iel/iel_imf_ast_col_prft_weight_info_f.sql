: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_ast_col_prft_weight_info_f
CreateDate: 20250928
FileName:   ${iel_data_path}/ast_col_prft_weight_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prft_weight_gover_doc_id,chr(13),''),chr(10),'') as prft_weight_gover_doc_id
,replace(replace(t1.prft_weight_gover_doc_name,chr(13),''),chr(10),'') as prft_weight_gover_doc_name
,replace(replace(t1.eqty_cert_id,chr(13),''),chr(10),'') as eqty_cert_id
,replace(replace(t1.eqty_owner_name,chr(13),''),chr(10),'') as eqty_owner_name
,eqty_start_dt
,eqty_exp_dt
,replace(replace(t1.other_comnt,chr(13),''),chr(10),'') as other_comnt
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.ast_col_prft_weight_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_prft_weight_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
