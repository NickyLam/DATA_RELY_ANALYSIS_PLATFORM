: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_fkd_rel_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_fkd_rel_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.rel_typ,chr(13),''),chr(10),'') as rel_typ
,replace(replace(t.rel_name,chr(13),''),chr(10),'') as rel_name
,replace(replace(t.rel_tel_no,chr(13),''),chr(10),'') as rel_tel_no
,replace(replace(t.rel_id_type,chr(13),''),chr(10),'') as rel_id_type
,replace(replace(t.rel_id_no,chr(13),''),chr(10),'') as rel_id_no
,replace(replace(t.rel_relationship,chr(13),''),chr(10),'') as rel_relationship
,replace(replace(t.rel_family_city_id,chr(13),''),chr(10),'') as rel_family_city_id
,replace(replace(t.rel_family_addr,chr(13),''),chr(10),'') as rel_family_addr
,replace(replace(t.rel_marriage,chr(13),''),chr(10),'') as rel_marriage
,replace(replace(t.rel_partner_name,chr(13),''),chr(10),'') as rel_partner_name
,replace(replace(t.rel_partner_tel_no,chr(13),''),chr(10),'') as rel_partner_tel_no
,replace(replace(t.rel_partner_id_type,chr(13),''),chr(10),'') as rel_partner_id_type
,replace(replace(t.rel_partner_id_no,chr(13),''),chr(10),'') as rel_partner_id_no
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.pkno,chr(13),''),chr(10),'') as pkno
,replace(replace(t.cus_id,chr(13),''),chr(10),'') as cus_id
,replace(replace(t.fqz_result,chr(13),''),chr(10),'') as fqz_result
,replace(replace(t.zx_result,chr(13),''),chr(10),'') as zx_result
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t.update_date,chr(13),''),chr(10),'') as update_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_fkd_rel_list t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_fkd_rel_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes