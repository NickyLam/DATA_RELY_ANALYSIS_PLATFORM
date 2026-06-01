: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_crps_cmm_unite_wl_wrt_off_info_morning_f
CreateDate: 20251229
FileName:   ${iel_data_path}/crps_cmm_unite_wl_wrt_off_info_morning.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,acct_id
,dubil_id
,cont_id
,std_prod_id
,cust_id
,belong_org_id
,appl_teller_id
,fir_wrt_off_dt
,curr_cd
,actl_wrtoff_loan_pric
,actl_wrtoff_in_bs_int
,actl_wrtoff_off_bs_int
,wrt_off_advc_money_amt
,wrt_off_retra_pric
,wrt_off_retra_in_bs_int
,wrt_off_retra_off_bs_int
,wrt_off_retra_advc_fee
,wrt_off_retra_cnt
,all_retra_flg
,final_wrt_off_retra_dt
from ${idl_schema}.crps_cmm_unite_wl_wrt_off_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_cmm_unite_wl_wrt_off_info_morning.f.${batch_date}.dat" \
        charset=utf8
        safe=yes