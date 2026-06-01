: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_guar_share_right_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_guar_share_right.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,t1.etl_dt as etl_dt
,replace(replace(t1.share_right_typ_cd,chr(13),''),chr(10),'') as share_right_typ_cd
,replace(replace(t1.stock_or_fund_cd,chr(13),''),chr(10),'') as stock_or_fund_cd
,replace(replace(t1.share_right_cert_num,chr(13),''),chr(10),'') as share_right_cert_num
,t1.share_right_val as share_right_val
,t1.share_right_pct as share_right_pct
,t1.ly_each_stock_divi_amt as ly_each_stock_divi_amt
,t1.each_stock_market_val as each_stock_market_val
,replace(replace(t1.ipo_corp_name,chr(13),''),chr(10),'') as ipo_corp_name
,replace(replace(t1.issue_corp,chr(13),''),chr(10),'') as issue_corp
,replace(replace(t1.corp_prft_flg,chr(13),''),chr(10),'') as corp_prft_flg
,t1.qty as qty
,t1.issue_prc as issue_prc
,t1.purch_prc as purch_prc
,t1.purch_dt as purch_dt
,t1.due_dt as due_dt
,t1.last_each_stock_net_ast as last_each_stock_net_ast
,t1.warn_line as warn_line
,t1.offs_line as offs_line
,t1.shr_net_ast as shr_net_ast
,t1.nearby_deal_tkt_prc as nearby_deal_tkt_prc
,t1.impa_shr as impa_shr
,t1.rstr_sell_dt as rstr_sell_dt
,t1.impa_qty as impa_qty
,replace(replace(t1.ipo_corp_flg,chr(13),''),chr(10),'') as ipo_corp_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_ccrm_agt_guar_share_right t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_guar_share_right.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes