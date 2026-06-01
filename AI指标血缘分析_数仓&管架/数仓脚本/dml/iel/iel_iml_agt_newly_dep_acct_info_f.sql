: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_newly_dep_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_newly_dep_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t.clos_acct_org_id,chr(13),''),chr(10),'') as clos_acct_org_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term
,t.acct_exp_dt as acct_exp_dt
,t.acct_open_acct_dt as acct_open_acct_dt
,t.acct_clos_acct_dt as acct_clos_acct_dt
,t.acct_valid_dt as acct_valid_dt
,t.curr_gl_bal as curr_gl_bal
,t.ld_gl_bal as ld_gl_bal
,t.init_amt as init_amt
,t.open_acct_amt as open_acct_amt
,t.acct_retnd_max_bal as acct_retnd_max_bal
,t.acct_retnd_min_bal as acct_retnd_min_bal
,t.recnt_update_dt as recnt_update_dt
,t.last_bus_dt as last_bus_dt
,t.last_coll_pay_dt as last_coll_pay_dt
,t.init_value_dt as init_value_dt
,t.init_exp_dt as init_exp_dt
,t.statmt_create_dt as statmt_create_dt
,t.recnt_check_entry_dt as recnt_check_entry_dt
,t.fir_depot_dt as fir_depot_dt
,t.recnt_acct_vrfction_dt as recnt_acct_vrfction_dt
,t.curr_unused_seq_num as curr_unused_seq_num
,replace(replace(t.caln_name,chr(13),''),chr(10),'') as caln_name
,replace(replace(t.acct_flg_string,chr(13),''),chr(10),'') as acct_flg_string
,replace(replace(t.liab_prod_type_cd,chr(13),''),chr(10),'') as liab_prod_type_cd
,replace(replace(t.prod_belong_obj_cd,chr(13),''),chr(10),'') as prod_belong_obj_cd
,replace(replace(t.acct_cls_cd_1,chr(13),''),chr(10),'') as acct_cls_cd_1
,replace(replace(t.acct_cls_cd_3,chr(13),''),chr(10),'') as acct_cls_cd_3
,replace(replace(t.depot_ctrl_way_cd,chr(13),''),chr(10),'') as depot_ctrl_way_cd
,replace(replace(t.drawdown_ctrl_way_cd,chr(13),''),chr(10),'') as drawdown_ctrl_way_cd
,replace(replace(t.drawdown_mpr_flg,chr(13),''),chr(10),'') as drawdown_mpr_flg
,replace(replace(t.redt_way_cd,chr(13),''),chr(10),'') as redt_way_cd
,t.stdby_amt as stdby_amt
,t.drawdown_intrv as drawdown_intrv
,replace(replace(t.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.check_entry_flg,chr(13),''),chr(10),'') as check_entry_flg
,replace(replace(t.acct_check_entry_ped,chr(13),''),chr(10),'') as acct_check_entry_ped
,replace(replace(t.check_entry_range,chr(13),''),chr(10),'') as check_entry_range
,replace(replace(t.vrfction_flg,chr(13),''),chr(10),'') as vrfction_flg
,replace(replace(t.bal_and_gl_sync_flg,chr(13),''),chr(10),'') as bal_and_gl_sync_flg
,replace(replace(t.spec_expns_acct_flg,chr(13),''),chr(10),'') as spec_expns_acct_flg
,replace(replace(t.cap_expns_acct,chr(13),''),chr(10),'') as cap_expns_acct
,replace(replace(t.spec_inco_acct_flg,chr(13),''),chr(10),'') as spec_inco_acct_flg
,replace(replace(t.cap_inco_acct,chr(13),''),chr(10),'') as cap_inco_acct
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,replace(replace(t.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.corp_curr_acct_attr_cd,chr(13),''),chr(10),'') as corp_curr_acct_attr_cd
,replace(replace(t.acct_lmt_flg,chr(13),''),chr(10),'') as acct_lmt_flg
,replace(replace(t.acct_amt_froz_flg,chr(13),''),chr(10),'') as acct_amt_froz_flg
,replace(replace(t.acct_close_froz_flg,chr(13),''),chr(10),'') as acct_close_froz_flg
,replace(replace(t.acct_only_out_flg,chr(13),''),chr(10),'') as acct_only_out_flg
,replace(replace(t.acct_only_in_flg,chr(13),''),chr(10),'') as acct_only_in_flg
,replace(replace(t.rela_circl_loan_flg,chr(13),''),chr(10),'') as rela_circl_loan_flg
,replace(replace(t.have_acct_prot_rela_flg,chr(13),''),chr(10),'') as have_acct_prot_rela_flg
,replace(replace(t.modal_tran_flg,chr(13),''),chr(10),'') as modal_tran_flg
,replace(replace(t.monit_acct_flg,chr(13),''),chr(10),'') as monit_acct_flg
,replace(replace(t.cap_veri_acct_flg,chr(13),''),chr(10),'') as cap_veri_acct_flg
,replace(replace(t.rsrv_corp_check_pwd_flg,chr(13),''),chr(10),'') as rsrv_corp_check_pwd_flg
,replace(replace(t.check_acct_flg,chr(13),''),chr(10),'') as check_acct_flg
,replace(replace(t.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg
,replace(replace(t.prep_cfm_stl_acct_flg,chr(13),''),chr(10),'') as prep_cfm_stl_acct_flg
,replace(replace(t.fx_supv_flg,chr(13),''),chr(10),'') as fx_supv_flg
,replace(replace(t.fx_vrfction_flg,chr(13),''),chr(10),'') as fx_vrfction_flg
,replace(replace(t.nomal_acct_charge_flg,chr(13),''),chr(10),'') as nomal_acct_charge_flg
,replace(replace(t.dormt_acct_charge_flg,chr(13),''),chr(10),'') as dormt_acct_charge_flg
,replace(replace(t.stl_acct_flg,chr(13),''),chr(10),'') as stl_acct_flg
,replace(replace(t.margin_dep_flg,chr(13),''),chr(10),'') as margin_dep_flg
,replace(replace(t.fin_dep_flg,chr(13),''),chr(10),'') as fin_dep_flg
,replace(replace(t.sign_finc_flg,chr(13),''),chr(10),'') as sign_finc_flg
,replace(replace(t.realtm_tran_flg,chr(13),''),chr(10),'') as realtm_tran_flg
,replace(replace(t.rela_od_flg,chr(13),''),chr(10),'') as rela_od_flg
,replace(replace(t.bal_coll_flg,chr(13),''),chr(10),'') as bal_coll_flg
,replace(replace(t.onl_fee_batch_post_recv_flg,chr(13),''),chr(10),'') as onl_fee_batch_post_recv_flg
,replace(replace(t.batch_post_recv_fee_freq,chr(13),''),chr(10),'') as batch_post_recv_fee_freq
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,t.seq_num as seq_num
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_newly_dep_acct_info t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_newly_dep_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes