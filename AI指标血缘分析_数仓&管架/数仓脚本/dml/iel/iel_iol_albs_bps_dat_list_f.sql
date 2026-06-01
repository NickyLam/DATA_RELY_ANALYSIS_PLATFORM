: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_albs_bps_dat_list_f
CreateDate: 20230804
FileName:   ${iel_data_path}/albs_bps_dat_list.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.id,chr(13),''),chr(10),'') as id
,replace(replace(t1.own_org,chr(13),''),chr(10),'') as own_org
,replace(replace(t1.list_kind,chr(13),''),chr(10),'') as list_kind
,replace(replace(t1.chnl_id,chr(13),''),chr(10),'') as chnl_id
,replace(replace(t1.list_ori_id,chr(13),''),chr(10),'') as list_ori_id
,replace(replace(t1.list_version,chr(13),''),chr(10),'') as list_version
,replace(replace(t1.list_type,chr(13),''),chr(10),'') as list_type
,replace(replace(t1.active_flag,chr(13),''),chr(10),'') as active_flag
,replace(replace(t1.active_date,chr(13),''),chr(10),'') as active_date
,replace(replace(t1.expiry_date,chr(13),''),chr(10),'') as expiry_date
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.deceased,chr(13),''),chr(10),'') as deceased
,replace(replace(t1.list_crt_date,chr(13),''),chr(10),'') as list_crt_date
,replace(replace(t1.list_update_date,chr(13),''),chr(10),'') as list_update_date
,replace(replace(t1.ref_codes,chr(13),''),chr(10),'') as ref_codes
,replace(replace(t1.desc_codes,chr(13),''),chr(10),'') as desc_codes
,replace(replace(t1.desc_icons,chr(13),''),chr(10),'') as desc_icons
,replace(replace(t1.risk_level,chr(13),''),chr(10),'') as risk_level
,replace(replace(t1.is_china_list,chr(13),''),chr(10),'') as is_china_list
,replace(replace(t1.sys_remark,chr(13),''),chr(10),'') as sys_remark
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.oper_type,chr(13),''),chr(10),'') as oper_type
,replace(replace(t1.data_enable,chr(13),''),chr(10),'') as data_enable
,replace(replace(t1.crt_date,chr(13),''),chr(10),'') as crt_date
,replace(replace(t1.crt_datetime,chr(13),''),chr(10),'') as crt_datetime
,replace(replace(t1.crt_user_id,chr(13),''),chr(10),'') as crt_user_id
,replace(replace(t1.crt_branch_id,chr(13),''),chr(10),'') as crt_branch_id
,replace(replace(t1.last_date,chr(13),''),chr(10),'') as last_date
,replace(replace(t1.last_datetime,chr(13),''),chr(10),'') as last_datetime
,replace(replace(t1.last_user_id,chr(13),''),chr(10),'') as last_user_id
,replace(replace(t1.last_branch_id,chr(13),''),chr(10),'') as last_branch_id
,replace(replace(t1.last_txn,chr(13),''),chr(10),'') as last_txn
,replace(replace(t1.action_type,chr(13),''),chr(10),'') as action_type
,replace(replace(t1.edit_status,chr(13),''),chr(10),'') as edit_status
,replace(replace(t1.log_id,chr(13),''),chr(10),'') as log_id
,replace(replace(t1.crt_user_code,chr(13),''),chr(10),'') as crt_user_code
,replace(replace(t1.crt_branch_code,chr(13),''),chr(10),'') as crt_branch_code
,replace(replace(t1.last_user_code,chr(13),''),chr(10),'') as last_user_code
,replace(replace(t1.file_seq,chr(13),''),chr(10),'') as file_seq

from ${iol_schema}.albs_bps_dat_list t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/albs_bps_dat_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
