: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_pty_party_cert_info_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_pty_party_cert_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select party_id
,lp_id
,sorc_sys_cd
,cert_type_cd
,start_dt
,cert_num
,cert_addr
,issue_cert_org
,issue_cert_org_cty_cd
,cert_effect_dt
,cert_invalid_dt
,licen_issue_autho_dist_cd
,crdt_cd_cert_id
,cert_valid_flg
,cert_status_cd
,main_cert_no_flg
,end_dt
,id_mark
,src_table_name
,job_cd
,etl_timestamp from idl.aml_pty_party_cert_info_h where start_dt<=to_date('${batch_date}','yyyymmdd') and end_dt>to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_pty_party_cert_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes