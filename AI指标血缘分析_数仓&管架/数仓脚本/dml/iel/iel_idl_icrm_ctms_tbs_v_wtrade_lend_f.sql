: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ctms_tbs_v_wtrade_lend_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ctms_tbs_v_wtrade_lend.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,deal_id
,deal_tablename
,aspclient_id
,portfolio_id
,portfolio_name
,serial_number
,user_number
,branch_number
,currency
,buyorsell
,amount
,trade_rate
,market_rate
,value_date
,maturity_date
,trade_date
,trade_time
,ref_number
,link_serial_number
,status
,dealer
,account
,maturity_amount
,lend_id
,bondscode
,lendbondscode
,fee
,tax_amt
,broker_amt
,interest
,note
,day_count
,process_status
,realized_pl
,unrealized_pl
,total_pl
,daily_pl
,interest_pl
,realized_days
,ori_trade_date
,security_face_amount
,collateral_type
,lend_rate
,settle_type
,settle_type2
,deal_time
,modify_user
,keepfolder_id
,keepfolder_shortname
,cptys_short_name
,cptys_id
,ref_deal_sn
,valid_source_sn
,cancel_reason
,source
,input_from
,cstp_serial
,cfets_from
,lend_days
,inv_type
,inv_short
,auto_import
,price_flag
,match_flag
,is_trans_quote
,wtrade_lend_id_grand
,datasymbol_id
,orig_serial_number
,impstatus
,prostatus
,spotfwd
,lastmodified from idl.icrm_ctms_tbs_v_wtrade_lend where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ctms_tbs_v_wtrade_lend.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes