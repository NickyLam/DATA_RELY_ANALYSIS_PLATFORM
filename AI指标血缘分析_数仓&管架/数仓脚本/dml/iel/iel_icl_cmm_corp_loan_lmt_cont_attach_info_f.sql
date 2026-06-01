: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_corp_loan_lmt_cont_attach_info_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_corp_loan_lmt_cont_attach_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.col_turn_margin_acct_num,chr(13),''),chr(10),'') as col_turn_margin_acct_num
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.lmt_kind_cd,chr(13),''),chr(10),'') as lmt_kind_cd
,replace(replace(t1.group_lmt_ctrl_mode_cd,chr(13),''),chr(10),'') as group_lmt_ctrl_mode_cd
,replace(replace(t1.major_loan_cls_cd,chr(13),''),chr(10),'') as major_loan_cls_cd
,replace(replace(t1.prtcpt_way_cd,chr(13),''),chr(10),'') as prtcpt_way_cd
,replace(replace(t1.crdt_rg_cd,chr(13),''),chr(10),'') as crdt_rg_cd
,replace(replace(t1.invest_way_cd,chr(13),''),chr(10),'') as invest_way_cd
,replace(replace(t1.risk_expose_cls,chr(13),''),chr(10),'') as risk_expose_cls
,replace(replace(t1.public_crdt_flg,chr(13),''),chr(10),'') as public_crdt_flg
,replace(replace(t1.fin_sys_cont_flg,chr(13),''),chr(10),'') as fin_sys_cont_flg
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg
,replace(replace(t1.estate_fin_flg,chr(13),''),chr(10),'') as estate_fin_flg
,replace(replace(t1.invo_gover_class_fin_flg1,chr(13),''),chr(10),'') as invo_gover_class_fin_flg1
,replace(replace(t1.consm_serv_class_fin_flg,chr(13),''),chr(10),'') as consm_serv_class_fin_flg
,replace(replace(t1.br_build_ifin_flg,chr(13),''),chr(10),'') as br_build_ifin_flg
,replace(replace(t1.green_crdt_fin_flg,chr(13),''),chr(10),'') as green_crdt_fin_flg
,replace(replace(t1.class_crdt_flg,chr(13),''),chr(10),'') as class_crdt_flg
,replace(replace(t1.distr_org_id,chr(13),''),chr(10),'') as distr_org_id
,lmt_invalid_dt
,lmt_under_bus_latest_exp_dt
,lmt_next_bus_higt_pm_rat
,lmt_next_bus_init_margin_ratio
,lmt_next_bus_int_rat_lowt_flo_val
,lmt_next_bus_sig_max_amt
,lmt_next_bus_lont_tenor
,lmt_next_bus_ext_tenor
,replace(replace(t1.bus_curr_range,chr(13),''),chr(10),'') as bus_curr_range
,replace(replace(t1.lmt_use_cond_descb,chr(13),''),chr(10),'') as lmt_use_cond_descb
,syn_loan_tot_amt
,onl_lmt
,stat_use_open_bal
,lmt_nmal_amt
,lmt_open_amt
,used_nmal_amt
,used_open_amt
,aval_nmal_amt
,aval_open_amt
,lower_ocup_up_level_crdt_open_amt
,lower_ocup_up_level_crdt_nmal_amt
,replace(replace(t1.lmt_id,chr(13),''),chr(10),'') as lmt_id
,replace(replace(t1.lmt_under_sellbl_prod_id,chr(13),''),chr(10),'') as lmt_under_sellbl_prod_id
,replace(replace(t1.passer_id,chr(13),''),chr(10),'') as passer_id
,replace(replace(t1.passer_name,chr(13),''),chr(10),'') as passer_name

from ${icl_schema}.cmm_corp_loan_lmt_cont_attach_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_corp_loan_lmt_cont_attach_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
