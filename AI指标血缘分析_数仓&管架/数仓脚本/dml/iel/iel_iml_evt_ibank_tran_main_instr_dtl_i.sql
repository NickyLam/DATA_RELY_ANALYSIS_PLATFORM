: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_tran_main_instr_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ibank_tran_main_instr_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t.parent_fin_instm_market_type_id,chr(13),''),chr(10),'') as parent_fin_instm_market_type_id
,replace(replace(t.parent_fin_instm_asset_type_id,chr(13),''),chr(10),'') as parent_fin_instm_asset_type_id
,replace(replace(t.parent_fin_instm_id,chr(13),''),chr(10),'') as parent_fin_instm_id
,replace(replace(t.parent_instr_id,chr(13),''),chr(10),'') as parent_instr_id
,replace(replace(t.intnal_tran_flow_num,chr(13),''),chr(10),'') as intnal_tran_flow_num
,replace(replace(t.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,t.theory_clear_dt as theory_clear_dt
,t.actl_stl_dt as actl_stl_dt
,replace(replace(t.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t.apv_form_id,chr(13),''),chr(10),'') as apv_form_id
,replace(replace(t.ext_bag_id,chr(13),''),chr(10),'') as ext_bag_id
,replace(replace(t.exec_market_id,chr(13),''),chr(10),'') as exec_market_id
,t.theory_stl_dt as theory_stl_dt
,replace(replace(t.cap_instr_id,chr(13),''),chr(10),'') as cap_instr_id
,replace(replace(t.vch_instr_id,chr(13),''),chr(10),'') as vch_instr_id
,t.effect_tm as effect_tm
,replace(replace(t.mender_name,chr(13),''),chr(10),'') as mender_name
,replace(replace(t.mender_id,chr(13),''),chr(10),'') as mender_id
,replace(replace(t.instr_status_cd,chr(13),''),chr(10),'') as instr_status_cd
,replace(replace(t.not_price_flg,chr(13),''),chr(10),'') as not_price_flg
,replace(replace(t.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,t.tran_dt as tran_dt
,replace(replace(t.stl_type_cd,chr(13),''),chr(10),'') as stl_type_cd
,replace(replace(t.clear_cmplt_flg,chr(13),''),chr(10),'') as clear_cmplt_flg
,replace(replace(t.surviv_term_instr_flg,chr(13),''),chr(10),'') as surviv_term_instr_flg
,replace(replace(t.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t.operr_name,chr(13),''),chr(10),'') as operr_name
,to_date(${batch_date},'yyyymmdd') as start_dt
,to_date(${batch_date},'yyyymmdd') as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iml.evt_ibank_tran_main_instr_dtl t  where t.start_dt <= to_date(${batch_date},'yyyymmdd') and t.end_dt >= to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_tran_main_instr_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes