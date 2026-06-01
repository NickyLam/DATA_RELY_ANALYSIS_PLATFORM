: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_newly_dep_int_set_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_newly_dep_int_set_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.group_seq_num as group_seq_num
,t.int_qtty as int_qtty
,t.sub_seq_num as sub_seq_num
,replace(replace(t.liab_acct_num,chr(13),''),chr(10),'') as liab_acct_num
,replace(replace(t.int_code_name,chr(13),''),chr(10),'') as int_code_name
,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t.acct_curr_cd,chr(13),''),chr(10),'') as acct_curr_cd
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prod_cls_cd_1,chr(13),''),chr(10),'') as prod_cls_cd_1
,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t.cust_acct_num,chr(13),''),chr(10),'') as cust_acct_num
,t.int_accr_begin_dt as int_accr_begin_dt
,t.int_accr_termnt_dt as int_accr_termnt_dt
,replace(replace(t.base_provi_int_rat_id,chr(13),''),chr(10),'') as base_provi_int_rat_id
,t.int_rat_level as int_rat_level
,replace(replace(t.levl_int_rat_id,chr(13),''),chr(10),'') as levl_int_rat_id
,replace(replace(t.int_rat_file_flg,chr(13),''),chr(10),'') as int_rat_file_flg
,replace(replace(t.int_rat_float_type_cd,chr(13),''),chr(10),'') as int_rat_float_type_cd
,t.int_rat_flo_val as int_rat_flo_val
,t.base_rat as base_rat
,t.curr_exec_int_rat as curr_exec_int_rat
,t.int_rat_effect_dt as int_rat_effect_dt
,t.provi_tax_rat as provi_tax_rat
,t.base_int_happ_amt as base_int_happ_amt
,t.actl_int_happ_amt as actl_int_happ_amt
,t.int_tax_happ_amt as int_tax_happ_amt
,t.level_int_accr_bal as level_int_accr_bal
,t.tot_accum_int_lmt as tot_accum_int_lmt
,t.accum as accum
,replace(replace(t.int_rat_layered_way_cd,chr(13),''),chr(10),'') as int_rat_layered_way_cd
,replace(replace(t.int_accr_rule_cd,chr(13),''),chr(10),'') as int_accr_rule_cd
,replace(replace(t.entry_flg,chr(13),''),chr(10),'') as entry_flg
,t.last_int_set_dt as last_int_set_dt
,replace(replace(t.intnal_tran_code,chr(13),''),chr(10),'') as intnal_tran_code
,replace(replace(t.ext_tran_code,chr(13),''),chr(10),'') as ext_tran_code
,t.tran_dt as tran_dt
,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t.bus_org_id,chr(13),''),chr(10),'') as bus_org_id
,replace(replace(t.teller_flow_num,chr(13),''),chr(10),'') as teller_flow_num
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_newly_dep_int_set_dtl t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_newly_dep_int_set_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes