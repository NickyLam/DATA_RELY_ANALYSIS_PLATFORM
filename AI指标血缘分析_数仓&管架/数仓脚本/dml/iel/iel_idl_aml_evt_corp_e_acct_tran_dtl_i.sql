: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_corp_e_acct_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_corp_e_acct_tran_dtl.i.${batch_date}.dat
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
,operr_id
,pay_id
,indent_id
,init_chn_id
,tran_tm
,acct_tm
,indent_item_ser_num
,fund_corp_return_order_no
,fin_acct_tran_type_cd
,status_cd
,effect_tm
,invalid_tm
,dep_term
,init_flow_num
,tran_amt
,actl_bal
,aval_bal
,final_update_tm
,final_update_affair_tm
,remark
,postsc
,memo
,call_sys_id from idl.aml_evt_corp_e_acct_tran_dtl where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_corp_e_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes