: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ods_a_d_ifm_info_ft_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ods_a_d_ifm_info_ft_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,in_client_no
,seller_code
,bank_no
,bank_acc
,client_no
,custcn
,client_type
,ta_code
,ta_client
,asset_acc
,open_branch
,curr_type
,control_flag
,cash_flag
,prd_code
,prd_type
,ipo_start_date
,ipo_end_date
,income_date
,end_date
,income_end_date
,guest_rate
,tot_vol
,MK_VAL
,frozen_vol
,long_frozen_vol
,group_vol
,other_frozen
,income
,income_frozen
,income_new
,ystdy_tot_vol
,cost
,tot_income
,income_onway
,nav
,nav_date
,buy_amt_tol
,redeem_share_tol
,redeem_amt_tol
,curr_amt
,append_flag
,trans_account_type
,trans_account
,div_mode
,old_div_mode
,div_rate
,client_manager
,last_date
,ifm_mon_cml
,ifm_quar_cml
,ifm_year_cml
,ifm_mon_avl
,ifm_quar_avl
,ifm_year_avl
,MK_MON_CML
,MK_QUAR_CML
,MK_YEAR_CML
,MK_MON_AVL
,MK_QUAR_AVL
,MK_YEAR_AVL
,estab_date
,status
,control_flag2
from ${idl_schema}.crms_ods_a_d_ifm_info_ft
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ods_a_d_ifm_info_ft_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes