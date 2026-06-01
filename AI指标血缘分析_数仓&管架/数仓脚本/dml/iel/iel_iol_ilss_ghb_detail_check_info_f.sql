: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ilss_ghb_detail_check_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ilss_ghb_detail_check_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,t.data_pk_id as data_pk_id
,replace(replace(t.data_typ,chr(13),''),chr(10),'') as data_typ
,t.data_typ_id as data_typ_id
,replace(replace(t.etl_dt_ora,chr(13),''),chr(10),'') as etl_dt_ora
,replace(replace(t.info_to_tm,chr(13),''),chr(10),'') as info_to_tm
,replace(replace(t.qry_end_tm,chr(13),''),chr(10),'') as qry_end_tm
,replace(replace(t.quer_iden_num,chr(13),''),chr(10),'') as quer_iden_num
,replace(replace(t.quer_name,chr(13),''),chr(10),'') as quer_name
,replace(replace(t.to_rec_dtl_cntt,chr(13),''),chr(10),'') as to_rec_dtl_cntt
,t.create_time as create_time
,t.update_time as update_time
from iol.ilss_ghb_detail_check_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ilss_ghb_detail_check_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes