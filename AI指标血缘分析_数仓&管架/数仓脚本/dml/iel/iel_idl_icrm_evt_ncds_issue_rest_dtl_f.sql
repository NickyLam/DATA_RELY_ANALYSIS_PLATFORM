: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_evt_ncds_issue_rest_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_evt_ncds_issue_rest_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select evt_id
,lp_id
,tran_odd_no
,sub_tran_odd_no
,dep_rcpt_cd
,dep_rcpt_asset_type_cd
,dep_rcpt_market_type_cd
,issue_way_cd
,subscr_ps_id
,subscr_ps_name
,bid_price
,bid_qtty
,hit_bid_price
,hit_bid_qtty
,subscr_tm
,submit_user
,actl_subscr_qtty
,remark
,sell_org
,fee_calc_rule_cd
,etl_dt
,job_cd from idl.icrm_evt_ncds_issue_rest_dtl where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_evt_ncds_issue_rest_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes