: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_corp_curr_dpst_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_corp_curr_dpst_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,t1.etl_dt as st_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.base_deposit_acct_flg,chr(13),''),chr(10),'') as base_deposit_acct_flg
,replace(replace(t1.seg_int_flg,chr(13),''),chr(10),'') as seg_int_flg
,replace(replace(t1.marg_acct_flg,chr(13),''),chr(10),'') as marg_acct_flg
,replace(replace(t1.capital_verifi_typ_cd,chr(13),''),chr(10),'') as capital_verifi_typ_cd
,replace(replace(t1.capital_verifi_resu_cd,chr(13),''),chr(10),'') as capital_verifi_resu_cd
,replace(replace(t1.int_freq_cd,chr(13),''),chr(10),'') as int_freq_cd
,replace(replace(t1.agt_dpst_flg,chr(13),''),chr(10),'') as agt_dpst_flg
,t1.agt_dpst_rate as agt_dpst_rate
,t1.agt_dpst_bal as agt_dpst_bal
,replace(replace(t1.draw_mode_cd,chr(13),''),chr(10),'') as draw_mode_cd
,replace(replace(t1.setl_typ_cd,chr(13),''),chr(10),'') as setl_typ_cd
,replace(replace(t1.apprv_flg,chr(13),''),chr(10),'') as apprv_flg
,t1.check_dt as check_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t1.etl_dt+1 as end_dt
,NVL2(t1.data_src_cd,'AGT_CORP_CURR_DPST_INFO_H'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_CORP_CURR_DPST_INFO_H') as etl_task_name 
,t1.agt_dpst_due_dt as agt_dpst_due_dt
from ${idl_schema}.hdws_iml_agt_corp_curr_dpst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')
  and del_flg <> '1';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_corp_curr_dpst_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes