: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_crdt_lmt_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_crdt_lmt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.fit_prod_id,chr(13),''),chr(10),'') as fit_prod_id
,replace(replace(t1.lmt_prod_id,chr(13),''),chr(10),'') as lmt_prod_id
,replace(replace(t1.curr_crdt_stage_cd,chr(13),''),chr(10),'') as curr_crdt_stage_cd
,replace(replace(t1.init_src_sys_cd,chr(13),''),chr(10),'') as init_src_sys_cd
,replace(replace(t1.init_src_lmt_id,chr(13),''),chr(10),'') as init_src_lmt_id
,replace(replace(t1.happ_way_cd,chr(13),''),chr(10),'') as happ_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.aval_nmal_amt as aval_nmal_amt
,t1.aval_open_amt as aval_open_amt
,t1.open_amt as open_amt
,t1.nmal_amt as nmal_amt
,t1.exec_nmal_amt as exec_nmal_amt
,t1.exec_open_amt as exec_open_amt
,t1.exec_dr_open_amt as exec_dr_open_amt
,replace(replace(t1.dr_open_curr_cd,chr(13),''),chr(10),'') as dr_open_curr_cd
,t1.dr_open_amt as dr_open_amt
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.lmt_under_dir_draw_flg,chr(13),''),chr(10),'') as lmt_under_dir_draw_flg
,t1.effect_dt as effect_dt
,t1.exp_dt as exp_dt
,replace(replace(t1.ocup_idf_cd,chr(13),''),chr(10),'') as ocup_idf_cd
,replace(replace(t1.lock_flg,chr(13),''),chr(10),'') as lock_flg
,replace(replace(t1.aldy_froz_flg,chr(13),''),chr(10),'') as aldy_froz_flg
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,t1.crdt_nmal_bal as crdt_nmal_bal
,t1.crdt_open_bal as crdt_open_bal
,t1.lower_ocup_up_level_crdt_open_amt as lower_ocup_up_level_crdt_open_amt
,t1.lower_ocup_up_level_crdt_nmal_amt as lower_ocup_up_level_crdt_nmal_amt
,t1.spec_ocup_up_level_crdt_open_amt as spec_ocup_up_level_crdt_open_amt
,t1.spec_ocup_up_level_crdt_nmal_amt as spec_ocup_up_level_crdt_nmal_amt
,t1.under_lower_crdt_latest_begin_dt as under_lower_crdt_latest_begin_dt
,t1.under_lower_crdt_earliest_begin_dt as under_lower_crdt_earliest_begin_dt
,t1.lmt_latest_use_dt as lmt_latest_use_dt
,t1.under_lower_crdt_latest_exp_dt as under_lower_crdt_latest_exp_dt
,t1.under_lower_crdt_lont_mon_tenor as under_lower_crdt_lont_mon_tenor
,t1.under_lower_crdt_lont_day_tenor as under_lower_crdt_lont_day_tenor
,t1.lower_crdt_nmal_bal_ocup_tot as lower_crdt_nmal_bal_ocup_tot
,t1.lower_crdt_open_bal_ocup_tot as lower_crdt_open_bal_ocup_tot
,t1.dtl_lmt_next_bus_sig_max_amt as dtl_lmt_next_bus_sig_max_amt
,t1.lmt_next_bus_int_rat_lowt_flo_val as lmt_next_bus_int_rat_lowt_flo_val
,t1.lmt_next_bus_init_margin_ratio as lmt_next_bus_init_margin_ratio
,t1.lmt_next_bus_higt_pm_rat as lmt_next_bus_higt_pm_rat
,t1.lower_bus_ocup_nmal_amt_tot as lower_bus_ocup_nmal_amt_tot
,t1.lower_bus_ocup_open_amt_tot as lower_bus_ocup_open_amt_tot
,t1.beads_nmal_amt as beads_nmal_amt
,t1.beads_open_amt as beads_open_amt
,t1.pre_ocup_nmal_amt as pre_ocup_nmal_amt
,t1.pre_ocup_open_amt as pre_ocup_open_amt
,t1.surp_pre_ocup_nmal_amt as surp_pre_ocup_nmal_amt
,t1.surp_pre_ocup_open_amt as surp_pre_ocup_open_amt
,t1.froz_nmal_amt as froz_nmal_amt
,t1.froz_open_amt as froz_open_amt
,replace(replace(t1.under_bus_curr_cd_range,chr(13),''),chr(10),'') as under_bus_curr_cd_range
,replace(replace(t1.crdt_spec_flg,chr(13),''),chr(10),'') as crdt_spec_flg
,t1.aval_rsrv_amt as aval_rsrv_amt
,t1.rsrv_amt as rsrv_amt
,replace(replace(t1.aval_amt_calc_flg,chr(13),''),chr(10),'') as aval_amt_calc_flg
,replace(replace(t1.guar_way_cd,chr(13),''),chr(10),'') as guar_way_cd
,t1.day_tenor as day_tenor
,t1.mon_tenor as mon_tenor
,t1.acm_distr_amt as acm_distr_amt
,t1.acm_repay_amt as acm_repay_amt
,t1.actl_invalid_dt as actl_invalid_dt
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,replace(replace(t1.mgmt_teller_id,chr(13),''),chr(10),'') as mgmt_teller_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,t1.rgst_dt as rgst_dt
,replace(replace(t1.lmt_kind_cd,chr(13),''),chr(10),'') as lmt_kind_cd
,replace(replace(t1.public_crdt_flg,chr(13),''),chr(10),'') as public_crdt_flg
,replace(replace(t1.usage_descb,chr(13),''),chr(10),'') as usage_descb
,replace(replace(t1.other_cond_descb,chr(13),''),chr(10),'') as other_cond_descb
,replace(replace(t1.gm_cust_id,chr(13),''),chr(10),'') as gm_cust_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_crdt_lmt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_crdt_lmt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes