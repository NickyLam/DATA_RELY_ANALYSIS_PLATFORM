: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_fina_tbtranscfm_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_fina_tbtranscfm_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select ta_code
,cfm_date
,cfm_no
,ori_cfm_no
,from_flag
,trans_date
,trans_time
,clear_date
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
,client_name
,bank_acc
,ta_client
,trans_account_type
,trans_account
,cash_flag
,prd_code
,share_class
,nav
,price
,amt
,curr_type
,cfm_amt
,vol
,cfm_vol
,larg_red_flag
,red_cause
,agio
,tot_fee
,charge
,stamp_tax
,interest_tax
,transfer_fee
,agency_fee
,back_fee
,other_fee1
,other_fee2
,cfm_income
,manage_fee
,cont_frozen_amt
,vol_cumulate
,detail_flag
,finish_flag
,frozen_cause
,conv_dir
,targ_prd_code
,targ_nav
,targ_price
,targ_cfm_vol
,targ_seller_code
,targ_branch
,targ_asset_acc
,targ_bank_acc
,interest
,vol_of_int
,div_mode
,div_rate
,summary
,err_code
,err_msg
,status
,client_manager
,asso_date
,asso_serial
,bank_charge
,ex_serial
,contract_no
,manage_charge
,host_trans_code
,host_date
,host_serial
,post_vol
,amt1
,amt2
,amt3
,reserve1
,reserve2
,reserve3
,std_curr_type from idl.pirs_f_evt_fina_tbtranscfm where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_fina_tbtranscfm_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes