: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_alss_am_ledger_record_f
CreateDate: 20250828
FileName:   ${iel_data_path}/alss_am_ledger_record.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.input_date,chr(13),''),chr(10),'') as input_date
,replace(replace(t1.data_release_id,chr(13),''),chr(10),'') as data_release_id
,replace(replace(t1.deal_status,chr(13),''),chr(10),'') as deal_status
,replace(replace(t1.add_organ_no,chr(13),''),chr(10),'') as add_organ_no
,replace(replace(t1.add_user,chr(13),''),chr(10),'') as add_user
,replace(replace(t1.add_date,chr(13),''),chr(10),'') as add_date
,replace(replace(t1.check_data,chr(13),''),chr(10),'') as check_data
,replace(replace(t1.check_user,chr(13),''),chr(10),'') as check_user
,replace(replace(t1.record_data_state,chr(13),''),chr(10),'') as record_data_state
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.is_deal,chr(13),''),chr(10),'') as is_deal
,replace(replace(t1.is_accountability,chr(13),''),chr(10),'') as is_accountability
,replace(replace(t1.l_r_id,chr(13),''),chr(10),'') as l_r_id
,replace(replace(t1.is_reduction,chr(13),''),chr(10),'') as is_reduction
,replace(replace(t1.acct_status,chr(13),''),chr(10),'') as acct_status
,replace(replace(t1.open_date,chr(13),''),chr(10),'') as open_date
,replace(replace(t1.open_organ,chr(13),''),chr(10),'') as open_organ
,replace(replace(t1.source_type,chr(13),''),chr(10),'') as source_type
,replace(replace(t1.acc_name,chr(13),''),chr(10),'') as acc_name
,replace(replace(t1.acc_no,chr(13),''),chr(10),'') as acc_no
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num
,replace(replace(t1.cert_type,chr(13),''),chr(10),'') as cert_type
,replace(replace(t1.cus_no,chr(13),''),chr(10),'') as cus_no
,replace(replace(t1.cus_type,chr(13),''),chr(10),'') as cus_type

from ${iol_schema}.alss_am_ledger_record t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/alss_am_ledger_record.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
