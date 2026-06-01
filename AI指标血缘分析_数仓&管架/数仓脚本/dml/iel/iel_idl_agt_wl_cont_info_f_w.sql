: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_cont_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_cont_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.intnal_cont_id
,t1.cont_id
,t1.loan_prod_id
,t1.crdt_appl_id
,t1.loan_appl_id
,t1.cust_id
,t1.acct_id
,t1.chn_id
,t1.open_acct_bank_name
,t1.card_no
,t1.cust_name
,t1.id_no
,t1.open_acct_mobile_no
,t1.cont_amt
,t1.curr_cd
,t1.exec_int_rat
,t1.comm_fee_rat
,t1.serv_fee_rat
,t1.loan_tenor
,t1.repay_day
,t1.effect_dt
,t1.invalid_dt
,t1.grace_days
,t1.circl_flg
,t1.tenor_type_cd
,t1.repay_way_cd
,t1.guar_way_cd
,t1.loan_usage_cd
,t1.ovdue_pay_flg
,t1.int_rat_type_cd
,t1.farm_flg
,t1.repay_card_type_cd
,t1.cont_status_cd
,t1.create_tm
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_wl_cont_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_cont_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes