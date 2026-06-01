: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_agt_tmss_recvbl_instr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_agt_tmss_recvbl_instr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,agt_id
,lp_id
,flow_id
,bill_id
,appl_id
,group_id
,bank_id
,bk_tresur_strategy_id
,payer_acct_id
,recver_acct_id
,recver_ibank_no
,recvbl_amt
,exec_tm
,instr_status_cd
,rela_dtl_id
,return_tm
,return_info
,memo
,postsc
,bank_proc_tm
,urgent_flg
,cross_bank_flg
,user_name
,instr_type_cd
,tran_flow_id from idl.rpt_agt_tmss_recvbl_instr where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_agt_tmss_recvbl_instr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes