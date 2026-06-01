: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_crdt_contr_info_01_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_crdt_contr_info_01.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(t1.crdt_contr_id,chr(10),''),chr(13),'') as crdt_contr_id
      ,t1.etl_dt as etl_dt
      ,replace(replace(t1.ctr_txt_name,chr(10),''),chr(13),'') as ctr_txt_name
      ,replace(replace(t1.pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(t1.prd_id,chr(10),''),chr(13),'') as prd_id
      ,t1.issue_dt as issue_dt
      ,t1.eff_dt as eff_dt
      ,t1.trmi_dt as trmi_dt
      ,t1.due_dt as due_dt
      ,replace(replace(t1.issue_org_id,chr(10),''),chr(13),'') as issue_org_id
      ,replace(replace(t1.mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(t1.accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(t1.crdt_emply_id,chr(10),''),chr(13),'') as crdt_emply_id
      ,replace(replace(t1.crdt_type_cd,chr(10),''),chr(13),'') as crdt_type_cd
      ,replace(replace(t1.crdt_biz_breed_cd,chr(10),''),chr(13),'') as crdt_biz_breed_cd
      ,replace(replace(t1.crdt_contr_status_cd,chr(10),''),chr(13),'') as crdt_contr_status_cd
      ,replace(replace(t1.ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,t1.syn_crdt_total_lmt as syn_crdt_total_lmt
      ,t1.crdt_lmt_wrt_off_eff_dt as crdt_lmt_wrt_off_eff_dt
      ,replace(replace(t1.crdt_lmt_wrt_off_rsns,chr(10),''),chr(13),'') as crdt_lmt_wrt_off_rsns
      ,t1.usab_lmt as usab_lmt
      ,t1.occu_lmt as occu_lmt
      ,replace(replace(t1.crdt_contr_frz_flg,chr(10),''),chr(13),'') as crdt_contr_frz_flg
      ,t1.crdt_contr_frz_amt as crdt_contr_frz_amt
      ,replace(replace(t1.circ_flg,chr(10),''),chr(13),'') as circ_flg
      ,replace(replace(t1.crdt_status_cd,chr(10),''),chr(13),'') as crdt_status_cd
      ,replace(replace(t1.temp_lmt_flg,chr(10),''),chr(13),'') as temp_lmt_flg
      ,replace(replace(t1.csld_crdt_flg,chr(10),''),chr(13),'') as csld_crdt_flg
      ,replace(replace(t1.on_flg,chr(10),''),chr(13),'') as on_flg
      ,replace(replace(t1.grp_crdt_lmt_flg,chr(10),''),chr(13),'') as grp_crdt_lmt_flg
      ,replace(replace(t1.assoc_appl_id,chr(10),''),chr(13),'') as assoc_appl_id
      ,replace(replace(t1.occur_typ_cd,chr(10),''),chr(13),'') as occur_typ_cd
      ,t1.guar_total_val as guar_total_val
      ,t1.guar_rate as guar_rate
      ,replace(replace(t1.guar_mode_cd,chr(10),''),chr(13),'') as guar_mode_cd
      ,replace(replace(t1.assoc_aprv_id,chr(10),''),chr(13),'') as assoc_aprv_id
      ,replace(replace(t1.data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(t1.del_flg,chr(10),''),chr(13),'') as del_flg 
from idl.hdws_dul_d_rpts_agt_crdt_contr_info_01 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_crdt_contr_info_01.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes