: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_heps_hep_partner_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/heps_hep_partner_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.partner_id as partner_id
,replace(replace(t.flow_id,chr(13),''),chr(10),'') as flow_id
,replace(replace(t.idcart_no,chr(13),''),chr(10),'') as idcart_no
,replace(replace(t.partner_name,chr(13),''),chr(10),'') as partner_name
,replace(replace(t.partner_mobile,chr(13),''),chr(10),'') as partner_mobile
,replace(replace(t.borrower_relation,chr(13),''),chr(10),'') as borrower_relation
,replace(replace(t.detail_address,chr(13),''),chr(10),'') as detail_address
,replace(replace(t.marital_status,chr(13),''),chr(10),'') as marital_status
,replace(replace(t.spouse_name,chr(13),''),chr(10),'') as spouse_name
,replace(replace(t.spouse_idcard_no,chr(13),''),chr(10),'') as spouse_idcard_no
,replace(replace(t.spouse_mobile,chr(13),''),chr(10),'') as spouse_mobile
,replace(replace(t.child_name,chr(13),''),chr(10),'') as child_name
,replace(replace(t.child_idcard_no,chr(13),''),chr(10),'') as child_idcard_no
,replace(replace(t.child_mobile,chr(13),''),chr(10),'') as child_mobile
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,t.input_time as input_time
,t.lastupdate_time as lastupdate_time
,replace(replace(t.partner_certificate_type,chr(13),''),chr(10),'') as partner_certificate_type
,replace(replace(t.spouse_certificate_type,chr(13),''),chr(10),'') as spouse_certificate_type
,replace(replace(t.child_certificate_type,chr(13),''),chr(10),'') as child_certificate_type
from iol.heps_hep_partner_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/heps_hep_partner_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes