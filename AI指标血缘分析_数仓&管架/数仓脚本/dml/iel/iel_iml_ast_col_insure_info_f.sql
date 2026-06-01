: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_insure_info_f
CreateDate: 20221021
FileName:   ${iel_data_path}/ast_col_insure_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(asset_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(insure_seq_num,chr(13),''),chr(10),'')
,replace(replace(insure_pl_id,chr(13),''),chr(10),'')
,replace(replace(insu_comp_name,chr(13),''),chr(10),'')
,replace(replace(insu_comp_orgnz_cd,chr(13),''),chr(10),'')
,replace(replace(full_amt_insure_flg,chr(13),''),chr(10),'')
,insure_insud_amt
,begin_dt
,exp_dt
,check_guar_dt
,replace(replace(fst_ctfer_name,chr(13),''),chr(10),'')
,replace(replace(secd_ctfer_name,chr(13),''),chr(10),'')
,replace(replace(operr_id,chr(13),''),chr(10),'')
,replace(replace(insure_status_cd,chr(13),''),chr(10),'')
,create_dt
,update_dt
,replace(replace(src_table_name,chr(13),''),chr(10),'')

from ${iml_schema}.ast_col_insure_info t1
where 1=1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_insure_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
