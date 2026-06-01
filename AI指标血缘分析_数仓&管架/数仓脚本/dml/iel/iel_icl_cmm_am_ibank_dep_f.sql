: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_am_ibank_dep_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_am_ibank_dep.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.bus_id,chr(13),''),chr(10),'') as bus_id
,replace(replace(t1.am_prod_id,chr(13),''),chr(10),'') as am_prod_id
,replace(replace(t1.am_prod_name,chr(13),''),chr(10),'') as am_prod_name
,replace(replace(t1.cntpty_id,chr(13),''),chr(10),'') as cntpty_id
,replace(replace(t1.cntpty_name,chr(13),''),chr(10),'') as cntpty_name
,replace(replace(t1.indus_type_cd,chr(13),''),chr(10),'') as indus_type_cd
,replace(replace(t1.cntpty_type_id,chr(13),''),chr(10),'') as cntpty_type_id
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,int_rat_float_point
,replace(replace(t1.base_rat_id,chr(13),''),chr(10),'') as base_rat_id
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,pay_int_freq
,int_rat_reset_freq
,replace(replace(t1.holiday_rule_cd,chr(13),''),chr(10),'') as holiday_rule_cd
,tran_dt
,value_dt
,exp_dt
,exec_int_rat
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,exp_amt
,acru_int
,currt_bal
,td_acru_int
,currt_acru_int
,replace(replace(t1.dealer_id,chr(13),''),chr(10),'') as dealer_id
,replace(replace(t1.cntpty_dealer_id,chr(13),''),chr(10),'') as cntpty_dealer_id
,replace(replace(t1.onl_tran_flg,chr(13),''),chr(10),'') as onl_tran_flg
,replace(replace(t1.bag_id,chr(13),''),chr(10),'') as bag_id
,replace(replace(t1.tran_id,chr(13),''),chr(10),'') as tran_id

from ${icl_schema}.cmm_am_ibank_dep t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_am_ibank_dep.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
