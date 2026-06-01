: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbhisaccreq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbhisaccreq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serial_no
,ex_serial
,cfm_no
,trans_date
,trans_time
,occur_init_date
,cfm_date
,trans_code
,control_flag
,branch_no
,open_branch
,ta_code
,in_client_no
,client_type
,id_type
,id_code
,client_name
,short_name
,asset_acc
,base_acc
,seller_code
,bank_no
,client_no
,bank_acc
,trans_account_type
,trans_account
,sex
,birthday
,address
,post_code
,mobile
,tel
,fax
,email
,send_mode
,send_freq
,asso_date
,frozen_cause
,summary
,asso_serial
,channel
,term_no
,oper_no
,auth_oper
,client_manager
,err_code
,err_msg
,status
,deal_mode
,reserve1
,reserve2
,reserve3
,reserve4
from ${idl_schema}.odss_tbhisaccreq
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbhisaccreq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes