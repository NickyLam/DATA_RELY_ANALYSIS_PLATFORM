: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_corp_time_dpst_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_corp_time_dpst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.marg_acct_flg,chr(13),''),chr(10),'') as marg_acct_flg
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.draw_mode_cd,chr(13),''),chr(10),'') as draw_mode_cd
,replace(replace(t1.auto_redep_flg,chr(13),''),chr(10),'') as auto_redep_flg
,replace(replace(t1.cntn_dpst_type_cd,chr(13),''),chr(10),'') as cntn_dpst_type_cd
,t1.cntn_dpst_dt as cntn_dpst_dt
,t1.norm_rate as norm_rate
,t1.ovdue_rate as ovdue_rate
,t1.part_rdrw_rate as part_rdrw_rate
,t1.part_rdrw_amt as part_rdrw_amt
,t1.part_rdrw_dt as part_rdrw_dt
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,t1.etl_task_name as etl_task_name
,t1.exce_acr_intr as exce_acr_intr
,t1.exce_day_acr_intr as exce_day_acr_intr
,t1.early_can_drw_dt as early_can_drw_dt
,replace(replace(t1.dpst_typ_cd,chr(13),''),chr(10),'') as dpst_typ_cd
,replace(replace(t1.dpst_agt_id,chr(13),''),chr(10),'') as dpst_agt_id
,t1.pay_int_amt as pay_int_amt
,t1.pay_int_dt as pay_int_dt
from ${idl_schema}.hdws_dul_d_rpts_agt_corp_time_dpst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_corp_time_dpst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes