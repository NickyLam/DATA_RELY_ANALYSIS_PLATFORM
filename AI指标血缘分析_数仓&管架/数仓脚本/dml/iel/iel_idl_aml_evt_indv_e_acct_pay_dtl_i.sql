: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_indv_e_acct_pay_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_indv_e_acct_pay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,pay_id
,fin_acct_tran_dtl_id
,prod_acct_id
,tran_org_id
,init_pay_id
,payment_flow_num
,pay_type_cd
,mode_pay_type_cd
,from_mem_cd
,status_cd
,mode_pay_flg
,curr_cd
,tran_kind_cd
,acct_tm
,tran_tm
,tran_amt
,actl_amt
,actl_bal
,aval_bal
,cntpty_acct_num
,cntpty_acct_name
,cntpty_acct_open_bank_num
,cntpty_acct_open_bank_name
,final_update_tm
,remark
,memo
,postsc from idl.aml_evt_indv_e_acct_pay_dtl where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_indv_e_acct_pay_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes