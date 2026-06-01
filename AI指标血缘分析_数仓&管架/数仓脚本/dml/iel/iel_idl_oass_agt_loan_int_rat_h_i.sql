: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_loan_int_rat_h_i
CreateDate: 20230116
FileName:   ${iel_data_path}/oass_agt_loan_int_rat_h.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.loan_num as loan_num
,t1.int_cls_cd as int_cls_cd
,t1.cust_id as cust_id
,t1.int_set_freq_cd as int_set_freq_cd
,t1.next_int_set_dt as next_int_set_dt
,t1.int_set_day as int_set_day
,t1.int_rat_type_cd as int_rat_type_cd
,t1.bank_int_int_rat as bank_int_int_rat
,t1.float_int_rat as float_int_rat
,t1.float_int_rat_point as float_int_rat_point
,t1.float_int_rat_ratio as float_int_rat_ratio
,t1.sub_acct_fix_int_rat as sub_acct_fix_int_rat
,t1.sub_acct_int_rat_float_point as sub_acct_int_rat_float_point
,t1.sub_acct_int_rat_float_ratio as sub_acct_int_rat_float_ratio
,t1.exec_int_rat as exec_int_rat
,t1.year_int_accr_base_cd as year_int_accr_base_cd
,t1.mon_int_accr_base_cd as mon_int_accr_base_cd
,t1.int_accr_base_cd as int_accr_base_cd
,t1.int_accr_flg as int_accr_flg
,t1.int_rat_start_use_way_cd as int_rat_start_use_way_cd
,t1.int_rat_effect_way_cd as int_rat_effect_way_cd
,t1.next_int_rat_modif_dt as next_int_rat_modif_dt
,t1.int_rat_modif_ped_cd as int_rat_modif_ped_cd
,t1.int_rat_modif_day as int_rat_modif_day
,t1.int_accr_begin_dt as int_accr_begin_dt
,t1.int_accr_exp_dt as int_accr_exp_dt
,t1.lowt_exec_int_rat as lowt_exec_int_rat
,t1.higt_exec_int_rat as higt_exec_int_rat
,t1.cap_flg as cap_flg
,t1.pnlt_int_rat_use_way_cd as pnlt_int_rat_use_way_cd
,t1.accrd_nomal_int_rat_float_flg as accrd_nomal_int_rat_float_flg
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_loan_int_rat_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_loan_int_rat_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
