: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_bill_center_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_bill_center_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     etl_dt
    ,lp_id
    ,bill_id
    ,bill_num
    ,bill_med_cd
    ,bill_type_cd
    ,draw_dt
    ,exp_dt
    ,curr_cd
    ,fac_val_amt
    ,drawer_name
    ,drawer_acct_num
    ,drawer_open_bank_no
    ,drawer_open_bank_name
    ,recver_name
    ,recver_acct_num
    ,recver_open_bank_no
    ,recver_open_bank_name
    ,pay_bank_bank_no
    ,pay_bank_name
    ,pay_org_id
    ,pay_cfm_org_id
    ,accptor_name
    ,accptor_acct_num
    ,accptor_open_bank_no
    ,accptor_open_bank_name
    ,holder_org_id
    ,holder_org_name
    ,endors_cnt
    ,lock_flg
    ,loss_flg
    ,hxb_acpt_flg
    ,pay_cfm_flg
    ,payoff_flg
    ,recs_flg
    ,risk_status_cd
    ,bill_src_cd
    ,bill_status_cd
    ,belong_org_id
    ,data_src_cd
from idl.icrm_cmm_bill_center_info
where etl_dt = to_date('${batch_date}','yyyymmdd')
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_bill_center_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes