: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_tran_vch_instr_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ibank_tran_vch_instr_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.secu_instr_seq_num,chr(13),''),chr(10),'') as secu_instr_seq_num
,replace(replace(t.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t.ext_vch_acct_id,chr(13),''),chr(10),'') as ext_vch_acct_id
,replace(replace(t.intnal_vch_acct_id,chr(13),''),chr(10),'') as intnal_vch_acct_id
,replace(replace(t.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name
,replace(replace(t.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t.cap_flow_dir_cd,chr(13),''),chr(10),'') as cap_flow_dir_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.fee_cost_chg as fee_cost_chg
,t.acru_int_cost_chg as acru_int_cost_chg
,t.actl_acru_int as actl_acru_int
,t.actl_net_price_amt as actl_net_price_amt
,t.recvbl_uncol_int as recvbl_uncol_int
,t.recvbl_uncol_pric as recvbl_uncol_pric
,t.pl_fee as pl_fee
,replace(replace(t.int_recvbl_resv_flg,chr(13),''),chr(10),'') as int_recvbl_resv_flg
,replace(replace(t.recvbl_pric_resv_flg,chr(13),''),chr(10),'') as recvbl_pric_resv_flg
,t.bal_qtty_chg as bal_qtty_chg
,t.froz_qtty as froz_qtty
,t.calc_closing_dt as calc_closing_dt
,t.stl_dt as stl_dt
,t.actl_stl_dt as actl_stl_dt
,replace(replace(t.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
,t.full_price_cost_chg as full_price_cost_chg
,replace(replace(t.ghb_zzd_trust_acct_num,chr(13),''),chr(10),'') as ghb_zzd_trust_acct_num
,replace(replace(t.cntpty_zzd_trust_acct_num,chr(13),''),chr(10),'') as cntpty_zzd_trust_acct_num
,t.effect_tm as effect_tm
,t.stl_denom as stl_denom
,replace(replace(t.accti_tran_flow_num,chr(13),''),chr(10),'') as accti_tran_flow_num
,t.theory_fee as theory_fee
,t.fee_cost as fee_cost
,replace(replace(t.accti_impam_obj_flg,chr(13),''),chr(10),'') as accti_impam_obj_flg
,t.start_int_accr_dt as start_int_accr_dt
,t.expect_qtty as expect_qtty
,t.expect_denom as expect_denom
,replace(replace(t.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,to_date(${batch_date},'yyyymmdd') as start_dt
,to_date(${batch_date},'yyyymmdd') as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iml.evt_ibank_tran_vch_instr_dtl t  where t.start_dt <= to_date(${batch_date},'yyyymmdd') and t.end_dt >= to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_tran_vch_instr_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes