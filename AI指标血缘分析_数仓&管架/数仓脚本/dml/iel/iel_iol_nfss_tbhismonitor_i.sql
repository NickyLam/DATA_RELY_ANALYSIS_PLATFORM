: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_nfss_tbhismonitor_i
CreateDate: 20180529
FileName:   ${iel_data_path}/nfss_tbhismonitor.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
      ,replace(replace(log_serial,chr(13),''),chr(10),'') as log_serial
      ,replace(replace(serial_no,chr(13),''),chr(10),'') as serial_no
      ,replace(replace(ex_serial,chr(13),''),chr(10),'') as ex_serial
      ,trans_date
      ,trans_time
      ,replace(replace(channel,chr(13),''),chr(10),'') as channel
      ,replace(replace(branch_no,chr(13),''),chr(10),'') as branch_no
      ,replace(replace(term_no,chr(13),''),chr(10),'') as term_no
      ,replace(replace(oper_no,chr(13),''),chr(10),'') as oper_no
      ,replace(replace(auth_oper,chr(13),''),chr(10),'') as auth_oper
      ,replace(replace(in_client_no,chr(13),''),chr(10),'') as in_client_no
      ,replace(replace(bank_no,chr(13),''),chr(10),'') as bank_no
      ,replace(replace(client_no,chr(13),''),chr(10),'') as client_no
      ,replace(replace(bank_acc,chr(13),''),chr(10),'') as bank_acc
      ,replace(replace(trans_account,chr(13),''),chr(10),'') as trans_account
      ,replace(replace(trans_account_type,chr(13),''),chr(10),'') as trans_account_type
      ,replace(replace(trans_code,chr(13),''),chr(10),'') as trans_code
      ,replace(replace(trans_name,chr(13),''),chr(10),'') as trans_name
      ,replace(replace(ta_code,chr(13),''),chr(10),'') as ta_code
      ,replace(replace(asset_acc,chr(13),''),chr(10),'') as asset_acc
      ,replace(replace(prd_code,chr(13),''),chr(10),'') as prd_code
      ,amt
      ,vol
      ,replace(replace(err_code,chr(13),''),chr(10),'') as err_code
      ,replace(replace(err_msg,chr(13),''),chr(10),'') as err_msg
      ,replace(replace(status,chr(13),''),chr(10),'') as status
      ,replace(replace(deal_mode,chr(13),''),chr(10),'') as deal_mode
      ,replace(replace(trans_type,chr(13),''),chr(10),'') as trans_type
      ,replace(replace(reserve1,chr(13),''),chr(10),'') as reserve1
      ,replace(replace(reserve2,chr(13),''),chr(10),'') as reserve2
      ,replace(replace(reserve3,chr(13),''),chr(10),'') as reserve3
  from ${iol_schema}.nfss_tbhismonitor t1 where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nfss_tbhismonitor.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes