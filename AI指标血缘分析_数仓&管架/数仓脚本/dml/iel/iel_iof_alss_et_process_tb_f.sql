: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_et_process_tb_f
CreateDate: 20241219
FileName:   ${iel_data_path}/alss_et_process_tb.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.form_id,chr(13),''),chr(10),'') as form_id
,replace(replace(t1.form_type,chr(13),''),chr(10),'') as form_type
,replace(replace(t1.node_no,chr(13),''),chr(10),'') as node_no
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.pre_node_no,chr(13),''),chr(10),'') as pre_node_no
,replace(replace(t1.deal_organ_no,chr(13),''),chr(10),'') as deal_organ_no
,replace(replace(t1.deal_organ_name,chr(13),''),chr(10),'') as deal_organ_name
,replace(replace(t1.deal_user_no,chr(13),''),chr(10),'') as deal_user_no
,replace(replace(t1.deal_user_name,chr(13),''),chr(10),'') as deal_user_name
,replace(replace(t1.deal_date,chr(13),''),chr(10),'') as deal_date
,replace(replace(t1.deal_description,chr(13),''),chr(10),'') as deal_description
,replace(replace(t1.deal_result_text,chr(13),''),chr(10),'') as deal_result_text
,replace(replace(t1.label_process,chr(13),''),chr(10),'') as label_process
,replace(replace(t1.process_show_level,chr(13),''),chr(10),'') as process_show_level
,replace(replace(t1.save_flag,chr(13),''),chr(10),'') as save_flag
,replace(replace(t1.deal_result_node,chr(13),''),chr(10),'') as deal_result_node
,replace(replace(t1.next_deal_no,chr(13),''),chr(10),'') as next_deal_no
,replace(replace(t1.zc,chr(13),''),chr(10),'') as zc
,replace(replace(t1.xc,chr(13),''),chr(10),'') as xc
,replace(replace(t1.yn,chr(13),''),chr(10),'') as yn
,replace(replace(t1.risk_busi_ct,chr(13),''),chr(10),'') as risk_busi_ct
,replace(replace(t1.risk_busi_tx,chr(13),''),chr(10),'') as risk_busi_tx
,replace(replace(t1.pre_lose,chr(13),''),chr(10),'') as pre_lose
,replace(replace(t1.real_lose,chr(13),''),chr(10),'') as real_lose
,replace(replace(t1.lose_reason,chr(13),''),chr(10),'') as lose_reason
,replace(replace(t1.discipline_amount,chr(13),''),chr(10),'') as discipline_amount
,replace(replace(t1.economic_amount,chr(13),''),chr(10),'') as economic_amount
,replace(replace(t1.punish_amount,chr(13),''),chr(10),'') as punish_amount
,replace(replace(t1.czy,chr(13),''),chr(10),'') as czy
,replace(replace(t1.spy,chr(13),''),chr(10),'') as spy
,replace(replace(t1.fx_flag,chr(13),''),chr(10),'') as fx_flag
,replace(replace(t1.file_name,chr(13),''),chr(10),'') as file_name
,replace(replace(t1.real_name,chr(13),''),chr(10),'') as real_name
,replace(replace(t1.file_path,chr(13),''),chr(10),'') as file_path
,replace(replace(t1.file_ext,chr(13),''),chr(10),'') as file_ext
,replace(replace(t1.back_date,chr(13),''),chr(10),'') as back_date
,replace(replace(t1.over_flag,chr(13),''),chr(10),'') as over_flag
,replace(replace(t1.next_deal_date,chr(13),''),chr(10),'') as next_deal_date
,replace(replace(t1.next_deal_user,chr(13),''),chr(10),'') as next_deal_user
,replace(replace(t1.deal_organ,chr(13),''),chr(10),'') as deal_organ
,replace(replace(t1.deal_organ_level,chr(13),''),chr(10),'') as deal_organ_level
,over_days
,replace(replace(t1.risk_source_remak,chr(13),''),chr(10),'') as risk_source_remak
,replace(replace(t1.risk_source_name,chr(13),''),chr(10),'') as risk_source_name
,replace(replace(t1.risk_source_type,chr(13),''),chr(10),'') as risk_source_type
,replace(replace(t1.risk_source_no,chr(13),''),chr(10),'') as risk_source_no
,replace(replace(t1.operateremarks,chr(13),''),chr(10),'') as operateremarks
,replace(replace(t1.channelstatus,chr(13),''),chr(10),'') as channelstatus
,replace(replace(t1.operatestatus,chr(13),''),chr(10),'') as operatestatus

from ${iol_schema}.alss_et_process_tb t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_et_process_tb.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
