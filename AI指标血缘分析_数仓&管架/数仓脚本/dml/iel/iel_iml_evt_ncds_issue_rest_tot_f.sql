: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ncds_issue_rest_tot_f
CreateDate: 20230804
FileName:   ${iel_data_path}/evt_ncds_issue_rest_tot.f.${batch_date}.dat
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
,subscr_tm
,replace(replace(t1.submit_user,chr(13),''),chr(10),'') as submit_user
,actl_subscr_qtty
,replace(replace(t1.sell_org_id,chr(13),''),chr(10),'') as sell_org_id
,replace(replace(t1.sell_org_pct_comb,chr(13),''),chr(10),'') as sell_org_pct_comb
,replace(replace(t1.sell_org_name_comb,chr(13),''),chr(10),'') as sell_org_name_comb
,replace(replace(t1.sell_org_pct_comnt,chr(13),''),chr(10),'') as sell_org_pct_comnt
,replace(replace(t1.belong_org_pct_comb,chr(13),''),chr(10),'') as belong_org_pct_comb
,replace(replace(t1.belong_org_name_comb,chr(13),''),chr(10),'') as belong_org_name_comb
,replace(replace(t1.belong_org_pct_comnt,chr(13),''),chr(10),'') as belong_org_pct_comnt
,pay_amt
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.ghb_open_bank_no,chr(13),''),chr(10),'') as ghb_open_bank_no
,replace(replace(t1.fee_calc_rule_cd,chr(13),''),chr(10),'') as fee_calc_rule_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_ncds_issue_rest_tot t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ncds_issue_rest_tot.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
