: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_auto_redt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_auto_redt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.redt_agt_id,chr(13),''),chr(10),'') as redt_agt_id
,replace(replace(t.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t.redt_acct_id,chr(13),''),chr(10),'') as redt_acct_id
,replace(replace(t.tot_sub_acct_id,chr(13),''),chr(10),'') as tot_sub_acct_id
,replace(replace(t.trdpty_col_int_flg,chr(13),''),chr(10),'') as trdpty_col_int_flg
,replace(replace(t.trdpty_in_int_acct_id,chr(13),''),chr(10),'') as trdpty_in_int_acct_id
,replace(replace(t.vouch_type_cd,chr(13),''),chr(10),'') as vouch_type_cd
,t.lowt_redt_amt as lowt_redt_amt
,t.apot_rise_turn_amt as apot_rise_turn_amt
,t.base_mult_lmt as base_mult_lmt
,t.reg_acct_retnd_amt as reg_acct_retnd_amt
,replace(replace(t.redt_type_cd,chr(13),''),chr(10),'') as redt_type_cd
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
,replace(replace(t.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t.redt_ped_type_cd,chr(13),''),chr(10),'') as redt_ped_type_cd
,t.redt_start_dt as redt_start_dt
,t.redt_closing_dt as redt_closing_dt
,t.next_redt_day as next_redt_day
,t.rels_dt as rels_dt
,replace(replace(t.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg
,t.invalid_tshold as invalid_tshold
,replace(replace(t.invalid_flg,chr(13),''),chr(10),'') as invalid_flg
,t.acm_redt_amt as acm_redt_amt
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_auto_redt t
where t.create_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_auto_redt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes