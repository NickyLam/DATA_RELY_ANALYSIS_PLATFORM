: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_tran_rece_flow_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_tran_rece_flow_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.rece_dt as rece_dt
,replace(replace(t.rece_flow_num,chr(13),''),chr(10),'') as rece_flow_num
,t.rece_seq_num as rece_seq_num
,replace(replace(t.rece_type_cd,chr(13),''),chr(10),'') as rece_type_cd
,replace(replace(t.proc_id,chr(13),''),chr(10),'') as proc_id
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t.tran_amt as tran_amt
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
,replace(replace(t.tran_acct_open_bank_id,chr(13),''),chr(10),'') as tran_acct_open_bank_id
,replace(replace(t.tran_acct_open_bank_name,chr(13),''),chr(10),'') as tran_acct_open_bank_name
,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.cntpty_acct_open_bank_id,chr(13),''),chr(10),'') as cntpty_acct_open_bank_id
,replace(replace(t.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,replace(replace(t.remark_1,chr(13),''),chr(10),'') as remark_1
,replace(replace(t.remark_2,chr(13),''),chr(10),'') as remark_2
,replace(replace(t.remark_3,chr(13),''),chr(10),'') as remark_3
,replace(replace(t.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t.final_print_teller_id,chr(13),''),chr(10),'') as final_print_teller_id
,t.print_cnt as print_cnt
,replace(replace(t.rece_id,chr(13),''),chr(10),'') as rece_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t.ec_flg_cd,chr(13),''),chr(10),'') as ec_flg_cd
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,t.tran_tm as tran_tm
from ${iml_schema}.evt_tran_rece_flow t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_tran_rece_flow_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes