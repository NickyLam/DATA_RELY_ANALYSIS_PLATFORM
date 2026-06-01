: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_wl_distr_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_wl_distr_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.distr_id
,t1.appl_id
,t1.lp_id
,t1.agt_id
,t1.dubil_id
,t1.prod_id
,t1.cust_id
,t1.cust_name
,t1.appl_amt
,t1.appl_dt
,t1.distr_dt
,t1.open_acct_bank_name
,t1.open_acct_card_no
,t1.repay_acct_name
,t1.repay_acct_card_no
,t1.loan_perds
,t1.loan_int_rat
,t1.serv_int_rat
,t1.inst_comm_fee_rat
,t1.serv_fee
,t1.distr_amt
,t1.inst_comm_fee_amt
,t1.distr_way_cd
,t1.appl_status_cd
,t1.tran_status_cd
,t1.manu_apv_flg
,t1.obank_card_flg
,t1.fail_oper_flow_cd
,t1.open_acct_bind_mobile_no
,t1.obank_card_tran_flow_num
,t1.pay_order_no
,t1.loan_tran_flow_num
,t1.glob_tran_flow_num
,t1.host_crdt_flow_num
,t1.host_debit_flow_num
,t1.froz_tran_dt
,t1.froz_tran_flow_id
,t1.distr_mode_cd
,t1.noth_rpp_conti_old_dubil_id
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_wl_distr_info t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_wl_distr_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes