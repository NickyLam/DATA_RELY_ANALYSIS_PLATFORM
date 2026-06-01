: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_ref_curr_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_curr_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select curr_cd
,curr_name
,curr_en_abbr
,curr_sign_cd
,start_use_flg
,create_dt
,update_dt
,etl_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_ref_curr_para where create_dt<=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_curr_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes