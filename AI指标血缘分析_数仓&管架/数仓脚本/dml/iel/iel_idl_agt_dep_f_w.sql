: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_dep_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_dep_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t.etl_dt
,t.agt_id
,t.lp_id
,t.cont_id
,t.acct_id
,t.sub_acct_id
,t.col_int_acct_id
,t.col_int_acct_sub_acct_num
,t.col_int_acct_name
,t.sign_dt
,t.close_dt
,t.fir_float_dt
,t.value_dt
,t.nomal_int_rat
,t.pa_ext_int_rat
,t.higt_int_rat
,t.lowt_int_rat
,t.int_set_ped_cd
,t.in_int_dt_cd
,t.init_int_accr_method_cd
,t.int_accr_method_cd
,t.float_ped
,t.float_ped_corp_cd
,t.int_set_ped
,t.int_set_ped_corp_cd
,t.nomal_int_rat_float_way_cd
,t.nomal_fix_int_rat
,t.nomal_int_rat_flo_val
,t.ovdue_int_rat_float_way_cd
,t.ovdue_fix_int_rat
,t.ovdue_int_rat_flo_val
,t.unexp_draw_float_way_cd
,t.unexp_draw_fix_int_rat
,t.unexp_draw_flo_val
,t.agt_amt
,t.status_cd
,t.agt_start_dt
,t.agt_end_dt
,t.create_dt
,t.update_dt
,t.id_mark
,t.job_cd
from ${idl_schema}.agt_dep t 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_dep_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes