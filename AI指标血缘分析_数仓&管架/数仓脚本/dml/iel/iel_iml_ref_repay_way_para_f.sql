: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_repay_way_para_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_repay_way_para.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.repay_way_cd,chr(13),''),chr(10),'') as repay_way_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.repay_way_descb,chr(13),''),chr(10),'') as repay_way_descb
,replace(replace(t1.pric_int_proc_way_cd,chr(13),''),chr(10),'') as pric_int_proc_way_cd
,replace(replace(t1.fst_term_flg,chr(13),''),chr(10),'') as fst_term_flg
,replace(replace(t1.pric_repay_type_cd,chr(13),''),chr(10),'') as pric_repay_type_cd
,replace(replace(t1.calc_formu,chr(13),''),chr(10),'') as calc_formu
,replace(replace(t1.acpt_pay_idf_cd,chr(13),''),chr(10),'') as acpt_pay_idf_cd
,term_end_merge_days
,replace(replace(t1.term_end_merge_type_cd,chr(13),''),chr(10),'') as term_end_merge_type_cd

from ${iml_schema}.ref_repay_way_para t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_repay_way_para.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
