: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_insure_pl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_insure_pl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.insure_pl_id,chr(13),''),chr(10),'') as insure_pl_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.insure_print_id,chr(13),''),chr(10),'') as insure_print_id
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.teller_id,chr(13),''),chr(10),'') as teller_id
,t.tran_dt as tran_dt
,replace(replace(t.seq_num,chr(13),''),chr(10),'') as seq_num
,t.policy_dt as policy_dt
,t.cfm_dt as cfm_dt
,t.policy_effect_dt as policy_effect_dt
,replace(replace(t.pay_ped,chr(13),''),chr(10),'') as pay_ped
,replace(replace(t.insure_ped_type_cd,chr(13),''),chr(10),'') as insure_ped_type_cd
,replace(replace(t.insure_ped,chr(13),''),chr(10),'') as insure_ped
,replace(replace(t.mode_pay_cd,chr(13),''),chr(10),'') as mode_pay_cd
,replace(replace(t.pay_ped_type_cd,chr(13),''),chr(10),'') as pay_ped_type_cd
,t.tran_amt as tran_amt
,t.insure_fee as insure_fee
,t.lot as lot
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.holder_name,chr(13),''),chr(10),'') as holder_name
,replace(replace(t.holder_cert_type_cd,chr(13),''),chr(10),'') as holder_cert_type_cd
,replace(replace(t.holder_cert_no,chr(13),''),chr(10),'') as holder_cert_no
,replace(replace(t.rela_type_cd,chr(13),''),chr(10),'') as rela_type_cd
,replace(replace(t.insrt_name,chr(13),''),chr(10),'') as insrt_name
,replace(replace(t.insrt_cert_type_cd,chr(13),''),chr(10),'') as insrt_cert_type_cd
,replace(replace(t.insrt_cert_no,chr(13),''),chr(10),'') as insrt_cert_no
,t.start_dt
,t.end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_insure_pl t
where start_dt<=to_date('${batch_date}','yyyymmdd') 
and end_dt>to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_insure_pl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes