: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_consmt_fund_prft_loss_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_consmt_fund_prft_loss_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.fund_prod_id,chr(13),''),chr(10),'') as fund_prod_id
,t.tm_bg_dt as tm_bg_dt
,t.tm_bg_nv as tm_bg_nv
,t.term_end_dt as term_end_dt
,t.term_end_nv as term_end_nv
,t.fund_lot as fund_lot
,t.subscr_amt as subscr_amt
,t.subscr_cfm_amt as subscr_cfm_amt
,t.purch_amt as purch_amt
,t.aip_amt as aip_amt
,t.tran_in_amt as tran_in_amt
,t.turn_trust_in_amt as turn_trust_in_amt
,t.non_tran_tran_in_amt as non_tran_tran_in_amt
,t.lot_man_incre_convt_amt as lot_man_incre_convt_amt
,t.redem_amt as redem_amt
,t.force_redem_amt as force_redem_amt
,t.tran_wdraw_lmt as tran_wdraw_lmt
,t.turn_trust_wdraw_lmt as turn_trust_wdraw_lmt
,t.non_tran_tran_wdraw_lmt as non_tran_tran_wdraw_lmt
,t.divd_lot_convt_amt as divd_lot_convt_amt
,t.divd_lot as divd_lot
,t.divd_amt as divd_amt
,t.fund_liqd_and_termnt_amt as fund_liqd_and_termnt_amt
,t.lot_man_reduc_convt_amt as lot_man_reduc_convt_amt
,t.invest_yld_rat as invest_yld_rat
,t.acm_put_into_cap_lmt as acm_put_into_cap_lmt
,t.acm_invest_prft as acm_invest_prft
,t.avg_buy_price as avg_buy_price
,t.yeb_adv_prft as yeb_adv_prft
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_consmt_fund_prft_loss_h t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_consmt_fund_prft_loss_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes