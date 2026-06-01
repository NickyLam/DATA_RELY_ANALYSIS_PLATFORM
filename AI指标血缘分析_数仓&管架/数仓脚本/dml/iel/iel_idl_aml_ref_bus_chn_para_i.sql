: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_ref_bus_chn_para_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_ref_bus_chn_para.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select chn_cd
,chn_attr_group_id
,chn_name
,create_dt
,update_dt
,etl_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_ref_bus_chn_para where create_dt<=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_ref_bus_chn_para.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes