: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_entry_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_entry.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.etl_dt as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.entry_id,chr(13),''),chr(10),'') as entry_id
,replace(replace(t1.belong_hq_bank_no,chr(13),''),chr(10),'') as belong_hq_bank_no
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.entry_tran_id,chr(13),''),chr(10),'') as entry_tran_id
,replace(replace(t1.tran_attr_string,chr(13),''),chr(10),'') as tran_attr_string
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.batch_id,chr(13),''),chr(10),'') as batch_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.dtl_id,chr(13),''),chr(10),'') as dtl_id
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,t1.fac_val_amt as fac_val_amt
,t1.entry_seq_num as entry_seq_num
,replace(replace(t1.get_val_field,chr(13),''),chr(10),'') as get_val_field
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.prtcptr_role_cd,chr(13),''),chr(10),'') as prtcptr_role_cd
,t1.prtcptr_amt as prtcptr_amt
,replace(replace(t1.entry_flg,chr(13),''),chr(10),'') as entry_flg
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.target_acct_num,chr(13),''),chr(10),'') as target_acct_num
,replace(replace(t1.prtcptr_acct_type_cd,chr(13),''),chr(10),'') as prtcptr_acct_type_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.prtcptr_type_cd,chr(13),''),chr(10),'') as prtcptr_type_cd
,replace(replace(t1.prtcptr_ext,chr(13),''),chr(10),'') as prtcptr_ext
,t1.ext_amt_1 as ext_amt_1
,t1.ext_amt_2 as ext_amt_2
,t1.ext_amt_3 as ext_amt_3
,replace(replace(t1.batch_entry_flg,chr(13),''),chr(10),'') as batch_entry_flg
,replace(replace(t1.dtl_status_flg,chr(13),''),chr(10),'') as dtl_status_flg
,t1.create_tm as create_tm
,t1.update_tm as update_tm
,replace(replace(t1.final_modif_operr_id,chr(13),''),chr(10),'') as final_modif_operr_id
,replace(replace(t1.sys_id,chr(13),''),chr(10),'') as sys_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.init_bill_sys_rgst_cter_id,chr(13),''),chr(10),'') as init_bill_sys_rgst_cter_id
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name
,replace(replace(t1.h_data_flg,chr(13),''),chr(10),'') as h_data_flg 
from ${iml_schema}.evt_entry t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_entry.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes