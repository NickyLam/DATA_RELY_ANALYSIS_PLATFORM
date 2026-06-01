: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_prd_acct_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_prd_acct_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.prd_acct_id,chr(13),''),chr(10),'') as prd_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.prd_acct_name,chr(13),''),chr(10),'') as prd_acct_name
,replace(replace(t1.prd_acct_typ_cd,chr(13),''),chr(10),'') as prd_acct_typ_cd
,t1.open_dt as open_dt
,t1.colse_dt as colse_dt
,t1.prev_acti_acct_dt as prev_acti_acct_dt
,replace(replace(t1.prd_acct_status_cd,chr(13),''),chr(10),'') as prd_acct_status_cd
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,replace(replace(t1.metr_typ_cd,chr(13),''),chr(10),'') as metr_typ_cd
,replace(replace(t1.metr_unt_cd,chr(13),''),chr(10),'') as metr_unt_cd
,t1.prd_acct_bal as prd_acct_bal
,t1.usable_bal as usable_bal
,t1.frozen_amt as frozen_amt
,t1.stop_pay_amt as stop_pay_amt
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.sleep_flg,chr(13),''),chr(10),'') as sleep_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_rpts_agt_prd_acct_base_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_prd_acct_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes