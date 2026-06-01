: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_retl_loan_renew_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_retl_loan_renew_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.renew_seq_num,chr(13),''),chr(10),'') as renew_seq_num
    ,replace(replace(t.dubil_id,chr(13),''),chr(10),'') as dubil_id
    ,replace(replace(t.renew_cont_id,chr(13),''),chr(10),'') as renew_cont_id
    ,t.renew_dt as renew_dt
    ,t.renew_exp_day as renew_exp_day
    ,t.renew_amt as renew_amt
    ,replace(replace(t.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
    ,t.exec_int_rat as exec_int_rat
    ,replace(replace(t.int_rat_adj_type_cd,chr(13),''),chr(10),'') as int_rat_adj_type_cd
    ,replace(replace(t.src_int_rat_adj_ped_cd,chr(13),''),chr(10),'') as src_int_rat_adj_ped_cd
    ,replace(replace(t.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd
    ,replace(replace(t.int_rat_adj_ped_freq,chr(13),''),chr(10),'') as int_rat_adj_ped_freq
    ,replace(replace(t.int_rat_adj_day,chr(13),''),chr(10),'') as int_rat_adj_day
    ,replace(replace(t.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd
    ,t.int_rat_flo_val as int_rat_flo_val
    ,replace(replace(t.loan_renew_status_cd,chr(13),''),chr(10),'') as loan_renew_status_cd
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_retl_loan_renew_h t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_retl_loan_renew_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes