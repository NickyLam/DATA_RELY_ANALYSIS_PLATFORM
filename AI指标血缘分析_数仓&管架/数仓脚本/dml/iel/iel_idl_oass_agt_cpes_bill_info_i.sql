: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_cpes_bill_info_i
CreateDate: 20221115
FileName:   ${iel_data_path}/oass_agt_cpes_bill_info.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.vouch_id as vouch_id
,t1.lp_id as lp_id
,t1.bill_id as bill_id
,t1.bill_num as bill_num
,t1.bill_med_cd as bill_med_cd
,t1.bill_type_cd as bill_type_cd
,t1.draw_dt as draw_dt
,t1.exp_dt as exp_dt
,t1.fac_val_amt as fac_val_amt
,t1.drawer_name as drawer_name
,t1.drawer_acct_num as drawer_acct_num
,t1.drawer_soci_crdt_cd as drawer_soci_crdt_cd
,t1.drawer_open_acct_org_cd as drawer_open_acct_org_cd
,t1.drawer_open_bank_no as drawer_open_bank_no
,t1.drawer_open_bank_name as drawer_open_bank_name
,t1.accptor_name as accptor_name
,t1.accptor_acct_num as accptor_acct_num
,t1.accptor_soci_crdt_cd as accptor_soci_crdt_cd
,t1.accptor_open_acct_org_cd as accptor_open_acct_org_cd
,t1.accptor_open_bank_no as accptor_open_bank_no
,t1.accptor_open_bank_name as accptor_open_bank_name
,t1.recver_name as recver_name
,t1.recver_acct_num as recver_acct_num
,t1.recver_soci_crdt_cd as recver_soci_crdt_cd
,t1.recver_open_acct_org_cd as recver_open_acct_org_cd
,t1.recver_open_bank_no as recver_open_bank_no
,t1.recver_open_bank_name as recver_open_bank_name
,t1.pay_bank_org_cd as pay_bank_org_cd
,t1.pay_bank_no as pay_bank_no
,t1.pay_cfm_org_cd as pay_cfm_org_cd
,t1.discnt_bk_org_cd as discnt_bk_org_cd
,t1.discnt_guar_org_cd as discnt_guar_org_cd
,t1.invtry_org_cd as invtry_org_cd
,t1.bill_ccution_status_cd as bill_ccution_status_cd
,t1.risk_bill_status_cd as risk_bill_status_cd
,t1.bill_invtry_status_cd as bill_invtry_status_cd
,t1.bill_status_cd as bill_status_cd
,t1.init_ccution_status_cd as init_ccution_status_cd
,t1.init_risk_bill_status_cd as init_risk_bill_status_cd
,t1.init_bill_status_cd as init_bill_status_cd
,t1.init_bill_invtry_status_cd as init_bill_invtry_status_cd
,t1.discnt_dt as discnt_dt
,t1.start_dt as create_dt
,t1.end_dt as update_dt
,t1.id_mark as id_mark
,t1.job_cd as job_cd

from ${idl_schema}.oass_agt_cpes_bill_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_cpes_bill_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
