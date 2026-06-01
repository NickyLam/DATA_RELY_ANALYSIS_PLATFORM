: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_ref_pub_cd_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_pub_cd.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select cd_id
,cd_tab_en_name
,cd_tab_cn_descb
,cd_val
,cd_descb
,data_std_flg
,quote_data_std
,remark
,etl_dt
,src_table_name
,job_cd
,etl_timestamp from idl.aml_ref_pub_cd;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_pub_cd.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes