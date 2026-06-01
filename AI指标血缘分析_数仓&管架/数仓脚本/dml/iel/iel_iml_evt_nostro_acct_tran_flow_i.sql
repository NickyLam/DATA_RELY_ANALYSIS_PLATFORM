: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_nostro_acct_tran_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_nostro_acct_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t.obank_tran_dt as obank_tran_dt
,replace(replace(t.obank_tran_type_cd,chr(13),''),chr(10),'') as obank_tran_type_cd
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t.obank_debit_crdt_dir_cd,chr(13),''),chr(10),'') as obank_debit_crdt_dir_cd
,t.obank_tran_amt as obank_tran_amt
,t.obank_bal as obank_bal
,t.core_bal as core_bal
,replace(replace(t.core_bal_adj_std_cd,chr(13),''),chr(10),'') as core_bal_adj_std_cd
,replace(replace(t.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t.obank_cntpty_bank_name,chr(13),''),chr(10),'') as obank_cntpty_bank_name
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
 from iml.evt_nostro_acct_tran_flow t 
 where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_nostro_acct_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes