: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_rgst_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_col_rgst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(rgst_seq_num,chr(13),''),chr(10),'')
,replace(replace(rgst_org_name,chr(13),''),chr(10),'')
,rgst_val
,rgst_dt
,rgst_exp_dt
,replace(replace(pre_mtg_flg,chr(13),''),chr(10),'')
,pre_mtg_rgst_dt
,pre_mtg_rgst_invalid_dt
,replace(replace(operr_id,chr(13),''),chr(10),'')
,replace(replace(rgst_cert_id,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_col_rgst_info t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_rgst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
