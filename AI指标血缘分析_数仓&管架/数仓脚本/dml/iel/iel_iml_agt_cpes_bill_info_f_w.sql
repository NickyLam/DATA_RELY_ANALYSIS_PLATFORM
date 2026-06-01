: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cpes_bill_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cpes_bill_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,t1.draw_dt as draw_dt
,t1.exp_dt as exp_dt
,t1.fac_val_amt as fac_val_amt
,replace(replace(t1.drawer_name,chr(13),''),chr(10),'') as drawer_name
,replace(replace(t1.drawer_acct_num,chr(13),''),chr(10),'') as drawer_acct_num
,replace(replace(t1.drawer_soci_crdt_cd,chr(13),''),chr(10),'') as drawer_soci_crdt_cd
,replace(replace(t1.drawer_open_acct_org_cd,chr(13),''),chr(10),'') as drawer_open_acct_org_cd
,replace(replace(t1.drawer_open_bank_no,chr(13),''),chr(10),'') as drawer_open_bank_no
,replace(replace(t1.drawer_open_bank_name,chr(13),''),chr(10),'') as drawer_open_bank_name
,replace(replace(t1.accptor_name,chr(13),''),chr(10),'') as accptor_name
,replace(replace(t1.accptor_acct_num,chr(13),''),chr(10),'') as accptor_acct_num
,replace(replace(t1.accptor_soci_crdt_cd,chr(13),''),chr(10),'') as accptor_soci_crdt_cd
,replace(replace(t1.accptor_open_acct_org_cd,chr(13),''),chr(10),'') as accptor_open_acct_org_cd
,replace(replace(t1.accptor_open_bank_no,chr(13),''),chr(10),'') as accptor_open_bank_no
,replace(replace(t1.accptor_open_bank_name,chr(13),''),chr(10),'') as accptor_open_bank_name
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name
,replace(replace(t1.recver_acct_num,chr(13),''),chr(10),'') as recver_acct_num
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd
,replace(replace(t1.recver_open_acct_org_cd,chr(13),''),chr(10),'') as recver_open_acct_org_cd
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.pay_bank_org_cd,chr(13),''),chr(10),'') as pay_bank_org_cd
,replace(replace(t1.pay_bank_no,chr(13),''),chr(10),'') as pay_bank_no
,replace(replace(t1.pay_cfm_org_cd,chr(13),''),chr(10),'') as pay_cfm_org_cd
,replace(replace(t1.discnt_bk_org_cd,chr(13),''),chr(10),'') as discnt_bk_org_cd
,replace(replace(t1.discnt_guar_org_cd,chr(13),''),chr(10),'') as discnt_guar_org_cd
,replace(replace(t1.invtry_org_cd,chr(13),''),chr(10),'') as invtry_org_cd
,replace(replace(t1.bill_ccution_status_cd,chr(13),''),chr(10),'') as bill_ccution_status_cd
,replace(replace(t1.risk_bill_status_cd,chr(13),''),chr(10),'') as risk_bill_status_cd
,replace(replace(t1.bill_invtry_status_cd,chr(13),''),chr(10),'') as bill_invtry_status_cd
,replace(replace(t1.bill_status_cd,chr(13),''),chr(10),'') as bill_status_cd
,replace(replace(t1.init_ccution_status_cd,chr(13),''),chr(10),'') as init_ccution_status_cd
,replace(replace(t1.init_risk_bill_status_cd,chr(13),''),chr(10),'') as init_risk_bill_status_cd
,replace(replace(t1.init_bill_status_cd,chr(13),''),chr(10),'') as init_bill_status_cd
,replace(replace(t1.init_bill_invtry_status_cd,chr(13),''),chr(10),'') as init_bill_invtry_status_cd
,t1.discnt_dt as discnt_dt
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id
,t1.bill_intrv_std_amt as bill_intrv_std_amt
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_cpes_bill_info t1 
where ETL_DT between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd')  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cpes_bill_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes