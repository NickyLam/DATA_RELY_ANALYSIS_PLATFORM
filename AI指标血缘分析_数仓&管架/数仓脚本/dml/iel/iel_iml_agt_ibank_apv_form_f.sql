: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_ibank_apv_form_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_ibank_apv_form.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.apv_form_num,chr(13),''),chr(10),'') as apv_form_num
,entr_tm
,replace(replace(t1.apv_status_cd,chr(13),''),chr(10),'') as apv_status_cd
,apv_lmt
,actl_ocup_lmt
,surp_aval_lmt
,effect_dt
,invalid_dt
,apv_vp_cnt
,replace(replace(t1.incremt_lmt_flg,chr(13),''),chr(10),'') as incremt_lmt_flg
,replace(replace(t1.apver_id,chr(13),''),chr(10),'') as apver_id
,replace(replace(t1.apver_name,chr(13),''),chr(10),'') as apver_name
,replace(replace(t1.rela_muti_tran_flg,chr(13),''),chr(10),'') as rela_muti_tran_flg
,wrtoff_lmt
,replace(replace(t1.apv_form_type_cd,chr(13),''),chr(10),'') as apv_form_type_cd
,replace(replace(t1.entr_bs_dir_cd,chr(13),''),chr(10),'') as entr_bs_dir_cd
,replace(replace(t1.entr_asset_type_cd,chr(13),''),chr(10),'') as entr_asset_type_cd
,replace(replace(t1.entr_asset_market_type_cd,chr(13),''),chr(10),'') as entr_asset_market_type_cd
,replace(replace(t1.entr_portf_unit_id,chr(13),''),chr(10),'') as entr_portf_unit_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,entr_yld_rat
,entr_price
,distrtd_lmt
,not_distrt_lmt
,termnt_lmt
,execed_lmt
,not_exec_lmt
,replace(replace(t1.tran_seq_num,chr(13),''),chr(10),'') as tran_seq_num
,surp_apv_lmt
,replace(replace(t1.ext_status_cd,chr(13),''),chr(10),'') as ext_status_cd
,replace(replace(t1.task_step_seq_num,chr(13),''),chr(10),'') as task_step_seq_num
,replace(replace(t1.revo_rtn_flg_cd,chr(13),''),chr(10),'') as revo_rtn_flg_cd
,surp_quot_lmt
,replace(replace(t1.rela_apv_form_num,chr(13),''),chr(10),'') as rela_apv_form_num
,replace(replace(t1.cm_attr_flg,chr(13),''),chr(10),'') as cm_attr_flg
,replace(replace(t1.rela_attr_flg,chr(13),''),chr(10),'') as rela_attr_flg
,replace(replace(t1.up_down_cd,chr(13),''),chr(10),'') as up_down_cd
,replace(replace(t1.match_mode_cd,chr(13),''),chr(10),'') as match_mode_cd
,create_dt
,update_dt

from ${iml_schema}.agt_ibank_apv_form t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_ibank_apv_form.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
