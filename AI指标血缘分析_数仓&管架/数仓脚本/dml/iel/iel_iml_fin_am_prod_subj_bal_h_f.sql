: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_prod_subj_bal_h_f
CreateDate: 20221013
FileName:   ${iel_data_path}/fin_am_prod_subj_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.src_prod_id,chr(13),''),chr(10),'') as src_prod_id
,replace(replace(t1.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t1.subj_level_cd,chr(13),''),chr(10),'') as subj_level_cd
,replace(replace(t1.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t1.oc_curr_cd,chr(13),''),chr(10),'') as oc_curr_cd
,t1.oc_bal as oc_bal
,replace(replace(t1.dc_curr_cd,chr(13),''),chr(10),'') as dc_curr_cd
,t1.dc_bal as dc_bal
,replace(replace(t1.noth_subor_subj_flg,chr(13),''),chr(10),'') as noth_subor_subj_flg
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name

from ${iml_schema}.fin_am_prod_subj_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_prod_subj_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
