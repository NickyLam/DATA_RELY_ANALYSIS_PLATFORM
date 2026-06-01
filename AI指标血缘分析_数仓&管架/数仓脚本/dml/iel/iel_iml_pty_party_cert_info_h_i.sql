: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_cert_info_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_cert_info_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,t.start_dt as start_dt
,replace(replace(t.cert_num,chr(13),''),chr(10),'') as cert_num
,replace(replace(t.cert_addr,chr(13),''),chr(10),'') as cert_addr
,replace(replace(t.issue_cert_org,chr(13),''),chr(10),'') as issue_cert_org
,replace(replace(t.issue_cert_org_cty_cd,chr(13),''),chr(10),'') as issue_cert_org_cty_cd
,t.cert_effect_dt as cert_effect_dt
,t.cert_invalid_dt as cert_invalid_dt
,replace(replace(t.licen_issue_autho_dist_cd,chr(13),''),chr(10),'') as licen_issue_autho_dist_cd
,replace(replace(t.crdt_cd_cert_id,chr(13),''),chr(10),'') as crdt_cd_cert_id
,replace(replace(t.cert_valid_flg,chr(13),''),chr(10),'') as cert_valid_flg
,replace(replace(t.cert_status_cd,chr(13),''),chr(10),'') as cert_status_cd
,replace(replace(t.main_cert_no_flg,chr(13),''),chr(10),'') as main_cert_no_flg
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.pty_party_cert_info_h t
where t.start_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_cert_info_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes