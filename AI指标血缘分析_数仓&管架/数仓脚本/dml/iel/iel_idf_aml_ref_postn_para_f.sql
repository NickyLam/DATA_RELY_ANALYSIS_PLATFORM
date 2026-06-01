: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_ref_postn_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_postn_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select post_id
,org_id
,post_name
,base_post_flg
,strip_line_id
,order_id
,type_cd
,status_cd
,create_dt
,update_dt
,etl_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_ref_postn_para where create_dt <=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_postn_para.f.${batch_date}.dat" \
        charset=utf8
        safe=yes