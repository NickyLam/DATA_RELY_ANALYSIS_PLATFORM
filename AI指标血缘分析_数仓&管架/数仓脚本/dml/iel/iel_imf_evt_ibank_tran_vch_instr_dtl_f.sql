: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_ibank_tran_vch_instr_dtl_f
CreateDate: 20230804
FileName:   ${iel_data_path}/evt_ibank_tran_vch_instr_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.secu_instr_seq_num,chr(13),''),chr(10),'') as secu_instr_seq_num
,replace(replace(t1.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t1.ext_vch_acct_id,chr(13),''),chr(10),'') as ext_vch_acct_id
,replace(replace(t1.intnal_vch_acct_id,chr(13),''),chr(10),'') as intnal_vch_acct_id
,replace(replace(t1.fin_instm_id,chr(13),''),chr(10),'') as fin_instm_id
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name
,replace(replace(t1.asset_type_id,chr(13),''),chr(10),'') as asset_type_id
,replace(replace(t1.market_type_id,chr(13),''),chr(10),'') as market_type_id
,replace(replace(t1.merge_acpt_pay_id,chr(13),''),chr(10),'') as merge_acpt_pay_id
,replace(replace(t1.cap_flow_dir_cd,chr(13),''),chr(10),'') as cap_flow_dir_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,fee_cost_chg
,acru_int_cost_chg
,actl_acru_int
,actl_net_price_amt
,recvbl_uncol_int
,recvbl_uncol_pric
,pl_fee
,replace(replace(t1.int_recvbl_resv_flg,chr(13),''),chr(10),'') as int_recvbl_resv_flg
,replace(replace(t1.recvbl_pric_resv_flg,chr(13),''),chr(10),'') as recvbl_pric_resv_flg
,bal_qtty_chg
,froz_qtty
,calc_closing_dt
,stl_dt
,actl_stl_dt
,replace(replace(t1.prod_cls_name,chr(13),''),chr(10),'') as prod_cls_name
,full_price_cost_chg
,replace(replace(t1.ghb_zzd_trust_acct_num,chr(13),''),chr(10),'') as ghb_zzd_trust_acct_num
,replace(replace(t1.cntpty_zzd_trust_acct_num,chr(13),''),chr(10),'') as cntpty_zzd_trust_acct_num
,effect_tm
,stl_denom
,replace(replace(t1.accti_tran_flow_num,chr(13),''),chr(10),'') as accti_tran_flow_num
,theory_fee
,fee_cost
,replace(replace(t1.accti_impam_obj_flg,chr(13),''),chr(10),'') as accti_impam_obj_flg
,start_int_accr_dt
,expect_qtty
,expect_denom
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_ibank_tran_vch_instr_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_tran_vch_instr_dtl.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
