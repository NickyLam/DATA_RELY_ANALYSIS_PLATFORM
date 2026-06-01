: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbacccfm_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbacccfm_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ta_code
,cfm_date
,cfm_no
,from_flag
,trans_date
,trans_time
,serial_no
,trans_code
,busin_code
,branch_no
,open_branch
,channel
,term_no
,oper_no
,in_client_no
,client_type
,asset_acc
,bank_no
,client_no
,bank_acc
,ta_client
,trans_account_type
,trans_account
,sex
,id_type
,id_code
,client_name
,short_name
,birthday
,address
,post_code
,mobile
,tel
,fax
,email
,send_freq
,send_mode
,asso_date
,frozen_cause
,acc_card_no
,summary
,asso_serial
,client_manager
,err_code
,err_msg
,status
,reserve1
,reserve2
from ${idl_schema}.crms_ifm_tbacccfm
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbacccfm_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes