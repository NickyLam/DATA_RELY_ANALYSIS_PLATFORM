: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifcs_dep_acct_info_f
CreateDate: 20231024
FileName:   ${iel_data_path}/ifcs_dep_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,replace(replace(t1.open_acct_dt,chr(13),''),chr(10),'') as open_acct_dt
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.froz_status,chr(13),''),chr(10),'') as froz_status
,replace(replace(t1.stpay_status_cd,chr(13),''),chr(10),'') as stpay_status_cd
,replace(replace(t1.acpt_pay_status,chr(13),''),chr(10),'') as acpt_pay_status
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t1.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg
,replace(replace(t1.acct_usage_cd,chr(13),''),chr(10),'') as acct_usage_cd
,replace(replace(t1.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,replace(replace(t1.acct_kind_cd,chr(13),''),chr(10),'') as acct_kind_cd
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.close_acct_dt,chr(13),''),chr(10),'') as close_acct_dt
,replace(replace(t1.close_acct_ti,chr(13),''),chr(10),'') as close_acct_ti
,replace(replace(t1.close_acct_flow_num,chr(13),''),chr(10),'') as close_acct_flow_num
,replace(replace(t1.last_sub_id,chr(13),''),chr(10),'') as last_sub_id
,replace(replace(t1.bind_acct_id,chr(13),''),chr(10),'') as bind_acct_id
,replace(replace(t1.last_activ_acct_dt,chr(13),''),chr(10),'') as last_activ_acct_dt
,replace(replace(t1.open_acct_tm,chr(13),''),chr(10),'') as open_acct_tm
,replace(replace(t1.part_id,chr(13),''),chr(10),'') as part_id
,replace(replace(t1.base_val,chr(13),''),chr(10),'') as base_val
,replace(replace(t1.sync_status_cd,chr(13),''),chr(10),'') as sync_status_cd
,replace(replace(t1.accept_status,chr(13),''),chr(10),'') as accept_status
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd

from ${iol_schema}.ifcs_dep_acct_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifcs_dep_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
