: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_col_guar_cont_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_col_guar_cont_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t.etl_dt as etl_dt 
,t.agt_id as agt_id
,t.lp_id as lp_id
,t.guar_amt as guar_amt
,t.guar_amt_convt_cny as guar_amt_convt_cny
,t.guar_cont_id as guar_cont_id
,t.guar_cont_type_cd as guar_cont_type_cd
,t.guartor_id as guartor_id
,t.guartor_type_cd as guartor_type_cd
,t.guartor_rg_num as guartor_rg_num
,t.strip_line_cd as strip_line_cd
,t.cont_type_cd as cont_type_cd
,t.setup_dt as setup_dt
,t.setup_ps_id as setup_ps_id
,t.guar_curr_cd as guar_curr_cd
,t.guartor_rating as guartor_rating
,t.data_src_cd as data_src_cd
,t.effect_flg as effect_flg
,t.exp_day as exp_day
,t.exp_status_cd as exp_status_cd
,t.higt_pm_cont_flg as higt_pm_cont_flg
,t.mender_id as mender_id
,t.modif_dt as modif_dt
,t.begin_day as begin_day
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,t.id_mark as id_mark 
,t.job_cd
from ${idl_schema}.agt_col_guar_cont_info t 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6)
and etl_dt=to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_col_guar_cont_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes