: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_bill_discnt_dtl_f
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_bill_discnt_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.agt_id as agt_id
,t1.lp_id as lp_id
,t1.buy_dtl_id as buy_dtl_id
,t1.buy_way_cd as buy_way_cd
,t1.batch_id as batch_id
,t1.discnt_type_cd as discnt_type_cd
,t1.bill_id as bill_id
,t1.city_wide_flg as city_wide_flg
,t1.rher_name as rher_name
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.defer_days as defer_days
,t1.int_accr_days as int_accr_days
,t1.not_ngbl_flg as not_ngbl_flg
,t1.int_amt as int_amt
,t1.onl_clear_flg as onl_clear_flg
,t1.buyer_pay_int as buyer_pay_int
,t1.actl_amt as actl_amt
,t1.discnt_appl_enter_acct_num as discnt_appl_enter_acct_num
,t1.discnt_appl_enter_acct_bk_no as discnt_appl_enter_acct_bk_no
,t1.dscnt_props_cate_cd as dscnt_props_cate_cd
,t1.dscnt_props_name as dscnt_props_name
,t1.dscnt_props_orgnz_cd as dscnt_props_orgnz_cd
,t1.dscnt_props_acct_num as dscnt_props_acct_num
,t1.dscnt_props_udtake_bk_no as dscnt_props_udtake_bk_no
,t1.tran_cont_id as tran_cont_id
,t1.entry_dt as entry_dt
,t1.entry_status_cd as entry_status_cd
,t1.recv_dt as recv_dt
,t1.buy_dtl_status_cd as buy_dtl_status_cd
,t1.final_modif_tm as final_modif_tm
,t1.modif_teller_id as modif_teller_id
,t1.bill_sub_intrv_id as bill_sub_intrv_id
,t1.quick_discnt_status_cd as quick_discnt_status_cd
,t1.quick_discnt_flg as quick_discnt_flg
,t1.bill_src_cd as bill_src_cd
,t1.crdt_out_acct_flow_num as crdt_out_acct_flow_num
,t1.h_data_flg as h_data_flg
,t1.create_dt as create_dt
,t1.update_dt as update_dt
,t1.id_mark as id_mark

from ${idl_schema}.oass_agt_bill_discnt_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_bill_discnt_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
