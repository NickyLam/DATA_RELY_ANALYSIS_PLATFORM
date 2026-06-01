: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ifms_tbhissquare_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ifms_tbhissquare.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.etl_dt
,t1.square_no
,t1.seq_no
,t1.trans_date
,t1.clear_date
,t1.square_date
,t1.old_square_date
,t1.serial_no
,t1.asso_serial
,t1.from_flag
,t1.trans_code
,t1.busin_code
,t1.client_type
,t1.in_client_no
,t1.bank_no
,t1.client_no
,t1.bank_acc
,t1.bank_acc_kind
,t1.channel
,t1.oper_no
,t1.term_no
,t1.branch_no
,t1.open_branch
,t1.ta_code
,t1.prd_code
,t1.liqu_dir
,t1.amt
,t1.curr_type
,t1.cash_flag
,t1.unfrozen_amt
,t1.host_trans_code
,t1.host_date
,t1.host_serial
,t1.frozen_amt
,t1.check_status
,t1.distrib_flag
,t1.amt_flag
,t1.cost_income_flag
,t1.cfm_vol
,t1.cost
,t1.cfm_income
,t1.vol_cumulate
,t1.prd_account
,t1.prd_account_kind
,t1.summary
,t1.status
,t1.old_square_no
,t1.err_code
,t1.err_msg
,t1.deal_status
,t1.amt1
,t1.amt2
,t1.amt3
,t1.reserve1
,t1.reserve2
,t1.reserve3
,t1.reserve4
,t1.reserve5
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ifms_tbhissquare t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ifms_tbhissquare.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes