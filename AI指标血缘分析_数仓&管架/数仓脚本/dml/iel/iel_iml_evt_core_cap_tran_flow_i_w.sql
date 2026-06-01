: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_core_cap_tran_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_core_cap_tran_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t.tran_amt as tran_amt
,replace(replace(t.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t.tran_sub_acct_id,chr(13),''),chr(10),'') as tran_sub_acct_id
,replace(replace(t.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
,replace(replace(t.tran_acct_open_bank_id,chr(13),''),chr(10),'') as tran_acct_open_bank_id
,replace(replace(t.open_acct_vouch_kind_cd,chr(13),''),chr(10),'') as open_acct_vouch_kind_cd
,replace(replace(t.open_acct_vouch_id,chr(13),''),chr(10),'') as open_acct_vouch_id
,replace(replace(t.tran_vouch_kind_cd,chr(13),''),chr(10),'') as tran_vouch_kind_cd
,replace(replace(t.tran_vouch_id,chr(13),''),chr(10),'') as tran_vouch_id
,t.draw_dt as draw_dt
,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.cntpty_acct_open_bank_id,chr(13),''),chr(10),'') as cntpty_acct_open_bank_id
from ${iml_schema}.evt_core_cap_tran_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_core_cap_tran_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes