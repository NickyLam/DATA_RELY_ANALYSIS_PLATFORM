: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_dpss_dps_transfer_application_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_dpss_dps_transfer_application.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select transfer_amount
,repeal_date
,subsc_tm
,channel
,pty_name
,global_balance
,status_id
,created_stamp
,tran_channel
,acct_no
,allow_daw_times
,prd_peri
,due_rate
,product_id
,acct_name
,transfer_acct_no
,int_start_date
,tran_open_org_id
,product_acct
,transfer_start_date
,last_updated_stamp
,open_org_id
,transfer_end_date
,pty_id
,transfer_fee
,annu_return_rate
,due_days
,tran_seq_no
,acct_date
,transfer_application_id
,transfer_acct_name
,term_int_amt
,product_name
,product_type
,created_tx_stamp
,expt_yld
,last_updated_tx_stamp
,drw_ctrl_meth
,pay_interst
,transfer_rate
,acct_draw_balance
,liab_acct
,due_date
,pay_int_cycl from idl.rpt_dpss_dps_transfer_application where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_dpss_dps_transfer_application.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes