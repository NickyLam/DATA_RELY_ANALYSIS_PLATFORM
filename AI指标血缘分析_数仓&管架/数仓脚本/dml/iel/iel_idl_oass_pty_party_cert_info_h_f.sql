: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_oass_pty_party_cert_info_h_f
CreateDate: 20221111
FileName:   ${iel_data_path}/oass_pty_party_cert_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.sorc_sys_cd as sorc_sys_cd
,t1.cert_type_cd as cert_type_cd
,t1.cert_num as cert_num
,t1.cert_addr as cert_addr
,t1.issue_cert_org as issue_cert_org
,t1.issue_cert_org_cty_cd as issue_cert_org_cty_cd
,t1.cert_effect_dt as cert_effect_dt
,t1.cert_invalid_dt as cert_invalid_dt
,t1.licen_issue_autho_dist_cd as licen_issue_autho_dist_cd
,t1.crdt_cd_cert_id as crdt_cd_cert_id
,t1.cert_valid_flg as cert_valid_flg
,t1.cert_status_cd as cert_status_cd
,t1.main_cert_no_flg as main_cert_no_flg
,t1.netw_vrfction_flg as netw_vrfction_flg
,t1.netw_vrfction_rest_cd as netw_vrfction_rest_cd
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,t1.id_mark as id_mark
,t1.party_id as party_id
,t1.lp_id as lp_id

from ${idl_schema}.oass_pty_party_cert_info_h t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/oass_pty_party_cert_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
