: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cap_acct_ety_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cap_acct_ety.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.entry_id,chr(13),''),chr(10),'') as entry_id
,replace(replace(t1.dept_id,chr(13),''),chr(10),'') as dept_id
,replace(replace(t1.acct_b_id,chr(13),''),chr(10),'') as acct_b_id
,t1.stl_dt as stl_dt
,replace(replace(t1.in_bs_off_bs_cd,chr(13),''),chr(10),'') as in_bs_off_bs_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,t1.entry_amt as entry_amt
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.subj_descb,chr(13),''),chr(10),'') as subj_descb
,replace(replace(t1.entry_grouping_id,chr(13),''),chr(10),'') as entry_grouping_id
,replace(replace(t1.revs_entry_id,chr(13),''),chr(10),'') as revs_entry_id
,replace(replace(t1.entry_def_id,chr(13),''),chr(10),'') as entry_def_id
,replace(replace(t1.strk_bal_entry_flg,chr(13),''),chr(10),'') as strk_bal_entry_flg
from ${iml_schema}.evt_cap_acct_ety t1
where t1.etl_dt <= to_date('20230430','yyyymmdd') and t1.etl_dt >= to_date('20230101','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cap_acct_ety.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes