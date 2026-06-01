: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_dep_tran_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_dep_tran_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t.tran_amt as tran_amt
,t.ths_tm_bal as ths_tm_bal
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t.tran_vouch_id,chr(13),''),chr(10),'') as tran_vouch_id
,replace(replace(t.entry_teller_id,chr(13),''),chr(10),'') as entry_teller_id
,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,t.tran_tm_stamp as tran_tm_stamp
,replace(replace(t.temp_acct_bill_flg,chr(13),''),chr(10),'') as temp_acct_bill_flg
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.cntpty_acct_open_bank_id,chr(13),''),chr(10),'') as cntpty_acct_open_bank_id
,replace(replace(t.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,replace(replace(t.beps_unpasew_flg,chr(13),''),chr(10),'') as beps_unpasew_flg
from ${iml_schema}.evt_dep_tran_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_dep_tran_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes