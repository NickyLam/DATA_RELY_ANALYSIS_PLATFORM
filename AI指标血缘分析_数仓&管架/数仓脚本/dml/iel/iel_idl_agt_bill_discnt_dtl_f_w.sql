: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_bill_discnt_dtl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_discnt_dtl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.buy_dtl_id as buy_dtl_id
,t.buy_way_cd as buy_way_cd
,t.batch_id as batch_id
,t.bill_id as bill_id
,t.bill_bs_bus_type_cd as bill_bs_bus_type_cd
,t.discnt_type_cd as discnt_type_cd
,t.sys_in_out_flg as sys_in_out_flg
,t.city_wide_flg as city_wide_flg
,t.rher_name as rher_name
,t.int_accr_exp_dt as int_accr_exp_dt
,t.msg_appl_dt as msg_appl_dt
,t.defer_days as defer_days
,t.int_accr_days as int_accr_days
,t.not_ngbl_flg as not_ngbl_flg
,t.int_amt as int_amt
,t.onl_clear_flg as onl_clear_flg
,t.buyer_pay_int as buyer_pay_int
,t.actl_amt as actl_amt
,t.risk_bear_fee as risk_bear_fee
,t.discnt_appl_enter_acct_num as discnt_appl_enter_acct_num
,t.discnt_appl_enter_acct_bk_no as discnt_appl_enter_acct_bk_no
,t.dscnt_props_cate_cd as dscnt_props_cate_cd
,t.dscnt_props_name as dscnt_props_name
,t.dscnt_props_orgnz_cd as dscnt_props_orgnz_cd
,t.dscnt_props_acct_num as dscnt_props_acct_num
,t.dscnt_props_open_bank_no as dscnt_props_open_bank_no
,t.dscnt_props_udtake_bk_no as dscnt_props_udtake_bk_no
,t.dscnt_cate_cd as dscnt_cate_cd
,t.dscnt_name as dscnt_name
,t.dscnt_acct_num as dscnt_acct_num
,t.dscnt_open_bank_no as dscnt_open_bank_no
,t.tran_cont_id as tran_cont_id
,t.accept_status_cd as accept_status_cd
,t.entry_dt as entry_dt
,t.entry_status_cd as entry_status_cd
,t.recv_dt as recv_dt
,t.revo_dt as revo_dt
,t.accrualed_int_flg as accrualed_int_flg
,t.buy_dtl_status_cd as buy_dtl_status_cd
,t.final_modif_tm as final_modif_tm
,t.int_d_value as int_d_value
,t.create_dt as create_dt 
,t.update_dt as update_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_bill_discnt_dtl t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_discnt_dtl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes