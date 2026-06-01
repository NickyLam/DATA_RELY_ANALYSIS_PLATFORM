: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_digit_curr_fin_tran_flow_f
CreateDate: 20241029
FileName:   ${iel_data_path}/evt_digit_curr_fin_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,midgrod_tran_dt
,replace(replace(t1.midgrod_tran_code,chr(13),''),chr(10),'') as midgrod_tran_code
,replace(replace(t1.fin_tran_code,chr(13),''),chr(10),'') as fin_tran_code
,fin_tran_dt
,replace(replace(t1.fin_flow_num,chr(13),''),chr(10),'') as fin_flow_num
,replace(replace(t1.bank_int_bus_seq_num,chr(13),''),chr(10),'') as bank_int_bus_seq_num
,replace(replace(t1.msg_type,chr(13),''),chr(10),'') as msg_type
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,tran_amt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.pay_flow_num,chr(13),''),chr(10),'') as pay_flow_num
,replace(replace(t1.payer_acct_id,chr(13),''),chr(10),'') as payer_acct_id
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.entry_id,chr(13),''),chr(10),'') as entry_id
,check_entry_dt
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,replace(replace(t1.revs_rs,chr(13),''),chr(10),'') as revs_rs
,replace(replace(t1.init_pay_flow_num,chr(13),''),chr(10),'') as init_pay_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,final_update_dt

from ${iml_schema}.evt_digit_curr_fin_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_digit_curr_fin_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
