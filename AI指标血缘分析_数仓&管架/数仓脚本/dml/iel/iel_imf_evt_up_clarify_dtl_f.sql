: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_up_clarify_dtl_f
CreateDate: 20250804
FileName:   ${iel_data_path}/evt_up_clarify_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ser_num,chr(13),''),chr(10),'') as ser_num
,replace(replace(t1.batch_no,chr(13),''),chr(10),'') as batch_no
,replace(replace(t1.fund_corp_id,chr(13),''),chr(10),'') as fund_corp_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.cnter_org_id,chr(13),''),chr(10),'') as cnter_org_id
,remit_acct_dt
,replace(replace(t1.remit_acct_status_cd,chr(13),''),chr(10),'') as remit_acct_status_cd
,should_remit_acct_amt
,actl_remit_acct_amt
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_acct_type_cd,chr(13),''),chr(10),'') as pay_acct_type_cd
,replace(replace(t1.pay_acct_open_bank_num,chr(13),''),chr(10),'') as pay_acct_open_bank_num
,replace(replace(t1.pay_acct_open_bank_name,chr(13),''),chr(10),'') as pay_acct_open_bank_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd

from ${iml_schema}.evt_up_clarify_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_up_clarify_dtl.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
