: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ncds_issue_rest_dtl_f
CreateDate: 20250305
FileName:   ${iel_data_path}/evt_ncds_issue_rest_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_odd_no,chr(13),''),chr(10),'') as tran_odd_no
,replace(replace(t1.sub_tran_odd_no,chr(13),''),chr(10),'') as sub_tran_odd_no
,replace(replace(t1.dep_rcpt_cd,chr(13),''),chr(10),'') as dep_rcpt_cd
,replace(replace(t1.dep_rcpt_asset_type_cd,chr(13),''),chr(10),'') as dep_rcpt_asset_type_cd
,replace(replace(t1.dep_rcpt_market_type_cd,chr(13),''),chr(10),'') as dep_rcpt_market_type_cd
,replace(replace(t1.issue_way_cd,chr(13),''),chr(10),'') as issue_way_cd
,replace(replace(t1.subscr_ps_id,chr(13),''),chr(10),'') as subscr_ps_id
,replace(replace(t1.subscr_ps_name,chr(13),''),chr(10),'') as subscr_ps_name
,bid_price
,bid_qtty
,hit_bid_price
,hit_bid_qtty
,replace(replace(t1.subscr_tm,chr(13),''),chr(10),'') as subscr_tm
,replace(replace(t1.submit_user,chr(13),''),chr(10),'') as submit_user
,actl_subscr_qtty
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.sell_org,chr(13),''),chr(10),'') as sell_org
,replace(replace(t1.fee_calc_rule_cd,chr(13),''),chr(10),'') as fee_calc_rule_cd
,replace(replace(t1.actl_subscr_ps_id,chr(13),''),chr(10),'') as actl_subscr_ps_id

from ${iml_schema}.evt_ncds_issue_rest_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ncds_issue_rest_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
