: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_agt_ibank_dep_rcpt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_agt_ibank_dep_rcpt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select vouch_id
,lp_id
,dep_rcpt_cd
,asset_type_cd
,market_type_cd
,curr_cd
,quot_way_cd
,dep_rcpt_name
,prod_type_cd
,prod_type_name
,int_rat_pct_spd_bp
,issue_qtty
,issue_price
,lowt_issue_price
,higt_issue_price
,value_dt
,exp_dt
,tenor_val
,fir_int_rat_cfm_dt
,pay_int_freq_cd
,issue_way_cd
,coupon_type_cd
,base_rat_id
,base_asset_type_id
,base_market_type_id
,stl_status_cd
,pay_dt
,cash_dt
,issue_dt
,annual_int_rat
,int_accr_base_cd
,fir_pay_int_dt
,invt_bid_way_cd
,lowt_yld_rat
,higt_yld_rat
,actl_issue_qtty
,issuer_name
,range
,rating_org
,rating
,fac_val
,start_issue_dt
,end_issue_dt
,max_subscr_qtty
,min_subscr_qtty
,sig_max_subscr_qtty
,etl_dt
,job_cd from idl.icrm_agt_ibank_dep_rcpt where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_agt_ibank_dep_rcpt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes