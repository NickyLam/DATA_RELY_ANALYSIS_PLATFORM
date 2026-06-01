: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_coll_tran_dtl_flow_f
CreateDate: 20240829
FileName:   ${iel_data_path}/evt_coll_tran_dtl_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.tran_batch_no,chr(13),''),chr(10),'') as tran_batch_no
,replace(replace(t1.tran_sub_batch_no,chr(13),''),chr(10),'') as tran_sub_batch_no
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.mercht_tran_flow_num,chr(13),''),chr(10),'') as mercht_tran_flow_num
,mercht_tran_dt
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_amt
,actl_tran_amt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pt_type_cd,chr(13),''),chr(10),'') as pt_type_cd
,replace(replace(t1.pay_act_cd,chr(13),''),chr(10),'') as pay_act_cd
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.recver_agt_id,chr(13),''),chr(10),'') as recver_agt_id
,replace(replace(t1.tran_postsc,chr(13),''),chr(10),'') as tran_postsc
,replace(replace(t1.core_batch_no,chr(13),''),chr(10),'') as core_batch_no
,replace(replace(t1.core_acct_status_cd,chr(13),''),chr(10),'') as core_acct_status_cd
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.core_req_flow_num,chr(13),''),chr(10),'') as core_req_flow_num
,core_dt
,replace(replace(t1.pass_sys_abbr,chr(13),''),chr(10),'') as pass_sys_abbr
,replace(replace(t1.plat_return_code,chr(13),''),chr(10),'') as plat_return_code
,replace(replace(t1.plat_return_code_descb,chr(13),''),chr(10),'') as plat_return_code_descb
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.call_sys_id,chr(13),''),chr(10),'') as call_sys_id
,fir_create_dt
,final_update_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_coll_tran_dtl_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_coll_tran_dtl_flow.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
