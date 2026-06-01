: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_liab_layered_int_rat_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ref_liab_layered_int_rat_para.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.liab_int_rat_id,chr(13),''),chr(10),'') as liab_int_rat_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.int_rat_id,chr(13),''),chr(10),'') as int_rat_id
,replace(replace(t.int_rat_name,chr(13),''),chr(10),'') as int_rat_name
,replace(replace(t.int_rat_dep_term_cd,chr(13),''),chr(10),'') as int_rat_dep_term_cd
,replace(replace(t.acct_dep_term_cd,chr(13),''),chr(10),'') as acct_dep_term_cd
,replace(replace(t.int_rat_level,chr(13),''),chr(10),'') as int_rat_level
,replace(replace(t.layered_way_cd,chr(13),''),chr(10),'') as layered_way_cd
,t.effect_dt as effect_dt
,t.base_rat as base_rat
,replace(replace(t.float_type_cd,chr(13),''),chr(10),'') as float_type_cd
,t.flo_val as flo_val
,t.actl_int_rat as actl_int_rat
,replace(replace(t.int_rat_update_scp_flg,chr(13),''),chr(10),'') as int_rat_update_scp_flg
,replace(replace(t.acct_int_rat_chg_flg,chr(13),''),chr(10),'') as acct_int_rat_chg_flg
,replace(replace(t.para_int_rat_chg_flg,chr(13),''),chr(10),'') as para_int_rat_chg_flg
,replace(replace(t.int_rat_file_way_cd,chr(13),''),chr(10),'') as int_rat_file_way_cd
,replace(replace(t.matn_teller_id,chr(13),''),chr(10),'') as matn_teller_id
,t.matn_dt as matn_dt
,replace(replace(t.matn_org_id,chr(13),''),chr(10),'') as matn_org_id
,replace(replace(t.matn_tm,chr(13),''),chr(10),'') as matn_tm
,t.tm_stamp as tm_stamp
,replace(replace(t.rec_status_cd,chr(13),''),chr(10),'') as rec_status_cd
,t.dep_term_days as dep_term_days
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.ref_liab_layered_int_rat_para t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_liab_layered_int_rat_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes