: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_cap_stl_instr_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_ibank_cap_stl_instr_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.cap_instr_seq_num,chr(13),''),chr(10),'') as cap_instr_seq_num
,replace(replace(t.main_instr_seq_num,chr(13),''),chr(10),'') as main_instr_seq_num
,replace(replace(t.level2_cap_acct_id,chr(13),''),chr(10),'') as level2_cap_acct_id
,replace(replace(t.level1_cap_acct_id,chr(13),''),chr(10),'') as level1_cap_acct_id
,replace(replace(t.cap_flow_dir_cd,chr(13),''),chr(10),'') as cap_flow_dir_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.chg_qtty as chg_qtty
,t.froz_qtty as froz_qtty
,t.stl_dt as stl_dt
,t.actl_stl_dt as actl_stl_dt
,replace(replace(t.tran_way_cd,chr(13),''),chr(10),'') as tran_way_cd
,replace(replace(t.ghb_bank_acct_num,chr(13),''),chr(10),'') as ghb_bank_acct_num
,replace(replace(t.ghb_bank_acct_name,chr(13),''),chr(10),'') as ghb_bank_acct_name
,replace(replace(t.ghb_open_bank_num,chr(13),''),chr(10),'') as ghb_open_bank_num
,replace(replace(t.ghb_open_bank_name,chr(13),''),chr(10),'') as ghb_open_bank_name
,replace(replace(t.cntpty_bank_no,chr(13),''),chr(10),'') as cntpty_bank_no
,replace(replace(t.cntpty_bank_acct_num,chr(13),''),chr(10),'') as cntpty_bank_acct_num
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.cntpty_open_bank_num,chr(13),''),chr(10),'') as cntpty_open_bank_num
,replace(replace(t.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,t.oper_tm as oper_tm
,replace(replace(t.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,to_date(${batch_date},'yyyymmdd') as start_dt
,to_date(${batch_date},'yyyymmdd') as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iml.evt_ibank_cap_stl_instr_dtl t  where t.start_dt <= to_date(${batch_date},'yyyymmdd') and t.end_dt >= to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_cap_stl_instr_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes