: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_agree_dep_int_rat_seg_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/agt_agree_dep_int_rat_seg_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.fee_rat_id,chr(13),''),chr(10),'') as fee_rat_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,sub_acct_fix_int_rat
,sub_acct_int_rat_float_ratio
,sub_acct_int_rat_float_point
,seg_calc_start_dt
,seg_ped
,replace(replace(t1.seg_ped_type_cd,chr(13),''),chr(10),'') as seg_ped_type_cd
,bus_start_dt
,bus_end_dt
,provi_days
,provi_amt
,file_amt
,replace(replace(t1.int_cls_cd,chr(13),''),chr(10),'') as int_cls_cd
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,exec_int_rat
,bank_int_int_rat
,float_int_rat
,replace(replace(t1.mon_int_accr_base_cd,chr(13),''),chr(10),'') as mon_int_accr_base_cd
,replace(replace(t1.year_int_accr_base_cd,chr(13),''),chr(10),'') as year_int_accr_base_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd

from ${iml_schema}.agt_agree_dep_int_rat_seg_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_agree_dep_int_rat_seg_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
