: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_ibank_dep_acct_info_f
CreateDate: 20240729
FileName:   ${iel_data_path}/cmm_ibank_dep_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.cust_sub_acct_num,chr(13),''),chr(10),'') as cust_sub_acct_num
,replace(replace(t1.open_bank_no,chr(13),''),chr(10),'') as open_bank_no
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t1.dep_term_tenor_type_cd,chr(13),''),chr(10),'') as dep_term_tenor_type_cd
,dep_term_days
,replace(replace(t1.seg_int_accr_flg,chr(13),''),chr(10),'') as seg_int_accr_flg
,last_int_set_dt
,next_int_set_dt
,exec_int_rat
,nomal_int_rat
,ovdue_int_rat
,part_unexp_draw_int_rat
,part_unexp_draw_surp_int_rat
,replace(replace(t1.advd_wdraw_flg,chr(13),''),chr(10),'') as advd_wdraw_flg
,earliest_advd_wdraw_dt
,replace(replace(t1.onl_bus_flg,chr(13),''),chr(10),'') as onl_bus_flg

from ${icl_schema}.cmm_ibank_dep_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ibank_dep_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
