: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_cert_info_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_cert_info_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd 
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd 
,t1.start_dt as start_dt 
,replace(replace(t1.cert_num,chr(13),''),chr(10),'') as cert_num 
,replace(replace(t1.cert_addr,chr(13),''),chr(10),'') as cert_addr 
,replace(replace(t1.issue_cert_org,chr(13),''),chr(10),'') as issue_cert_org 
,replace(replace(t1.issue_cert_org_cty_cd,chr(13),''),chr(10),'') as issue_cert_org_cty_cd 
,t1.cert_effect_dt as cert_effect_dt 
,t1.cert_invalid_dt as cert_invalid_dt 
,replace(replace(t1.licen_issue_autho_dist_cd,chr(13),''),chr(10),'') as licen_issue_autho_dist_cd 
,replace(replace(t1.crdt_cd_cert_id,chr(13),''),chr(10),'') as crdt_cd_cert_id 
,replace(replace(t1.cert_valid_flg,chr(13),''),chr(10),'') as cert_valid_flg 
,replace(replace(t1.cert_status_cd,chr(13),''),chr(10),'') as cert_status_cd 
,replace(replace(t1.main_cert_no_flg,chr(13),''),chr(10),'') as main_cert_no_flg 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.pty_party_cert_info_h t1 
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_cert_info_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes