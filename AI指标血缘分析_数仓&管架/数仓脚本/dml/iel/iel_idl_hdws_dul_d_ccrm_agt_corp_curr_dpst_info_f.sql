: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_corp_curr_dpst_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_corp_curr_dpst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 t.dpst_acct_id
,t.etl_dt
,t.prd_id
,t.dps_type_cd
,t.base_deposit_acct_flg
,t.seg_int_flg
,t.marg_acct_flg
,t.capital_verifi_typ_cd
,t.capital_verifi_resu_cd
,t.int_freq_cd
,t.agt_dpst_flg
,t.agt_dpst_rate
,t.agt_dpst_bal
,t.draw_mode_cd
,t.setl_typ_cd
,t.apprv_flg
,t.check_dt
,t.data_src_cd
,t.del_flg
,t.last_update_dt
,t.etl_task_name
,t.agt_dpst_due_dt
from idl.hdws_dul_d_ccrm_agt_corp_curr_dpst_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_corp_curr_dpst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes