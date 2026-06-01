: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_am_prod_subj_bal_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_am_prod_subj_bal_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.sob_id,chr(13),''),chr(10),'') as sob_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.src_prod_id,chr(13),''),chr(10),'') as src_prod_id
,replace(replace(t.super_subj_id,chr(13),''),chr(10),'') as super_subj_id
,replace(replace(t.subj_level_cd,chr(13),''),chr(10),'') as subj_level_cd
,replace(replace(t.bal_dir_cd,chr(13),''),chr(10),'') as bal_dir_cd
,replace(replace(t.oc_curr_cd,chr(13),''),chr(10),'') as oc_curr_cd
,t.oc_bal as oc_bal
,replace(replace(t.dc_curr_cd,chr(13),''),chr(10),'') as dc_curr_cd
,t.dc_bal as dc_bal
,replace(replace(t.noth_subor_subj_flg,chr(13),''),chr(10),'') as noth_subor_subj_flg
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.fin_am_prod_subj_bal_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_am_prod_subj_bal_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes