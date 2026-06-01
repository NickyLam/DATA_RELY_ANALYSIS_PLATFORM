: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_wyd_tran_flow_i
CreateDate: 20250228
FileName:   ${iel_data_path}/evt_wyd_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.we_flow_num,chr(13),''),chr(10),'') as we_flow_num
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.level5_cls_cd,chr(13),''),chr(10),'') as level5_cls_cd
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,acct_bal
,replace(replace(t1.cash_trans_flg,chr(13),''),chr(10),'') as cash_trans_flg
,enter_acct_amt
,replace(replace(t1.enter_acct_way_cd,chr(13),''),chr(10),'') as enter_acct_way_cd
,enter_acct_dt
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_bank_name,chr(13),''),chr(10),'') as cntpty_bank_name
,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t1.repay_clear_tran_id,chr(13),''),chr(10),'') as repay_clear_tran_id
,batch_dt
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_belong_org_id,chr(13),''),chr(10),'') as rgst_belong_org_id
,rgst_dt
,replace(replace(t1.final_update_teller_id,chr(13),''),chr(10),'') as final_update_teller_id
,replace(replace(t1.final_update_org_id,chr(13),''),chr(10),'') as final_update_org_id
,final_update_dt

from ${iml_schema}.evt_wyd_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd') - 1" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wyd_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
