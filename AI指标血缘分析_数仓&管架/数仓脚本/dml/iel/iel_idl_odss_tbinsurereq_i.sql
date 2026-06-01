: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbinsurereq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbinsurereq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
trans_date
,serial_no
,bank_no
,asso_serial
,ta_code
,prd_code
,insure_no
,client_manager
,client_no
,client_type
,trans_code
,trans_name
,bank_acc
,acc_name
,voucher_type
,voucher_no
,voucher_pwd
,voucher_date
,voucher_note
,curr_type
,clear_status
,check_status
,liqu_status
,amt
,charge
,internal_branch
,branch_no
,oper_no
,auth_oper
,term
,channel
,err_code
,err_msg
,insure_date
,insure_cfm_no
,insure_trans_code
,targ_err_code
,targ_err_msg
,host_date
,host_serial
,host_trans_code
,host_err_code
,host_err_msg
,status
,trans_time
,offer_charge
,insure_print
,amt1
,amt2
,reserve1
,reserve2
,reserve3
from ${idl_schema}.odss_tbinsurereq
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbinsurereq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes