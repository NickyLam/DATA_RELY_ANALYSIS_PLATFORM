: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_col_guar_cont_info_f
CreateDate: 20250210
FileName:   ${iel_data_path}/agt_col_guar_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,guar_amt
,guar_amt_convt_cny
,replace(replace(t1.guar_cont_id,chr(13),''),chr(10),'') as guar_cont_id
,replace(replace(t1.guar_cont_type_cd,chr(13),''),chr(10),'') as guar_cont_type_cd
,replace(replace(t1.guartor_id,chr(13),''),chr(10),'') as guartor_id
,replace(replace(t1.guartor_type_cd,chr(13),''),chr(10),'') as guartor_type_cd
,replace(replace(t1.guartor_rg_num,chr(13),''),chr(10),'') as guartor_rg_num
,replace(replace(t1.strip_line_cd,chr(13),''),chr(10),'') as strip_line_cd
,replace(replace(t1.cont_type_cd,chr(13),''),chr(10),'') as cont_type_cd
,setup_dt
,replace(replace(t1.setup_ps_id,chr(13),''),chr(10),'') as setup_ps_id
,replace(replace(t1.guar_curr_cd,chr(13),''),chr(10),'') as guar_curr_cd
,replace(replace(t1.guartor_rating,chr(13),''),chr(10),'') as guartor_rating
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.effect_flg,chr(13),''),chr(10),'') as effect_flg
,exp_day
,replace(replace(t1.exp_status_cd,chr(13),''),chr(10),'') as exp_status_cd
,replace(replace(t1.higt_pm_cont_flg,chr(13),''),chr(10),'') as higt_pm_cont_flg
,replace(replace(t1.mender_id,chr(13),''),chr(10),'') as mender_id
,modif_dt
,begin_day
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.agt_col_guar_cont_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_guar_cont_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
