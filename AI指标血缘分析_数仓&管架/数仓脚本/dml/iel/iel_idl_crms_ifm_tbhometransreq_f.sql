: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbhometransreq_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbhometransreq_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
serial_no
,ex_serial
,contract_no
,trans_date
,trans_time
,occur_init_date
,seller_code
,trans_code
,control_flag
,branch_no
,open_branch
,ta_code
,asset_acc
,in_client_no
,client_type
,id_type
,id_code
,bank_no
,client_no
,bank_acc
,cash_flag
,trans_account_type
,trans_account
,channel
,term_no
,oper_no
,auth_oper
,prd_code
,curr_type
,prd_type
,share_class
,asso_date
,asso_serial
,asso_serial2
,asso_serial3
,amt
,manage_charge
,manage_charge2
,agio
,client_group
,liqu_status
,ori_channel
,ori_branch_no
,vol
,larg_red_flag
,red_mode
,prd_price
,amt_ratio
,div_mode
,div_rate
,frozen_cause
,transfer_cause
,conv_dir
,targ_prd_code
,targ_seller_code
,targ_asset_acc
,targ_branch
,targ_bank_acc
,client_risk
,product_risk
,cfm_date
,cfm_no
,cfm_vol
,to_host_serial
,host_check_date
,ori_host_chk_date
,host_trans_code
,host_date
,host_serial
,monitor_flag
,client_manager
,err_code
,err_msg
,status
,cfm_status
,deal_mode
,summary
,debit_account
,fee_account
,amt1
,amt2
,home_id
,is_main
,msg_send_date
,reserve1
,reserve2
,reserve3
,reserve4
,reserve5
from ${idl_schema}.crms_ifm_tbhometransreq
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbhometransreq_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes