: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_tran_instr_dtl_a
CreateDate: 20230602
FileName:   ${iel_data_path}/cmm_ibank_tran_instr_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,instr_seq_num
,parent_instr_seq_num
,replace(replace(t1.ext_instr_seq_num,chr(13),''),chr(10),'') as ext_instr_seq_num
,rela_cap_instr_seq_num
,rela_vch_instr_seq_num
,rela_main_instr_seq_num
,actl_accti_main_seq_num
,adj_entry_main_seq_num
,replace(replace(t1.intnal_tran_flow_num,chr(13),''),chr(10),'') as intnal_tran_flow_num
,replace(replace(t1.obj_id,chr(13),''),chr(10),'') as obj_id
,replace(replace(t1.instr_bus_type_cd,chr(13),''),chr(10),'') as instr_bus_type_cd
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id
,replace(replace(t1.intnal_cap_acct_id,chr(13),''),chr(10),'') as intnal_cap_acct_id
,replace(replace(t1.parent_instm_market_type_id,chr(13),''),chr(10),'') as parent_instm_market_type_id
,replace(replace(t1.parent_instm_asset_type_id,chr(13),''),chr(10),'') as parent_instm_asset_type_id
,replace(replace(t1.parent_fin_instm_id,chr(13),''),chr(10),'') as parent_fin_instm_id
,replace(replace(t1.instr_type_cd,chr(13),''),chr(10),'') as instr_type_cd
,instr_status_cd
,replace(replace(t1.acpt_pay_instr_cd,chr(13),''),chr(10),'') as acpt_pay_instr_cd
,replace(replace(t1.tran_bus_type_cd,chr(13),''),chr(10),'') as tran_bus_type_cd
,replace(replace(t1.stl_way_cd,chr(13),''),chr(10),'') as stl_way_cd
,replace(replace(t1.stl_type_cd,chr(13),''),chr(10),'') as stl_type_cd
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,replace(replace(t1.actl_rp_flg,chr(13),''),chr(10),'') as actl_rp_flg
,replace(replace(t1.clear_flow_flg,chr(13),''),chr(10),'') as clear_flow_flg
,replace(replace(t1.surviv_term_flg,chr(13),''),chr(10),'') as surviv_term_flg
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.exec_market_id,chr(13),''),chr(10),'') as exec_market_id
,replace(replace(t1.memo_info,chr(13),''),chr(10),'') as memo_info
,theory_clear_dt
,theory_stl_dt
,actl_stl_dt
,tran_dt
,cfm_dt
,repay_dt
,replace(replace(t1.final_mender_id,chr(13),''),chr(10),'') as final_mender_id
,replace(replace(t1.final_mender_name,chr(13),''),chr(10),'') as final_mender_name
,replace(replace(t1.checker_id,chr(13),''),chr(10),'') as checker_id
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,acru_int
,pric_bal
,recvbl_uncol_int
,recvbl_uncol_pric
,chg_qtty

from ${icl_schema}.cmm_ibank_tran_instr_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_tran_instr_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
