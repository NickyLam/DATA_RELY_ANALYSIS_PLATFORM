: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_ibank_acct_ety_evt_i
CreateDate: 20230109
FileName:   ${iel_data_path}/evt_ibank_acct_ety_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.vouch_id,chr(13),''),chr(10),'') as vouch_id
,replace(replace(t1.task_id,chr(13),''),chr(10),'') as task_id
,vouch_dt
,replace(replace(t1.entry_flow_num,chr(13),''),chr(10),'') as entry_flow_num
,replace(replace(t1.chg_id,chr(13),''),chr(10),'') as chg_id
,replace(replace(t1.instr_id,chr(13),''),chr(10),'') as instr_id
,replace(replace(t1.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t1.entry_org_id,chr(13),''),chr(10),'') as entry_org_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.intnal_acct_seq_num,chr(13),''),chr(10),'') as intnal_acct_seq_num
,replace(replace(t1.core_acct_id,chr(13),''),chr(10),'') as core_acct_id
,replace(replace(t1.entry_type_cd,chr(13),''),chr(10),'') as entry_type_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.rbw_flg_cd,chr(13),''),chr(10),'') as rbw_flg_cd
,replace(replace(t1.suspd_wrtoff_way_cd,chr(13),''),chr(10),'') as suspd_wrtoff_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,entry_amt
,replace(replace(t1.sys_status_cd,chr(13),''),chr(10),'') as sys_status_cd
,replace(replace(t1.send_core_acct_flg,chr(13),''),chr(10),'') as send_core_acct_flg
,replace(replace(t1.accti_type_cd,chr(13),''),chr(10),'') as accti_type_cd
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.core_acct_name,chr(13),''),chr(10),'') as core_acct_name
,replace(replace(t1.merge_flow_num,chr(13),''),chr(10),'') as merge_flow_num
,replace(replace(t1.accti_obj_id,chr(13),''),chr(10),'') as accti_obj_id
,replace(replace(t1.chg_type_cd,chr(13),''),chr(10),'') as chg_type_cd
,replace(replace(t1.dtl_flg,chr(13),''),chr(10),'') as dtl_flg
,replace(replace(t1.src_data_type_cd,chr(13),''),chr(10),'') as src_data_type_cd
,replace(replace(t1.send_accti_status_cd,chr(13),''),chr(10),'') as send_accti_status_cd
,replace(replace(t1.manual_vouch_flg,chr(13),''),chr(10),'') as manual_vouch_flg
,tax_fee
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.free_tax_id,chr(13),''),chr(10),'') as free_tax_id

from ${iml_schema}.evt_ibank_acct_ety_evt t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_ibank_acct_ety_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
