: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_agt_tmss_pay_instr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_agt_tmss_pay_instr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,lp_id
,bill_id
,cnter_vouch_id
,cnter_acct_id
,appl_tm
,group_id
,bank_id
,bk_tresur_strategy_id
,payer_corp_id
,payer_acct_id
,payer_open_bank_name
,payer_acct_name
,payer_local_prov
,payer_local_city
,pay_amt
,tran_curr_cd
,recver_acct_id
,recver_open_bank_name
,recver_acct_name
,recver_local_prov
,recver_local_city
,recver_ibank_no
,memo
,postsc
,tran_type_cd
,tran_tm
,return_tm
,instr_status_cd
,return_info
,apv_status_cd
,stl_type_cd
,cross_bank_flg
,remote_flg
,dir_pay_flg
,mdl_pay_acct_id
,mdl_pay_acct_name
,mdl_pay_open_bank_name
,bus_ova_id
,entry_flg
,entry_dt
,entry_member_id
,sync_reach_erp_flg
,erp_vouch_id
,instr_src_cd
,user_name
,user_acct_num
,data_src_cd
,instr_type_cd
,tran_flow_id from idl.rpt_agt_tmss_pay_instr where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_agt_tmss_pay_instr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes