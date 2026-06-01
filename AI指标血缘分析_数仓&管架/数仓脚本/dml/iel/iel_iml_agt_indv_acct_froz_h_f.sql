: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_indv_acct_froz_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_indv_acct_froz_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.acct_froz_rec_id,chr(13),''),chr(10),'') as acct_froz_rec_id
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
    ,t.froz_amt as froz_amt
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.auth_tm as auth_tm
    ,t.acct_froz_start_tm as acct_froz_start_tm
    ,t.acct_froz_end_tm as acct_froz_end_tm
    ,replace(replace(t.froz_rec_type_cd,chr(13),''),chr(10),'') as froz_rec_type_cd
    ,replace(replace(t.froz_stop_pay_type_cd,chr(13),''),chr(10),'') as froz_stop_pay_type_cd
    ,replace(replace(t.init_froz_id,chr(13),''),chr(10),'') as init_froz_id
    ,replace(replace(t.src_intior_sys_id,chr(13),''),chr(10),'') as src_intior_sys_id
    ,replace(replace(t.caller_sys_id,chr(13),''),chr(10),'') as caller_sys_id
    ,replace(replace(t.payment_flow_num,chr(13),''),chr(10),'') as payment_flow_num
    ,t.create_tm as create_tm
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_indv_acct_froz_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_indv_acct_froz_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes