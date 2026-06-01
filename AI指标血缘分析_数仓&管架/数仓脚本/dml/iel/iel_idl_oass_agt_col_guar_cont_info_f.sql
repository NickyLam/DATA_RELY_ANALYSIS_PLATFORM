: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_agt_col_guar_cont_info_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_agt_col_guar_cont_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.guar_amt as guar_amt
,t1.guar_amt_convt_cny as guar_amt_convt_cny
,t1.guar_cont_id as guar_cont_id
,t1.guar_cont_type_cd as guar_cont_type_cd
,t1.guartor_id as guartor_id
,t1.guartor_type_cd as guartor_type_cd
,t1.guartor_rg_num as guartor_rg_num
,t1.strip_line_cd as strip_line_cd
,t1.cont_type_cd as cont_type_cd
,t1.setup_dt as setup_dt
,t1.setup_ps_id as setup_ps_id
,t1.guar_curr_cd as guar_curr_cd
,t1.guartor_rating as guartor_rating
,t1.data_src_cd as data_src_cd
,t1.effect_flg as effect_flg
,t1.exp_day as exp_day
,t1.exp_status_cd as exp_status_cd
,t1.higt_pm_cont_flg as higt_pm_cont_flg
,t1.mender_id as mender_id
,t1.modif_dt as modif_dt
,t1.begin_day as begin_day
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.agt_id as agt_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_agt_col_guar_cont_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_agt_col_guar_cont_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
