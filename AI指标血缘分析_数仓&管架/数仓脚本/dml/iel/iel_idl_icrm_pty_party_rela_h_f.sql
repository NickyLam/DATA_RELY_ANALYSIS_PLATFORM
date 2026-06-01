: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_pty_party_rela_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_pty_party_rela_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select party_id
,lp_id
,party_rela_type_cd
,seq_num
,rela_party_id
,valid_flg
,job_cd
,etl_dt from idl.icrm_pty_party_rela_h where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_pty_party_rela_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes