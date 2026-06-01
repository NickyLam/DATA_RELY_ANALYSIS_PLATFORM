: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_cap_stl_instr_dtl_f
CreateDate: 20250415
FileName:   ${iel_data_path}/evt_ibank_cap_stl_instr_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cap_instr_seq_num,chr(13),''),chr(10),'') as cap_instr_seq_num
,replace(replace(t1.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t1.level2_cap_acct_id,chr(13),''),chr(10),'') as level2_cap_acct_id
,replace(replace(t1.level1_cap_acct_id,chr(13),''),chr(10),'') as level1_cap_acct_id
,replace(replace(t1.cap_flow_dir_cd,chr(13),''),chr(10),'') as cap_flow_dir_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,chg_qtty
,froz_qtty
,stl_dt
,actl_stl_dt
,replace(replace(t1.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,replace(replace(t1.ghb_bank_acct_num,chr(13),''),chr(10),'') as ghb_bank_acct_num
,replace(replace(t1.ghb_bank_acct_name,chr(13),''),chr(10),'') as ghb_bank_acct_name
,replace(replace(t1.ghb_open_bank_num,chr(13),''),chr(10),'') as ghb_open_bank_num
,replace(replace(t1.ghb_open_bank_name,chr(13),''),chr(10),'') as ghb_open_bank_name
,replace(replace(t1.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t1.cntpty_bank_acct_num,chr(13),''),chr(10),'') as cntpty_bank_acct_num
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_open_bank_num,chr(13),''),chr(10),'') as cntpty_open_bank_num
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,oper_tm
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.merge_acpt_pay_id,chr(13),''),chr(10),'') as merge_acpt_pay_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_ibank_cap_stl_instr_dtl t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_cap_stl_instr_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
