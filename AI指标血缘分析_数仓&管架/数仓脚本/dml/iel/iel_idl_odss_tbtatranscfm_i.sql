: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbtatranscfm_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbtatranscfm_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
busin_code
,cfm_date
,cfm_no
,trans_date
,serial_no
,seller_code
,branch_no
,asset_acc
,ta_client
,prd_code
,share_class
,cfm_amt
,cfm_vol
,tot_cfm_amt
,tot_cfm_vol
,no_cfm_amt
,no_cfm_vol
,trade_fee
,ori_fee
,transfer_fee
,stamp_tax
,back_fee
,other_fee1
,interest
,interest_tax
,interest_share
,ori_trade_fee
,total_fee
,commision
,regist_fee
,asset_fee
,manage_fee
,ori_transfer_fee
,ori_back_fee
,ori_other_fee1
,nav
,frozen_amt
,unfrozen_amt
,status
,ta_flag
,client_type
,in_client_no
,gain_income
,end_flag
,client_income
,branch_income
,ch_vol
,cfm_income
,amt
,vol
,agio
,last_vol
,last_frozen_vol
,targ_prd_code
,targ_share_class
,targ_asset_acc
,targ_seller_code
,targ_net_no
,div_mode
,ori_serial_no
,larg_red_flag
,frozen_cause
,frozen_end_date
,out_busin_code
,channel
,ori_agio
,cis_date
,back_agio
,bank_no
,real_flag
,err_code
,err_msg
,amt1
,amt2
,reserve1
,reserve2
,reserve3
,reserve4
,reserve5
from ${idl_schema}.odss_tbtatranscfm
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbtatranscfm_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes