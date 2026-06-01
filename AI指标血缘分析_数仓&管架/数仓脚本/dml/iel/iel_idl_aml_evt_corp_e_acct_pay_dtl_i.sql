: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_corp_e_acct_pay_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_corp_e_acct_pay_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,pay_id
,init_pay_id
,prod_acct_id
,fin_acct_tran_dtl_id
,tran_org_id
,acct_tm
,payment_flow_num
,tran_amt
,this_obank_flg
,cntpty_acct_level_cd
,curr_cd
,pay_type_cd
,mode_pay_type_cd
,from_mem_cd
,status_cd
,mode_pay_flg
,cntpty_acct_num
,cntpty_acct_name
,cntpty_acct_open_bank_num
,cntpty_acct_open_bank_name
,acct_name
,tran_tm
,final_update_tm
,memo
,remark
,postsc from idl.aml_evt_corp_e_acct_pay_dtl where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_corp_e_acct_pay_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes