: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_entr_pay_rgst_flow_a
CreateDate: 20230512
FileName:   ${iel_data_path}/evt_entr_pay_rgst_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,tran_tm
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.core_tran_code,chr(13),''),chr(10),'') as core_tran_code
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.bank_int_flg,chr(13),''),chr(10),'') as bank_int_flg
,replace(replace(t1.origi_bank_no,chr(13),''),chr(10),'') as origi_bank_no
,replace(replace(t1.payer_open_dept_id,chr(13),''),chr(10),'') as payer_open_dept_id
,replace(replace(t1.payer_acct_num,chr(13),''),chr(10),'') as payer_acct_num
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.pay_bank_name,chr(13),''),chr(10),'') as pay_bank_name
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.money_usage_descb,chr(13),''),chr(10),'') as money_usage_descb
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,stop_pay_dt
,replace(replace(t1.stop_pay_flow_num,chr(13),''),chr(10),'') as stop_pay_flow_num
,core_tran_dt
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,init_tran_dt
,replace(replace(t1.init_flow_num,chr(13),''),chr(10),'') as init_flow_num
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.prod_cd,chr(13),''),chr(10),'') as prod_cd
,replace(replace(t1.acct_ety_code,chr(13),''),chr(10),'') as acct_ety_code
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd

from ${iml_schema}.evt_entr_pay_rgst_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_entr_pay_rgst_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
