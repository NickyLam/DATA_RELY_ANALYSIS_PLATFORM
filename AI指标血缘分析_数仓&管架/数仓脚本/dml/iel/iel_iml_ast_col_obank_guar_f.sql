: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ast_col_obank_guar_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ast_col_obank_guar.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.asset_id,chr(13),''),chr(10),'') as asset_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,hxb_prior_seq_comb_cd
,replace(replace(t1.obank_name,chr(13),''),chr(10),'') as obank_name
,obank_set_sec_right_amt

from ${iml_schema}.ast_col_obank_guar t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ast_col_obank_guar.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
