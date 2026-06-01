: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_loan_cont_lmt_attach_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_loan_cont_lmt_attach_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,lmt_next_bus_higt_pm_rat
,lmt_next_bus_init_margin_ratio
,lmt_next_bus_int_rat_lowt_flo_val
,lmt_next_bus_sig_max_amt
,lmt_next_bus_lont_tenor
,lmt_next_bus_delay_renew_tenor
,lmt_under_bus_latest_exp_dt
,lmt_invalid_dt
,replace(replace(t1.fin_cont_flg,chr(13),''),chr(10),'') as fin_cont_flg
,replace(replace(t1.public_crdt_flg,chr(13),''),chr(10),'') as public_crdt_flg
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t1.crdt_bus_flow_type_cd,chr(13),''),chr(10),'') as crdt_bus_flow_type_cd
,replace(replace(t1.lmt_dir_use_flg,chr(13),''),chr(10),'') as lmt_dir_use_flg
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.lmt_kind_cd,chr(13),''),chr(10),'') as lmt_kind_cd
,replace(replace(t1.group_lmt_crtl_mode_cd,chr(13),''),chr(10),'') as group_lmt_crtl_mode_cd
,replace(replace(t1.under_bus_curr_cd_range,chr(13),''),chr(10),'') as under_bus_curr_cd_range
,lmt_nmal_amt
,lmt_open_amt
,used_nmal_amt
,used_open_amt
,aval_nmal_amt
,aval_open_amt
,syn_loan_tot_amt
,replace(replace(t1.major_loan_cls_cd,chr(13),''),chr(10),'') as major_loan_cls_cd
,replace(replace(t1.risk_expose_cls,chr(13),''),chr(10),'') as risk_expose_cls
,replace(replace(t1.invo_estate_fin_flg,chr(13),''),chr(10),'') as invo_estate_fin_flg
,replace(replace(t1.invo_gover_class_fin_flg,chr(13),''),chr(10),'') as invo_gover_class_fin_flg
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t1.col_turn_margin_acct_id,chr(13),''),chr(10),'') as col_turn_margin_acct_id
,replace(replace(t1.lmt_use_cond_descb,chr(13),''),chr(10),'') as lmt_use_cond_descb
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg
,replace(replace(t1.prtcptr_way_cd,chr(13),''),chr(10),'') as prtcptr_way_cd
,onl_lmt
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,replace(replace(t1.distr_org_id,chr(13),''),chr(10),'') as distr_org_id

from ${iml_schema}.agt_loan_cont_lmt_attach_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_cont_lmt_attach_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
