: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_tmss_pay_instr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_tmss_pay_instr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.cnter_vouch_id,chr(13),''),chr(10),'') as cnter_vouch_id
,replace(replace(t1.cnter_acct_id,chr(13),''),chr(10),'') as cnter_acct_id
,t1.appl_tm as appl_tm
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.bk_tresur_strategy_id,chr(13),''),chr(10),'') as bk_tresur_strategy_id
,replace(replace(t1.payer_corp_id,chr(13),''),chr(10),'') as payer_corp_id
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.payer_acct_name,chr(13),''),chr(10),'') as payer_acct_name
,replace(replace(t1.payer_local_prov,chr(13),''),chr(10),'') as payer_local_prov
,replace(replace(t1.payer_local_city,chr(13),''),chr(10),'') as payer_local_city
,t1.pay_amt as pay_amt
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name
,replace(replace(t1.recver_local_prov,chr(13),''),chr(10),'') as recver_local_prov
,replace(replace(t1.recver_local_city,chr(13),''),chr(10),'') as recver_local_city
,replace(replace(t1.recver_ibank_no,chr(13),''),chr(10),'') as recver_ibank_no
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,t1.tran_tm as tran_tm
,t1.return_tm as return_tm
,replace(replace(t1.instr_status_cd,chr(13),''),chr(10),'') as instr_status_cd
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.stl_type_cd,chr(13),''),chr(10),'') as stl_type_cd
,replace(replace(t1.cross_bank_flg,chr(13),''),chr(10),'') as cross_bank_flg
,replace(replace(t1.remote_flg,chr(13),''),chr(10),'') as remote_flg
,replace(replace(t1.dir_pay_flg,chr(13),''),chr(10),'') as dir_pay_flg
,replace(replace(t1.mdl_pay_acct_id,chr(13),''),chr(10),'') as mdl_pay_acct_id
,replace(replace(t1.mdl_pay_acct_name,chr(13),''),chr(10),'') as mdl_pay_acct_name
,replace(replace(t1.mdl_pay_open_bank_name,chr(13),''),chr(10),'') as mdl_pay_open_bank_name
,replace(replace(t1.bus_ova_id,chr(13),''),chr(10),'') as bus_ova_id
,replace(replace(t1.entry_flg,chr(13),''),chr(10),'') as entry_flg
,t1.entry_dt as entry_dt
,replace(replace(t1.entry_member_id,chr(13),''),chr(10),'') as entry_member_id
,replace(replace(t1.sync_reach_erp_flg,chr(13),''),chr(10),'') as sync_reach_erp_flg
,replace(replace(t1.erp_vouch_id,chr(13),''),chr(10),'') as erp_vouch_id
,replace(replace(t1.instr_src_cd,chr(13),''),chr(10),'') as instr_src_cd
,replace(replace(t1.user_name,chr(13),''),chr(10),'') as user_name
,replace(replace(t1.user_acct_num,chr(13),''),chr(10),'') as user_acct_num
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.instr_type_cd,chr(13),''),chr(10),'') as instr_type_cd
,replace(replace(t1.tran_flow_id,chr(13),''),chr(10),'') as tran_flow_id
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_tmss_pay_instr t1
where create_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_tmss_pay_instr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes