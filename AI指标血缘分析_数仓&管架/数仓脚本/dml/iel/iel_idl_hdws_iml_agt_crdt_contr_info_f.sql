: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_crdt_contr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_crdt_contr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.crdt_contr_id
,t.etl_dt
,t.ctr_txt_name
,t.pty_id
,t.prd_id
,t.issue_dt
,t.eff_dt
,t.trmi_dt
,t.due_dt
,t.issue_org_id
,t.mgmt_org_id
,t.accting_org_id
,t.crdt_emply_id
,t.crdt_type_cd
,t.crdt_biz_breed_cd
,t.crdt_contr_status_cd
,t.ccy_cd
,t.syn_crdt_total_lmt
,t.crdt_lmt_wrt_off_eff_dt
,t.crdt_lmt_wrt_off_rsns
,t.usab_lmt
,t.occu_lmt
,t.crdt_contr_frz_flg
,t.crdt_contr_frz_amt
,t.circ_flg
,t.crdt_status_cd
,t.temp_lmt_flg
,t.csld_crdt_flg
,t.on_flg
,t.grp_crdt_lmt_flg
,t.assoc_appl_id
,t.occur_typ_cd
,t.guar_total_val
,t.guar_rate
,t.guar_mode_cd
,t.assoc_aprv_id
,t.expos_usab_lmt
,t.data_src_cd
,t.auth_seq_num
,t.crdt_flow_typ_cd
from idl.hdws_iml_agt_crdt_contr_info t
where ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'))" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_crdt_contr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes