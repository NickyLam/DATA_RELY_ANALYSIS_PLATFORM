: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3b_msg_hst_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t3b_msg_hst.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.msg_id,chr(13),''),chr(10),'') as msg_id
    ,t.stat_dt as stat_dt
    ,replace(replace(t.rpt_id,chr(13),''),chr(10),'') as rpt_id
    ,replace(replace(t.msg_type,chr(13),''),chr(10),'') as msg_type
    ,replace(replace(t.packet_id,chr(13),''),chr(10),'') as packet_id
    ,replace(replace(t.rpt_type,chr(13),''),chr(10),'') as rpt_type
    ,replace(replace(t.rpt_org_id,chr(13),''),chr(10),'') as rpt_org_id
    ,t.send_dt as send_dt
    ,replace(replace(t.send_char,chr(13),''),chr(10),'') as send_char
    ,replace(replace(t.bat_seq,chr(13),''),chr(10),'') as bat_seq
    ,replace(replace(t.msg_seq,chr(13),''),chr(10),'') as msg_seq
    ,replace(replace(t.msg_file,chr(13),''),chr(10),'') as msg_file
    ,replace(replace(t.msg_file_path,chr(13),''),chr(10),'') as msg_file_path
    ,replace(replace(t.orig_msg_file,chr(13),''),chr(10),'') as orig_msg_file
    ,replace(replace(t.orig_msg_file_path,chr(13),''),chr(10),'') as orig_msg_file_path
    ,replace(replace(t.orig_msg_id,chr(13),''),chr(10),'') as orig_msg_id
    ,replace(replace(t.atht_file,chr(13),''),chr(10),'') as atht_file
    ,replace(replace(t.atht_file_path,chr(13),''),chr(10),'') as atht_file_path
    ,replace(replace(t.msg_sts,chr(13),''),chr(10),'') as msg_sts
    ,replace(replace(t.create_tm,chr(13),''),chr(10),'') as create_tm
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.modify_tm,chr(13),''),chr(10),'') as modify_tm
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.msg_type_s,chr(13),''),chr(10),'') as msg_type_s
from iol.amls_t3b_msg_hst t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3b_msg_hst.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes