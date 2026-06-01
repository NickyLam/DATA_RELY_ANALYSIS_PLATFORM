: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_insure_tran_flow_f
CreateDate: 20230423
FileName:   ${iel_data_path}/evt_insure_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,tran_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.insure_pl_num,chr(13),''),chr(10),'') as insure_pl_num
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_cd_name,chr(13),''),chr(10),'') as tran_cd_name
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,comm_fee
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,policy_dt
,replace(replace(t1.policy_cfm_flow_num,chr(13),''),chr(10),'') as policy_cfm_flow_num
,host_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,replace(replace(t1.host_tran_cd,chr(13),''),chr(10),'') as host_tran_cd
,replace(replace(t1.host_return_code,chr(13),''),chr(10),'') as host_return_code
,replace(replace(t1.host_return_info,chr(13),''),chr(10),'') as host_return_info
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.insure_print_id,chr(13),''),chr(10),'') as insure_print_id
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.evt_insure_tran_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_insure_tran_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
