: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_imps_ads_task_detail_di_out_a
CreateDate: 20241220
FileName:   ${iel_data_path}/imps_ads_task_detail_di_out.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,base_id
,replace(replace(t1.main_account_id,chr(13),''),chr(10),'') as main_account_id
,replace(replace(t1.app_id,chr(13),''),chr(10),'') as app_id
,replace(replace(t1.subject_id,chr(13),''),chr(10),'') as subject_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,replace(replace(t1.schedule_id,chr(13),''),chr(10),'') as schedule_id
,replace(replace(t1.sub_task_id,chr(13),''),chr(10),'') as sub_task_id
,replace(replace(t1.current_id_type,chr(13),''),chr(10),'') as current_id_type
,replace(replace(t1.current_id,chr(13),''),chr(10),'') as current_id
,replace(replace(t1.current_version_index,chr(13),''),chr(10),'') as current_version_index
,replace(replace(t1.send_id,chr(13),''),chr(10),'') as send_id
,replace(replace(t1.send_id_type,chr(13),''),chr(10),'') as send_id_type
,replace(replace(t1.coupon_uuid,chr(13),''),chr(10),'') as coupon_uuid
,replace(replace(t1.message,chr(13),''),chr(10),'') as message
,replace(replace(t1.channel_type,chr(13),''),chr(10),'') as channel_type
,replace(replace(t1.channel_id,chr(13),''),chr(10),'') as channel_id
,click_flag
,click_time
,arrive_flag
,arrive_time
,trigger_success_flag
,trigger_time
,is_probe_data
,replace(replace(t1.app_name,chr(13),''),chr(10),'') as app_name
,\"mode\"
,replace(replace(t1.task_name,chr(13),''),chr(10),'') as task_name
,campaign_id
,replace(replace(t1.campaign_name,chr(13),''),chr(10),'') as campaign_name
,group_id
,replace(replace(t1.group_name,chr(13),''),chr(10),'') as group_name
,campaign_group_id
,replace(replace(t1.campaign_group_name,chr(13),''),chr(10),'') as campaign_group_name
,cohort_id
,replace(replace(t1.crowd_name,chr(13),''),chr(10),'') as crowd_name
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.channel_name,chr(13),''),chr(10),'') as channel_name
,replace(replace(t1.sub_task_name,chr(13),''),chr(10),'') as sub_task_name
,replace(replace(t1.coupon_id,chr(13),''),chr(10),'') as coupon_id
,replace(replace(t1.coupon_name,chr(13),''),chr(10),'') as coupon_name
,start_time
,end_time
,window_popup_flag
,window_popup_time
,market_plan_id
,replace(replace(t1.finish_a_events,chr(13),''),chr(10),'') as finish_a_events
,replace(replace(t1.unfinish_b_events,chr(13),''),chr(10),'') as unfinish_b_events
,replace(replace(t1.short_links_info,chr(13),''),chr(10),'') as short_links_info
,replace(replace(t1.magic_links_info,chr(13),''),chr(10),'') as magic_links_info
,p_date
,replace(replace(t1.task_type,chr(13),''),chr(10),'') as task_type
,seq_id
,replace(replace(t1.tunnel_type,chr(13),''),chr(10),'') as tunnel_type
,replace(replace(t1.ecif_id,chr(13),''),chr(10),'') as ecif_id
,replace(replace(t1.content,chr(13),''),chr(10),'') as content

from ${iol_schema}.imps_ads_task_detail_di_out t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/imps_ads_task_detail_di_out.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
