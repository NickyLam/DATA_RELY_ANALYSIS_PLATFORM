: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_loan_tran_instr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_loan_tran_instr.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.tran_dt as tran_dt
,replace(replace(t.instr_flow_num,chr(13),''),chr(10),'') as instr_flow_num
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.accting_code,chr(13),''),chr(10),'') as accting_code
,replace(replace(t.bal_compnt_type_cd,chr(13),''),chr(10),'') as bal_compnt_type_cd
,replace(replace(t.bal_seq_num,chr(13),''),chr(10),'') as bal_seq_num
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.tran_amt as tran_amt
,replace(replace(t.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t.gl_post_flg,chr(13),''),chr(10),'') as gl_post_flg
 from iml.evt_corp_loan_tran_instr t 
 where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_loan_tran_instr.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes