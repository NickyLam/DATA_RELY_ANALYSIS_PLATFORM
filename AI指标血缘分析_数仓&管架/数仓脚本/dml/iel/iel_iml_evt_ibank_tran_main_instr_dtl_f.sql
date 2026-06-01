: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_tran_main_instr_dtl_f
CreateDate: 20230804
FileName:   ${iel_data_path}/evt_ibank_tran_main_instr_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t1.instr_type_cd,chr(13),''),chr(10),'') as instr_type_cd
,replace(replace(t1.parent_fin_instm_market_type_id,chr(13),''),chr(10),'') as parent_fin_instm_market_type_id
,replace(replace(t1.parent_fin_instm_asset_type_id,chr(13),''),chr(10),'') as parent_fin_instm_asset_type_id
,replace(replace(t1.parent_fin_instm_id,chr(13),''),chr(10),'') as parent_fin_instm_id
,replace(replace(t1.parent_instr_id,chr(13),''),chr(10),'') as parent_instr_id
,replace(replace(t1.intnal_tran_flow_num,chr(13),''),chr(10),'') as intnal_tran_flow_num
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,theory_clear_dt
,actl_stl_dt
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.apv_form_id,chr(13),''),chr(10),'') as apv_form_id
,replace(replace(t1.ext_bag_id,chr(13),''),chr(10),'') as ext_bag_id
,replace(replace(t1.exec_market_id,chr(13),''),chr(10),'') as exec_market_id
,theory_stl_dt
,replace(replace(t1.cap_instr_id,chr(13),''),chr(10),'') as cap_instr_id
,replace(replace(t1.vch_instr_id,chr(13),''),chr(10),'') as vch_instr_id
,effect_tm
,replace(replace(t1.mender_name,chr(13),''),chr(10),'') as mender_name
,replace(replace(t1.mender_id,chr(13),''),chr(10),'') as mender_id
,replace(replace(t1.instr_status_cd,chr(13),''),chr(10),'') as instr_status_cd
,replace(replace(t1.not_price_flg,chr(13),''),chr(10),'') as not_price_flg
,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,tran_dt
,replace(replace(t1.stl_type_cd,chr(13),''),chr(10),'') as stl_type_cd
,replace(replace(t1.clear_cmplt_flg,chr(13),''),chr(10),'') as clear_cmplt_flg
,replace(replace(t1.surviv_term_instr_flg,chr(13),''),chr(10),'') as surviv_term_instr_flg
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name

from ${iml_schema}.evt_ibank_tran_main_instr_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_tran_main_instr_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
