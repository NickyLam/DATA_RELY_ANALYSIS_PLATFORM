: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbhismonitor_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbhismonitor.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.log_serial,chr(13),''),chr(10),'') as log_serial
,replace(replace(t1.serial_no,chr(13),''),chr(10),'') as serial_no
,replace(replace(t1.ex_serial,chr(13),''),chr(10),'') as ex_serial
,t1.trans_date as trans_date
,t1.trans_time as trans_time
,replace(replace(t1.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t1.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t1.term_no,chr(13),''),chr(10),'') as term_no
,replace(replace(t1.oper_no,chr(13),''),chr(10),'') as oper_no
,replace(replace(t1.auth_oper,chr(13),''),chr(10),'') as auth_oper
,replace(replace(t1.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t1.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t1.bank_acc,chr(13),''),chr(10),'') as bank_acc
,replace(replace(t1.trans_account,chr(13),''),chr(10),'') as trans_account
,replace(replace(t1.trans_account_type,chr(13),''),chr(10),'') as trans_account_type
,replace(replace(t1.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t1.trans_name,chr(13),''),chr(10),'') as trans_name
,replace(replace(t1.ta_code,chr(13),''),chr(10),'') as ta_code
,replace(replace(t1.asset_acc,chr(13),''),chr(10),'') as asset_acc
,replace(replace(t1.prd_code,chr(13),''),chr(10),'') as prd_code
,t1.amt as amt
,t1.vol as vol
,replace(replace(t1.err_code,chr(13),''),chr(10),'') as err_code
,replace(replace(t1.err_msg,chr(13),''),chr(10),'') as err_msg
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.deal_mode,chr(13),''),chr(10),'') as deal_mode
,replace(replace(t1.trans_type,chr(13),''),chr(10),'') as trans_type
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
from ${iol_schema}.ifms_tbhismonitor t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbhismonitor.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes