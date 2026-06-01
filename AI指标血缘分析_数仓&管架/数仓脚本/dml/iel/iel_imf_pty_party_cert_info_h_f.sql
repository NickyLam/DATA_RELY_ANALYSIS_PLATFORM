: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_pty_party_cert_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_party_cert_info_h.f.${batch_date}.dat
IF_mark:    f
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
,replace(replace(t1.netw_vrfction_flg,chr(13),''),chr(10),'') as netw_vrfction_flg 
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd 
from ${iml_schema}.pty_party_cert_info_h t1 
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd')
union all
select 
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
,replace(replace(t1.netw_vrfction_flg,chr(13),''),chr(10),'') as netw_vrfction_flg 
,replace(replace(t1.netw_vrfction_rest_cd,chr(13),''),chr(10),'') as netw_vrfction_rest_cd 
from ${iml_schema}.pty_party_cert_info_h_ecif1_static_data t1 
where 1 = 1 
and not exists (select 1 from ${iml_schema}.pty_party_cert_info_h b 
                        where t1.party_id=b.party_id 
                          and t1.sorc_sys_cd=b.sorc_sys_cd 
                          and t1.cert_type_cd=b.cert_type_cd
                          and b.start_dt<= to_date('${batch_date}','yyyymmdd')
                          and b.end_dt> to_date('${batch_date}','yyyymmdd'))" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_cert_info_h.f.${batch_date}.dat" \
        charset=utf8
        safe=yes