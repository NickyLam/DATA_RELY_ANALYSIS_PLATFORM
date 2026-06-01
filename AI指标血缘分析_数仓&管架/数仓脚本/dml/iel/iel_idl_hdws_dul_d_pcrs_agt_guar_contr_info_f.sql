: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_pcrs_agt_guar_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_pcrs_agt_guar_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.guar_contr_id,chr(13),''),chr(10),'') as guar_contr_id
,t1.etl_dt as etl_dt
,replace(replace(t1.guar_contr_typ_cd,chr(13),''),chr(10),'') as guar_contr_typ_cd
,replace(replace(t1.guar_mode_cd,chr(13),''),chr(10),'') as guar_mode_cd
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,t1.issue_dt as issue_dt
,t1.eff_dt as eff_dt
,t1.trmi_dt as trmi_dt
,t1.due_dt as due_dt
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.pty_mgr_id,chr(13),''),chr(10),'') as pty_mgr_id
,replace(replace(t1.sign_oprt_id,chr(13),''),chr(10),'') as sign_oprt_id
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.guar_amt as guar_amt
,replace(replace(t1.guar_contr_stats_cd,chr(13),''),chr(10),'') as guar_contr_stats_cd
,replace(replace(t1.guar_term_corp,chr(13),''),chr(10),'') as guar_term_corp
,t1.guar_term as guar_term
,t1.reg_dt as reg_dt
,t1.upda_dt as upda_dt
,replace(replace(t1.upda_pers_id,chr(13),''),chr(10),'') as upda_pers_id
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
from ${idl_schema}.hdws_dul_d_pcrs_agt_guar_contr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_pcrs_agt_guar_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes