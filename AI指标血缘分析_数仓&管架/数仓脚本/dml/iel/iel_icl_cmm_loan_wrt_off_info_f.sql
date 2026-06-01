: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_loan_wrt_off_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_loan_wrt_off_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.appl_teller_id,chr(13),''),chr(10),'') as appl_teller_id
,t1.fir_wrt_off_dt as fir_wrt_off_dt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.actl_wrtoff_loan_pric as actl_wrtoff_loan_pric
,t1.actl_wrtoff_in_bs_int as actl_wrtoff_in_bs_int
,t1.actl_wrtoff_off_bs_int as actl_wrtoff_off_bs_int
,t1.wrt_off_advc_money_amt as wrt_off_advc_money_amt
,t1.wrt_off_retra_pric as wrt_off_retra_pric
,t1.wrt_off_retra_in_bs_int as wrt_off_retra_in_bs_int
,t1.wrt_off_retra_off_bs_int as wrt_off_retra_off_bs_int
,t1.wrt_off_retra_advc_fee as wrt_off_retra_advc_fee
,t1.wrt_off_retra_cnt as wrt_off_retra_cnt
,replace(replace(t1.all_retra_flg,chr(13),''),chr(10),'') as all_retra_flg
,t1.final_wrt_off_retra_dt as final_wrt_off_retra_dt
,replace(replace(t1.loan_num,chr(13),''),chr(10),'') as loan_num
from ${icl_schema}.cmm_loan_wrt_off_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_loan_wrt_off_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes