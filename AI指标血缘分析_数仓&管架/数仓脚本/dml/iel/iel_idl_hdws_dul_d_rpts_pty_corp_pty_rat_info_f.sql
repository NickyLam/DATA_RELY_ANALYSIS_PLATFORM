: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_pty_corp_pty_rat_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_rat_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
pty_id
,etl_dt
,crdt_rat_typ_cd
,crdt_rat_org_num
,crdt_rat_org_name
,crdt_rat_resu_cd
,crdt_score_val
,crdt_rat_dt
,crdt_rat_valid_dt
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_pty_corp_pty_rat_info 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_pty_corp_pty_rat_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes