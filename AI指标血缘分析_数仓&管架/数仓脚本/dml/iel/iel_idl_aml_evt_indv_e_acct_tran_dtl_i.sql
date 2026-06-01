: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_indv_e_acct_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_indv_e_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,fin_acct_tran_dtl_id
,init_tran_dtl_id
,prod_acct_id
,party_id
,pay_id
,indent_id
,operr_id
,init_chn_id
,tran_tm
,acct_tm
,effect_tm
,invalid_tm
,tran_amt
,actl_bal
,aval_bal
,fund_corp_return_order_no
,init_flow_num
,status_cd
,fin_acct_tran_type_cd
,final_update_tm
,dep_term
,memo
,postsc
,remark
,call_sys_id from idl.aml_evt_indv_e_acct_tran_dtl where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_indv_e_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes