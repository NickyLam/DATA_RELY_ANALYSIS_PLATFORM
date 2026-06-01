: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_indv_time_dpst_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_indv_time_dpst_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,t1.etl_dt as st_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.marg_acct_flg,chr(13),''),chr(10),'') as marg_acct_flg
,t1.part_rdrw_amt as part_rdrw_amt
,replace(replace(t1.auto_redep_flg,chr(13),''),chr(10),'') as auto_redep_flg
,replace(replace(t1.redep_type_cd,chr(13),''),chr(10),'') as redep_type_cd
,t1.redep_dt as redep_dt
,t1.has_redep_cnt as has_redep_cnt
,t1.each_shd_dep_drw_amt as each_shd_dep_drw_amt
,t1.deft_amt as deft_amt
,t1.has_pre_predpst_cnt as has_pre_predpst_cnt
,t1.has_supp_frsave_cnt as has_supp_frsave_cnt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t1.etl_dt+1 as end_dt
,NVL2(t1.data_src_cd,'AGT_INDV_TIME_DPST_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_INDV_TIME_DPST_INFO_H') as etl_task_name 
,t1.part_rdrw_rate as part_rdrw_rate
,t1.part_rdrw_dt as part_rdrw_dt
,t1.adv_drw_expt_yld as adv_drw_expt_yld
,t1.exce_acr_intr as exce_acr_intr
,t1.exce_day_acr_intr as exce_day_acr_intr
,t1.pay_int_amt as pay_int_amt
,t1.pay_int_dt as pay_int_dt
from ${idl_schema}.hdws_iml_agt_indv_time_dpst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_indv_time_dpst_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes