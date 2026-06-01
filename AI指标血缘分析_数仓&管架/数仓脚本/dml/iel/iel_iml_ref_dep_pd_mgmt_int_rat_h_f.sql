: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_ref_dep_pd_mgmt_int_rat_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/ref_dep_pd_mgmt_int_rat_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seq_num,chr(13),''),chr(10),'') as seq_num
,replace(replace(t1.pd_cd,chr(13),''),chr(10),'') as pd_cd
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,bank_int_int_rat
,float_int_rat
,replace(replace(t1.int_rat_adj_way_cd,chr(13),''),chr(10),'') as int_rat_adj_way_cd
,exec_int_rat
,replace(replace(t1.evt_cate_id,chr(13),''),chr(10),'') as evt_cate_id
,replace(replace(t1.int_rat_type_cd,chr(13),''),chr(10),'') as int_rat_type_cd
,replace(replace(t1.cds_issue_year,chr(13),''),chr(10),'') as cds_issue_year
,replace(replace(t1.pd_prod_cate_cd,chr(13),''),chr(10),'') as pd_prod_cate_cd

from ${iml_schema}.ref_dep_pd_mgmt_int_rat_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ref_dep_pd_mgmt_int_rat_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
