: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_icms_partner_info_h_f
CreateDate: 20230512
FileName:   ${iel_data_path}/pty_icms_partner_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.partner_id,chr(13),''),chr(10),'') as partner_id
,replace(replace(t1.partner_name,chr(13),''),chr(10),'') as partner_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.legal_rep_cert_type_cd,chr(13),''),chr(10),'') as legal_rep_cert_type_cd
,replace(replace(t1.legal_rep_cert_no,chr(13),''),chr(10),'') as legal_rep_cert_no
,replace(replace(t1.phys_addr,chr(13),''),chr(10),'') as phys_addr
,replace(replace(t1.rgst_org_id,chr(13),''),chr(10),'') as rgst_org_id
,rgst_dt
,crdt_lmt
,co_start_dt
,co_end_dt

from ${iml_schema}.pty_icms_partner_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_icms_partner_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
