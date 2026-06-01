: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pirs_agt_br_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pirs_agt_br_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.inc_form_ref,chr(13),''),chr(10),'') as inc_form_ref
,t1.etl_dt as etl_dt
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.acpt_fwd_lc_bal as acpt_fwd_lc_bal
,t1.acpctn_dt as acpctn_dt
,t1.inc_sng_day_dt as inc_sng_day_dt
,replace(replace(t1.payer_name,chr(13),''),chr(10),'') as payer_name
,replace(replace(t1.pay_acct_no,chr(13),''),chr(10),'') as pay_acct_no
,replace(replace(t1.payer_org_id,chr(13),''),chr(10),'') as payer_org_id
,t1.pay_dt as pay_dt
,t1.pay_total_amt as pay_total_amt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pirs_agt_br_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pirs_agt_br_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes