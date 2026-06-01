: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_wft_end_day_clarify_flow_i
CreateDate: 20231226
FileName:   ${iel_data_path}/evt_wft_end_day_clarify_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,clarify_dt
,replace(replace(t1.clarify_flow_num,chr(13),''),chr(10),'') as clarify_flow_num
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,clarify_amt
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.return_flow_num,chr(13),''),chr(10),'') as return_flow_num
,replace(replace(t1.return_sucs_flg,chr(13),''),chr(10),'') as return_sucs_flg
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info

from ${iml_schema}.evt_wft_end_day_clarify_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wft_end_day_clarify_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
