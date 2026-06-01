: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_corp_curr_dpst_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_corp_curr_dpst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(dpst_acct_id,chr(10),''),chr(13),'') as dpst_acct_id
      ,etl_dt
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,replace(replace(dps_type_cd,chr(10),''),chr(13),'') as dps_type_cd
      ,replace(replace(base_deposit_acct_flg,chr(10),''),chr(13),'') as base_deposit_acct_flg
      ,replace(replace(seg_int_flg,chr(10),''),chr(13),'') as seg_int_flg
      ,replace(replace(marg_acct_flg,chr(10),''),chr(13),'') as marg_acct_flg
      ,replace(replace(capital_verifi_typ_cd,chr(10),''),chr(13),'') as capital_verifi_typ_cd
      ,replace(replace(capital_verifi_resu_cd,chr(10),''),chr(13),'') as capital_verifi_resu_cd
      ,replace(replace(int_freq_cd,chr(10),''),chr(13),'') as int_freq_cd
      ,replace(replace(agt_dpst_flg,chr(10),''),chr(13),'') as agt_dpst_flg
      ,agt_dpst_rate
      ,agt_dpst_bal
      ,replace(replace(draw_mode_cd,chr(10),''),chr(13),'') as draw_mode_cd
      ,replace(replace(setl_typ_cd,chr(10),''),chr(13),'') as setl_typ_cd
      ,replace(replace(apprv_flg,chr(10),''),chr(13),'') as apprv_flg
      ,check_dt
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,last_update_dt
      ,replace(replace(etl_task_name,chr(10),''),chr(13),'') as etl_task_name
      ,agt_dpst_due_dt 
from idl.hdws_dul_d_rpts_agt_corp_curr_dpst_info 
where to_char(etl_dt,'yyyymmdd') = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_corp_curr_dpst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes