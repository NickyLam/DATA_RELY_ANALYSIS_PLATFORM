: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_guar_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_guar_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
guar_contr_id
,agt_modf
,etl_dt
,last_update_dt
,guar_contr_typ_cd
,guar_mode_cd
,pty_id
,issue_dt
,eff_dt
,trmi_dt
,due_dt
,issue_org_id
,mgmt_org_id
,pty_mgr_id
,sign_oprt_id
,ccy_cd
,guar_amt
,guar_contr_stats_cd
,guar_term_corp
,guar_term
,reg_dt
,upda_dt
,upda_pers_id
,data_src_cd
from ${idl_schema}.hdws_dul_d_rpts_agt_guar_contr_info
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_guar_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes