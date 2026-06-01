: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_agt_wl_distr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_agt_wl_distr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,distr_id
,appl_id
,lp_id
,agt_id
,dubil_id
,prod_id
,cust_id
,cust_name
,appl_amt
,appl_dt
,distr_dt
,open_acct_bank_name
,open_acct_card_no
,repay_acct_name
,repay_acct_card_no
,loan_perds
,loan_int_rat
,serv_int_rat
,inst_comm_fee_rat
,serv_fee
,distr_amt
,inst_comm_fee_amt
,distr_way_cd
,appl_status_cd
,tran_status_cd
,manu_apv_flg
,obank_card_flg
,fail_oper_flow_cd
,open_acct_bind_mobile_no
,obank_card_tran_flow_num
,pay_order_no
,loan_tran_flow_num
,glob_tran_flow_num
,host_crdt_flow_num
,host_debit_flow_num
,froz_tran_dt
,froz_tran_flow_id
,distr_mode_cd
,noth_rpp_conti_old_dubil_id
,create_dt
,update_dt
,id_mark
from idl.aml_agt_wl_distr_info
where create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_agt_wl_distr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes