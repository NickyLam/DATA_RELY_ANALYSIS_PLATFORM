: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_cpes_bill_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/oass_agt_cpes_bill_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.vouch_id
,t.lp_id
,t.bill_id
,t.bill_num
,t.bill_med_cd
,t.bill_type_cd
,t.draw_dt
,t.exp_dt
,t.fac_val_amt
,t.drawer_name
,t.drawer_acct_num
,t.drawer_soci_crdt_cd
,t.drawer_open_acct_org_cd
,t.drawer_open_bank_no
,t.drawer_open_bank_name
,t.accptor_name
,t.accptor_acct_num
,t.accptor_soci_crdt_cd
,t.accptor_open_acct_org_cd
,t.accptor_open_bank_no
,t.accptor_open_bank_name
,t.recver_name
,t.recver_acct_num
,t.recver_soci_crdt_cd
,t.recver_open_acct_org_cd
,t.recver_open_bank_no
,t.recver_open_bank_name
,t.pay_bank_org_cd
,t.pay_bank_no
,t.pay_cfm_org_cd
,t.discnt_bk_org_cd
,t.discnt_guar_org_cd
,t.invtry_org_cd
,t.bill_ccution_status_cd
,t.risk_bill_status_cd
,t.bill_invtry_status_cd
,t.bill_status_cd
,t.init_ccution_status_cd
,t.init_risk_bill_status_cd
,t.init_bill_status_cd
,t.init_bill_invtry_status_cd
,t.discnt_dt
,t.start_dt
,t.end_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.oass_agt_cpes_bill_info t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_cpes_bill_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes