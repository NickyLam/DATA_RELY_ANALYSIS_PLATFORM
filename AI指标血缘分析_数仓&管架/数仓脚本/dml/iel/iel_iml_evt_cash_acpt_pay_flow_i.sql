: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cash_acpt_pay_flow_i
CreateDate: 20221105
FileName:   ${iel_data_path}/evt_cash_acpt_pay_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.tran_dt as tran_dt
    ,replace(replace(t.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tail_box_num,chr(13),''),chr(10),'') as tail_box_num
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.amt as amt
    ,t.ths_tm_stl_bal as ths_tm_stl_bal
    ,replace(replace(t.memo_cd,chr(13),''),chr(10),'') as memo_cd
    ,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
    ,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
    ,replace(replace(t.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
    ,replace(replace(t.entry_teller_id,chr(13),''),chr(10),'') as entry_teller_id
    ,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
    ,replace(replace(t.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
    ,replace(replace(t.stat_proj_cd,chr(13),''),chr(10),'') as stat_proj_cd
    ,replace(replace(t.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
from iml.evt_cash_acpt_pay_flow t
  where t.tran_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cash_acpt_pay_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes