: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_dep_acct_assis_info_h_f
CreateDate: 20231115
FileName:   ${iel_data_path}/agt_dep_acct_assis_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.non_i_class_acct_check_status_cd,chr(13),''),chr(10),'') as non_i_class_acct_check_status_cd
,replace(replace(t1.check_fail_rs_descb,chr(13),''),chr(10),'') as check_fail_rs_descb
,replace(replace(t1.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg
,replace(replace(t1.bal_linkg_chg_flg,chr(13),''),chr(10),'') as bal_linkg_chg_flg
,replace(replace(t1.bal_update_type_cd,chr(13),''),chr(10),'') as bal_update_type_cd
,replace(replace(t1.acct_bal_dir_cd,chr(13),''),chr(10),'') as acct_bal_dir_cd
,replace(replace(t1.can_od_flg,chr(13),''),chr(10),'') as can_od_flg
,replace(replace(t1.accrd_freq_pay_int_flg,chr(13),''),chr(10),'') as accrd_freq_pay_int_flg
,replace(replace(t1.allow_manual_entry_flg,chr(13),''),chr(10),'') as allow_manual_entry_flg
,replace(replace(t1.ftz_acct_flg,chr(13),''),chr(10),'') as ftz_acct_flg
,replace(replace(t1.ftz_cd,chr(13),''),chr(10),'') as ftz_cd
,replace(replace(t1.cntpty_acct_num,chr(13),''),chr(10),'') as cntpty_acct_num
,replace(replace(t1.cntpty_acct_num_name,chr(13),''),chr(10),'') as cntpty_acct_num_name
,replace(replace(t1.cntpty_acct_open_acct_org_id,chr(13),''),chr(10),'') as cntpty_acct_open_acct_org_id
,replace(replace(t1.cntpty_acct_open_bank_name,chr(13),''),chr(10),'') as cntpty_acct_open_bank_name
,replace(replace(t1.suspd_wrtoff_flg,chr(13),''),chr(10),'') as suspd_wrtoff_flg
,on_acct_tenor
,replace(replace(t1.wrtoff_way_cd,chr(13),''),chr(10),'') as wrtoff_way_cd
,replace(replace(t1.sign_agt_status_cd,chr(13),''),chr(10),'') as sign_agt_status_cd
,replace(replace(t1.cls_prod_id,chr(13),''),chr(10),'') as cls_prod_id
,replace(replace(t1.sign_prod_cls_cd,chr(13),''),chr(10),'') as sign_prod_cls_cd
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.cert_as_flg,chr(13),''),chr(10),'') as cert_as_flg
,replace(replace(t1.aldy_as_flg,chr(13),''),chr(10),'') as aldy_as_flg
,last_as_reset_dt
,last_as_closing_dt
,replace(replace(t1.blklist_status_cd,chr(13),''),chr(10),'') as blklist_status_cd
,final_blklist_dt
,replace(replace(t1.st_msg_sign_status_cd,chr(13),''),chr(10),'') as st_msg_sign_status_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_redt_tenor,chr(13),''),chr(10),'') as acct_redt_tenor
,replace(replace(t1.acct_redt_tenor_cd,chr(13),''),chr(10),'') as acct_redt_tenor_cd
,replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,replace(replace(t1.bank_inter_id,chr(13),''),chr(10),'') as bank_inter_id
,replace(replace(t1.cntpty_cust_id,chr(13),''),chr(10),'') as cntpty_cust_id
,replace(replace(t1.dep_char_cd,chr(13),''),chr(10),'') as dep_char_cd
,replace(replace(t1.allow_sell_check_flg,chr(13),''),chr(10),'') as allow_sell_check_flg
,replace(replace(t1.apv_odd_no,chr(13),''),chr(10),'') as apv_odd_no
,acm_can_wdraw_pric_amt
,replace(replace(t1.general_exch_org_id,chr(13),''),chr(10),'') as general_exch_org_id
,replace(replace(t1.allow_cnter_cross_bank_depot_permit_flg,chr(13),''),chr(10),'') as allow_cnter_cross_bank_depot_permit_flg
,replace(replace(t1.allow_acct_turn_long_hang_flg,chr(13),''),chr(10),'') as allow_acct_turn_long_hang_flg
,replace(replace(t1.cntpty_bk_open_acct_org_belong_dist_cd,chr(13),''),chr(10),'') as cntpty_bk_open_acct_org_belong_dist_cd
,unexp_draw_dt
,replace(replace(t1.legal_flg,chr(13),''),chr(10),'') as legal_flg
,replace(replace(t1.allow_cnter_cross_bank_wdraw_permit_flg,chr(13),''),chr(10),'') as allow_cnter_cross_bank_wdraw_permit_flg
,replace(replace(t1.last_acct_vrif_status_cd,chr(13),''),chr(10),'') as last_acct_vrif_status_cd
,replace(replace(t1.acct_vrif_status_cd,chr(13),''),chr(10),'') as acct_vrif_status_cd
,replace(replace(t1.cntpty_bank_belong_cty_rg_cd,chr(13),''),chr(10),'') as cntpty_bank_belong_cty_rg_cd
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd
,replace(replace(t1.next_renew_dep_day,chr(13),''),chr(10),'') as next_renew_dep_day
,replace(replace(t1.agt_dep_type_cd,chr(13),''),chr(10),'') as agt_dep_type_cd
,verify_amt
,replace(replace(t1.onl_flg,chr(13),''),chr(10),'') as onl_flg
,replace(replace(t1.disp_way_cd,chr(13),''),chr(10),'') as disp_way_cd
,replace(replace(t1.supv_flg,chr(13),''),chr(10),'') as supv_flg
,replace(replace(t1.supv_content_descb,chr(13),''),chr(10),'') as supv_content_descb
,replace(replace(t1.legal_rs_descb,chr(13),''),chr(10),'') as legal_rs_descb
,replace(replace(t1.verify_type_cd,chr(13),''),chr(10),'') as verify_type_cd
,legal_dt
,clos_acct_reop_dt
,turn_back_dt
,replace(replace(t1.open_acct_way_cd,chr(13),''),chr(10),'') as open_acct_way_cd
,replace(replace(t1.supv_type_cd,chr(13),''),chr(10),'') as supv_type_cd
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.int_tax_impose_flg,chr(13),''),chr(10),'') as int_tax_impose_flg
,tax_rat
,replace(replace(t1.cap_char,chr(13),''),chr(10),'') as cap_char
,cntpty_acct_open_acct_dt
,replace(replace(t1.acct_chn_idf_cd,chr(13),''),chr(10),'') as acct_chn_idf_cd
,earliest_wdraw_dt
,replace(replace(t1.acct_char_cd,chr(13),''),chr(10),'') as acct_char_cd
,replace(replace(t1.inside_acct_char_cd,chr(13),''),chr(10),'') as inside_acct_char_cd
,replace(replace(t1.ped,chr(13),''),chr(10),'') as ped
,replace(replace(t1.ped_corp_cd,chr(13),''),chr(10),'') as ped_corp_cd
,precon_payoff_day

from ${iml_schema}.agt_dep_acct_assis_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_acct_assis_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
