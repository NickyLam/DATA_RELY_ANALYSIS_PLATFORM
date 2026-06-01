: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ibank_dep_rcpt_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_ibank_dep_rcpt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.dep_rcpt_cd,chr(13),''),chr(10),'') as dep_rcpt_cd
,replace(replace(t1.asset_type_cd,chr(13),''),chr(10),'') as asset_type_cd
,replace(replace(t1.market_type_cd,chr(13),''),chr(10),'') as market_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.quot_way_cd,chr(13),''),chr(10),'') as quot_way_cd
,replace(replace(t1.dep_rcpt_name,chr(13),''),chr(10),'') as dep_rcpt_name
,replace(replace(t1.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
,replace(replace(t1.prod_type_name,chr(13),''),chr(10),'') as prod_type_name
,int_rat_pct_spd_bp
,issue_qtty
,issue_price
,lowt_issue_price
,higt_issue_price
,value_dt
,exp_dt
,tenor_val
,fir_int_rat_cfm_dt
,replace(replace(t1.pay_int_freq_cd,chr(13),''),chr(10),'') as pay_int_freq_cd
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.coupon_type_cd,chr(13),''),chr(10),'') as coupon_type_cd
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.base_asset_type_id,chr(13),''),chr(10),'') as base_asset_type_id
,replace(replace(t1.base_market_type_id,chr(13),''),chr(10),'') as base_market_type_id
,replace(replace(t1.stl_status_cd,chr(13),''),chr(10),'') as stl_status_cd
,pay_dt
,cash_dt
,issue_dt
,annual_int_rat
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,fir_pay_int_dt
,replace(replace(t1.invt_bid_way_cd,chr(13),''),chr(10),'') as invt_bid_way_cd
,lowt_yld_rat
,higt_yld_rat
,actl_issue_qtty
,replace(replace(t1.issuer_name,chr(13),''),chr(10),'') as issuer_name
,replace(replace(t1.range,chr(13),''),chr(10),'') as range
,replace(replace(t1.rating_org,chr(13),''),chr(10),'') as rating_org
,replace(replace(t1.rating,chr(13),''),chr(10),'') as rating
,fac_val
,start_issue_dt
,end_issue_dt
,max_subscr_qtty
,min_subscr_qtty
,sig_max_subscr_qtty
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_ibank_dep_rcpt t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ibank_dep_rcpt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
