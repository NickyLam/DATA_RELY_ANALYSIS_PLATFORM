: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_albs_bps_dat_par_channel_f
CreateDate: 20230804
FileName:   ${iel_data_path}/albs_bps_dat_par_channel.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.own_org,chr(13),''),chr(10),'') as own_org
,replace(replace(t1.list_kind,chr(13),''),chr(10),'') as list_kind
,replace(replace(t1.chnl_code,chr(13),''),chr(10),'') as chnl_code
,replace(replace(t1.chnl_name,chr(13),''),chr(10),'') as chnl_name
,replace(replace(t1.file_charset,chr(13),''),chr(10),'') as file_charset
,replace(replace(t1.file_type_code,chr(13),''),chr(10),'') as file_type_code
,replace(replace(t1.imp_bean,chr(13),''),chr(10),'') as imp_bean
,replace(replace(t1.user_remark,chr(13),''),chr(10),'') as user_remark
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.sys_def_flag,chr(13),''),chr(10),'') as sys_def_flag
,replace(replace(t1.oper_type,chr(13),''),chr(10),'') as oper_type
,replace(replace(t1.edit_status,chr(13),''),chr(10),'') as edit_status
,replace(replace(t1.data_enable,chr(13),''),chr(10),'') as data_enable
,replace(replace(t1.crt_datetime,chr(13),''),chr(10),'') as crt_datetime
,replace(replace(t1.crt_user_id,chr(13),''),chr(10),'') as crt_user_id
,replace(replace(t1.crt_branch_id,chr(13),''),chr(10),'') as crt_branch_id
,replace(replace(t1.last_datetime,chr(13),''),chr(10),'') as last_datetime
,replace(replace(t1.last_user_id,chr(13),''),chr(10),'') as last_user_id
,replace(replace(t1.last_branch_id,chr(13),''),chr(10),'') as last_branch_id
,replace(replace(t1.last_txn,chr(13),''),chr(10),'') as last_txn
,replace(replace(t1.crt_user_code,chr(13),''),chr(10),'') as crt_user_code
,replace(replace(t1.crt_branch_code,chr(13),''),chr(10),'') as crt_branch_code
,replace(replace(t1.last_user_code,chr(13),''),chr(10),'') as last_user_code
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.deal_opinion,chr(13),''),chr(10),'') as deal_opinion
,replace(replace(t1.chnl_src,chr(13),''),chr(10),'') as chnl_src
,replace(replace(t1.chnl_provider,chr(13),''),chr(10),'') as chnl_provider
,replace(replace(t1.chnl_manager,chr(13),''),chr(10),'') as chnl_manager
,replace(replace(t1.chnl_maintain,chr(13),''),chr(10),'') as chnl_maintain
,replace(replace(t1.chnl_update_time,chr(13),''),chr(10),'') as chnl_update_time
,replace(replace(t1.chnl_desc,chr(13),''),chr(10),'') as chnl_desc
,replace(replace(t1.file_path,chr(13),''),chr(10),'') as file_path

from ${iol_schema}.albs_bps_dat_par_channel t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/albs_bps_dat_par_channel.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
