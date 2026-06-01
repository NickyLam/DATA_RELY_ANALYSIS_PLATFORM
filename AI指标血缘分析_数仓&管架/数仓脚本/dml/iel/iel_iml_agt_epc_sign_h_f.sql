: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_epc_sign_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_epc_sign_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.sign_id,chr(13),''),chr(10),'') as sign_id
    ,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
    ,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
    ,replace(replace(t.init_chn_cd,chr(13),''),chr(10),'') as init_chn_cd
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.init_teller_id,chr(13),''),chr(10),'') as init_teller_id
    ,t.sign_dt as sign_dt
    ,t.effect_dt as effect_dt
    ,t.invalid_dt as invalid_dt
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
    ,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
    ,replace(replace(t.mobile_no,chr(13),''),chr(10),'') as mobile_no
    ,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
    ,replace(replace(t.cert_no,chr(13),''),chr(10),'') as cert_no
    ,replace(replace(t.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
    ,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
    ,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
    ,t.create_tm as create_tm
    ,replace(replace(t.epc_org_id,chr(13),''),chr(10),'') as epc_org_id
    ,replace(replace(t.pay_org_acct_id,chr(13),''),chr(10),'') as pay_org_acct_id
    ,replace(replace(t.sync_status_descb,chr(13),''),chr(10),'') as sync_status_descb
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_epc_sign_h t
   where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_epc_sign_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes