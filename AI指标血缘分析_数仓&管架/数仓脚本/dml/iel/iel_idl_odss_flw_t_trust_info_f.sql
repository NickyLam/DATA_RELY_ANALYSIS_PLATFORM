: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_flw_t_trust_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_flw_t_trust_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,process_inst_id
,main_flow_id
,accept_no
,root_accept_no
,scan_seq_no
,tr_date
,accept_time
,user_id
,charge_id
,br_code
,biz_code
,tr_state
,tr_state_msg
,submit_state
,trust_pay_no
,bill_no
,contract_no
,contract_wdno
,contract_name
,contract_curr_code
,contract_trn_amt
,trust_pay_acct_no
,trust_pay_acct_name
,trust_pay_curr_code
,trust_pay_trn_amt
,ori_loan_date
,ori_loan_seqno
,trust_pay_count
,rec_pay_serial_no1
,rec_acct_name1
,rec_acct_no1
,rec_bk_no1
,rec_bk_name1
,rec_purpose1
,rec_tr_amt1
,rec_last_pay_date1
,rec_pay_serial_no2
,rec_acct_name2
,rec_acct_no2
,rec_bk_no2
,rec_bk_name2
,rec_purpose2
,rec_tr_amt2
,rec_last_pay_date2
,rec_pay_serial_no3
,rec_acct_name3
,rec_acct_no3
,rec_bk_no3
,rec_bk_name3
,rec_purpose3
,rec_tr_amt3
,rec_last_pay_date3
,rec_pay_serial_no4
,rec_acct_name4
,rec_acct_no4
,rec_bk_no4
,rec_bk_name4
,rec_purpose4
,rec_tr_amt4
,rec_last_pay_date4
,rec_pay_serial_no5
,rec_acct_name5
,rec_acct_no5
,rec_bk_no5
,rec_bk_name5
,rec_purpose5
,rec_tr_amt5
,rec_last_pay_date5
,check_user_id
,check_time
,put_out_no
,currency1
,currency2
,currency3
,currency4
,currency5
,cust_type
from ${idl_schema}.odss_flw_t_trust_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_flw_t_trust_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes