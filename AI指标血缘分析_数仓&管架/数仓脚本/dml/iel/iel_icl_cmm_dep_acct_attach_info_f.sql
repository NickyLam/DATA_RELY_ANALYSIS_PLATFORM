: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_acct_attach_info_f
CreateDate: 20260417
FileName:   ${iel_data_path}/cmm_dep_acct_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.fx_acct_char_cd,chr(13),''),chr(10),'') as fx_acct_char_cd
,replace(replace(t1.agt_dep_type_cd,chr(13),''),chr(10),'') as agt_dep_type_cd
,replace(replace(t1.acct_lics_num,chr(13),''),chr(10),'') as acct_lics_num
,acct_lics_issue_dt
,replace(replace(t1.cap_char_cd,chr(13),''),chr(10),'') as cap_char_cd
,replace(replace(t1.acct_close_rs_descb,chr(13),''),chr(10),'') as acct_close_rs_descb
,replace(replace(t1.l_six_m_no_tran_flg,chr(13),''),chr(10),'') as l_six_m_no_tran_flg
,replace(replace(t1.supv_type_cd,chr(13),''),chr(10),'') as supv_type_cd
,replace(replace(t1.xhc_flg,chr(13),''),chr(10),'') as xhc_flg
,long_hang_amt
,init_open_acct_dt
,init_exp_dt
,sub_acct_int_rat_float_ratio
,sub_acct_int_rat_float_point
,delay_pay_int_int_float_point
,txy_main_agt_files_int_rat
,txy_sub_agt_agree_int_rat
,cap_pool_agt_rat
,replace(replace(t1.cert_print_flg,chr(13),''),chr(10),'') as cert_print_flg
,replace(replace(t1.precon_wdraw_flg,chr(13),''),chr(10),'') as precon_wdraw_flg
,precon_wdraw_dt
,apot_tenor_start_dt
,apot_tenor_end_dt
,replace(replace(t1.heat_insu_acct_flg,chr(13),''),chr(10),'') as heat_insu_acct_flg
,replace(replace(t1.travel_card_acct_flg,chr(13),''),chr(10),'') as travel_card_acct_flg
,replace(replace(t1.soci_secu_fin_acct_flg,chr(13),''),chr(10),'') as soci_secu_fin_acct_flg
,supv_idf_set_dt
,supv_idf_cancel_dt
,replace(replace(t1.int_rat_apv_form_odd_no,chr(13),''),chr(10),'') as int_rat_apv_form_odd_no
,apot_tenor_amt

from ${icl_schema}.cmm_dep_acct_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_acct_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
