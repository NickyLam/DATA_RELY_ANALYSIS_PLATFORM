: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_pty_party_rela_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_pty_party_rela_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select party_id
,lp_id
,party_rela_type_cd
,seq_num
,start_dt
,rela_party_id
,valid_flg
,end_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_pty_party_rela_h where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_pty_party_rela_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes