: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_dacct_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_dacct_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acct_num,chr(13),''),chr(10),'') as acct_num
,t1.etl_dt as etl_dt
,replace(replace(t1.acct_typ_cd,chr(13),''),chr(10),'') as acct_typ_cd
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.blng_pty_id,chr(13),''),chr(10),'') as blng_pty_id
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.colse_org_id,chr(13),''),chr(10),'') as colse_org_id
,replace(replace(t1.open_teller_id,chr(13),''),chr(10),'') as open_teller_id
,replace(replace(t1.colse_teller_id,chr(13),''),chr(10),'') as colse_teller_id
,t1.open_dt as open_dt
,replace(replace(t1.open_tm,chr(13),''),chr(10),'') as open_tm
,t1.colse_dt as colse_dt
,replace(replace(t1.corp_dep_flg,chr(13),''),chr(10),'') as corp_dep_flg
,replace(replace(t1.non_activ_flg,chr(13),''),chr(10),'') as non_activ_flg
,replace(replace(t1.private_acct_flg,chr(13),''),chr(10),'') as private_acct_flg
,replace(replace(t1.dacct_acct_frz_flg,chr(13),''),chr(10),'') as dacct_acct_frz_flg
,replace(replace(t1.reg_chn_cd,chr(13),''),chr(10),'') as reg_chn_cd
,replace(replace(t1.camp_actvy_id,chr(13),''),chr(10),'') as camp_actvy_id
,replace(replace(t1.refe_typ_cd,chr(13),''),chr(10),'') as refe_typ_cd
,replace(replace(t1.refe_num,chr(13),''),chr(10),'') as refe_num
,replace(replace(t1.drw_mode_status_cd,chr(13),''),chr(10),'') as drw_mode_status_cd
,replace(replace(t1.net_verfc_status_cd,chr(13),''),chr(10),'') as net_verfc_status_cd
,replace(replace(t1.bind_acct_flg,chr(13),''),chr(10),'') as bind_acct_flg
,replace(replace(t1.legal_acct_flg,chr(13),''),chr(10),'') as legal_acct_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'AGT_DACCT_BASE_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_DACCT_BASE_INFO') as etl_task_name
,replace(replace(t1.vrf_status_cd,chr(13),''),chr(10),'') as vrf_status_cd
,t1.actv_dt as actv_dt
,replace(replace(t1.txn_chn_status_cd,chr(13),''),chr(10),'') as txn_chn_status_cd
,replace(replace(t1.virt_acct_flg,chr(13),''),chr(10),'') as virt_acct_flg
,replace(replace(t1.colse_tm,chr(13),''),chr(10),'') as colse_tm
,replace(replace(t1.unab_vrf_reas_cd,chr(13),''),chr(10),'') as unab_vrf_reas_cd
,replace(replace(t1.disp_meth,chr(13),''),chr(10),'') as disp_meth
,replace(replace(t1.oprt_cert_typ_cd,chr(13),''),chr(10),'') as oprt_cert_typ_cd
,replace(replace(t1.oprt_cert_num,chr(13),''),chr(10),'') as oprt_cert_num
,replace(replace(t1.oprt_crph_num,chr(13),''),chr(10),'') as oprt_crph_num
from ${idl_schema}.hdws_iml_agt_dacct_base_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_dacct_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes