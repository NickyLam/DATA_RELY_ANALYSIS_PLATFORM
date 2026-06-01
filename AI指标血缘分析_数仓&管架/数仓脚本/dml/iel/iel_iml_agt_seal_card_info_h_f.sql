: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_seal_card_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_seal_card_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t1.seal_acct_sign_flow_num,chr(13),''),chr(10),'') as seal_acct_sign_flow_num
,t1.seal_cnt as seal_cnt
,t1.start_use_dt as start_use_dt
,t1.wrtoff_dt as wrtoff_dt
,replace(replace(t1.seal_card_no,chr(13),''),chr(10),'') as seal_card_no
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.seal_card_status_cd,chr(13),''),chr(10),'') as seal_card_status_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_seal_card_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_seal_card_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes