: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbhissquare_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbhissquare.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.square_no,chr(13),''),chr(10),'') as square_no
,t.seq_no as seq_no
,t.trans_date as trans_date
,t.clear_date as clear_date
,t.square_date as square_date
,t.old_square_date as old_square_date
,replace(replace(t.serial_no,chr(13),''),chr(10),'') as serial_no
,replace(replace(t.asso_serial,chr(13),''),chr(10),'') as asso_serial
,replace(replace(t.from_flag,chr(13),''),chr(10),'') as from_flag
,replace(replace(t.trans_code,chr(13),''),chr(10),'') as trans_code
,replace(replace(t.busin_code,chr(13),''),chr(10),'') as busin_code
,replace(replace(t.client_type,chr(13),''),chr(10),'') as client_type
,replace(replace(t.in_client_no,chr(13),''),chr(10),'') as in_client_no
,replace(replace(t.bank_no,chr(13),''),chr(10),'') as bank_no
,replace(replace(t.client_no,chr(13),''),chr(10),'') as client_no
,replace(replace(t.bank_acc,chr(13),''),chr(10),'') as bank_acc
,replace(replace(t.bank_acc_kind,chr(13),''),chr(10),'') as bank_acc_kind
,replace(replace(t.channel,chr(13),''),chr(10),'') as channel
,replace(replace(t.oper_no,chr(13),''),chr(10),'') as oper_no
,replace(replace(t.term_no,chr(13),''),chr(10),'') as term_no
,replace(replace(t.branch_no,chr(13),''),chr(10),'') as branch_no
,replace(replace(t.open_branch,chr(13),''),chr(10),'') as open_branch
,replace(replace(t.ta_code,chr(13),''),chr(10),'') as ta_code
,replace(replace(t.prd_code,chr(13),''),chr(10),'') as prd_code
,replace(replace(t.liqu_dir,chr(13),''),chr(10),'') as liqu_dir
,t.amt as amt
,replace(replace(t.curr_type,chr(13),''),chr(10),'') as curr_type
,replace(replace(t.cash_flag,chr(13),''),chr(10),'') as cash_flag
,t.unfrozen_amt as unfrozen_amt
,replace(replace(t.host_trans_code,chr(13),''),chr(10),'') as host_trans_code
,t.host_date as host_date
,replace(replace(t.host_serial,chr(13),''),chr(10),'') as host_serial
,t.frozen_amt as frozen_amt
,replace(replace(t.check_status,chr(13),''),chr(10),'') as check_status
,replace(replace(t.distrib_flag,chr(13),''),chr(10),'') as distrib_flag
,replace(replace(t.amt_flag,chr(13),''),chr(10),'') as amt_flag
,replace(replace(t.cost_income_flag,chr(13),''),chr(10),'') as cost_income_flag
,t.cfm_vol as cfm_vol
,t.cost as cost
,t.cfm_income as cfm_income
,t.vol_cumulate as vol_cumulate
,replace(replace(t.prd_account,chr(13),''),chr(10),'') as prd_account
,replace(replace(t.prd_account_kind,chr(13),''),chr(10),'') as prd_account_kind
,replace(replace(t.summary,chr(13),''),chr(10),'') as summary
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.old_square_no,chr(13),''),chr(10),'') as old_square_no
,replace(replace(t.err_code,chr(13),''),chr(10),'') as err_code
,replace(replace(t.err_msg,chr(13),''),chr(10),'') as err_msg
,replace(replace(t.deal_status,chr(13),''),chr(10),'') as deal_status
,t.amt1 as amt1
,t.amt2 as amt2
,t.amt3 as amt3
,replace(replace(t.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t.reserve5,chr(13),''),chr(10),'') as reserve5
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.IFMS_tbhissquare t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')
and square_date='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbhissquare.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes