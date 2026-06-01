: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_ccrm_agt_crdt_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_ccrm_agt_crdt_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
       replace(replace(crdt_contr_id,chr(10),''),chr(13),'') as crdt_contr_id
      ,etl_dt
      ,replace(replace(ctr_txt_name,chr(10),''),chr(13),'') as ctr_txt_name
      ,replace(replace(pty_id,chr(10),''),chr(13),'') as pty_id
      ,replace(replace(prd_id,chr(10),''),chr(13),'') as prd_id
      ,issue_dt
      ,aprv_dt
      ,eff_dt
      ,trmi_dt
      ,due_dt
      ,replace(replace(issue_org_id,chr(10),''),chr(13),'') as issue_org_id
      ,replace(replace(mgmt_org_id,chr(10),''),chr(13),'') as mgmt_org_id
      ,replace(replace(accting_org_id,chr(10),''),chr(13),'') as accting_org_id
      ,replace(replace(crdt_emply_id,chr(10),''),chr(13),'') as crdt_emply_id
      ,replace(replace(crdt_type_cd,chr(10),''),chr(13),'') as crdt_type_cd
      ,replace(replace(crdt_biz_breed_cd,chr(10),''),chr(13),'') as crdt_biz_breed_cd
      ,replace(replace(crdt_contr_status_cd,chr(10),''),chr(13),'') as crdt_contr_status_cd
      ,replace(replace(ccy_cd,chr(10),''),chr(13),'') as ccy_cd
      ,syn_crdt_total_lmt
      ,crdt_lmt_wrt_off_eff_dt
      ,replace(replace(crdt_lmt_wrt_off_rsns,chr(10),''),chr(13),'') as crdt_lmt_wrt_off_rsns
      ,usab_lmt
      ,fin_expos
      ,occu_lmt
      ,replace(replace(crdt_contr_frz_flg,chr(10),''),chr(13),'') as crdt_contr_frz_flg
      ,crdt_contr_frz_amt
      ,replace(replace(circ_flg,chr(10),''),chr(13),'') as circ_flg
      ,replace(replace(crdt_status_cd,chr(10),''),chr(13),'') as crdt_status_cd
      ,replace(replace(temp_lmt_flg,chr(10),''),chr(13),'') as temp_lmt_flg
      ,replace(replace(csld_crdt_flg,chr(10),''),chr(13),'') as csld_crdt_flg
      ,replace(replace(on_flg,chr(10),''),chr(13),'') as on_flg
      ,replace(replace(grp_crdt_lmt_flg,chr(10),''),chr(13),'') as grp_crdt_lmt_flg
      ,replace(replace(assoc_appl_id,chr(10),''),chr(13),'') as assoc_appl_id
      ,replace(replace(occur_typ_cd,chr(10),''),chr(13),'') as occur_typ_cd
      ,guar_total_val
      ,guar_rate
      ,replace(replace(guar_mode_cd,chr(10),''),chr(13),'') as guar_mode_cd
      ,replace(replace(assoc_aprv_id,chr(10),''),chr(13),'') as assoc_aprv_id
      ,replace(replace(data_src_cd,chr(10),''),chr(13),'') as data_src_cd
      ,replace(replace(del_flg,chr(10),''),chr(13),'') as del_flg
      ,replace(replace(crdt_flow_typ_cd,chr(10),''),chr(13),'') as crdt_flow_typ_cd 
from idl.hdws_dul_d_ccrm_agt_crdt_contr_info 
where to_date(${batch_date},'yyyymmdd') = etl_dt;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_ccrm_agt_crdt_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes