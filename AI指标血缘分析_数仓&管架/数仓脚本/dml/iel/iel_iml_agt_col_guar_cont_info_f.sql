: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_col_guar_cont_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_col_guar_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,t.guar_amt as guar_amt
    ,t.guar_amt_convt_cny as guar_amt_convt_cny
    ,replace(replace(t.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
    ,replace(replace(t.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
    ,replace(replace(t.guartor_id,chr(13),''),chr(10),'') as guartor_id
    ,replace(replace(t.guartor_type_cd,chr(13),''),chr(10),'') as guartor_type_cd
    ,replace(replace(t.guartor_rg_num,chr(13),''),chr(10),'') as guartor_rg_num
    ,replace(replace(t.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
    ,replace(replace(t.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
    ,t.setup_dt as setup_dt
    ,replace(replace(t.setup_ps_id,chr(13),''),chr(10),'') as setup_ps_id
    ,replace(replace(t.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
    ,replace(replace(t.guartor_rating,chr(13),''),chr(10),'') as guartor_rating
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.effect_flg,chr(13),''),chr(10),'') as effect_flg
    ,t.exp_day as exp_day
    ,replace(replace(t.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
    ,replace(replace(t.higt_pm_cont_flg,chr(13),''),chr(10),'') as higt_pm_cont_flg
    ,replace(replace(t.mender_id,chr(13),''),chr(10),'') as mender_id
    ,t.modif_dt as modif_dt
    ,t.begin_day as begin_day
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.agt_col_guar_cont_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_guar_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes