: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbgoldreq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbgoldreq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serial_no
,ex_serial
,bank_no
,term_no
,oper_no
,auth_oper
,branch_no
,channel
,gold_date
,trans_date
,trans_time
,client_manager
,trans_type
,asso_serial
,trans_code
,gold_client_no
,area_code
,center_code
,transfer_type
,client_name
,id_type
,id_code
,in_client_no
,client_no
,client_type
,bank_acc
,liqu_status
,curr_type
,cash_flag
,check_date
,amt
,gold_account
,targ_bank_acc
,host_trans_code
,to_host_serial
,host_date
,host_serial
,host_err_code
,host_err_msg
,err_code
,err_msg
,status
,amt1
,reserve1
,reserve2
,reserve3
,reserve4
,reserve5
from ${idl_schema}.crms_ifm_tbgoldreq
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbgoldreq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes