: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_party_oper_corp_h_f
CreateDate: 20230629
FileName:   ${iel_data_path}/pty_party_oper_corp_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.corp_cert_no,chr(13),''),chr(10),'') as corp_cert_no
,replace(replace(t1.corp_cert_type_cd,chr(13),''),chr(10),'') as corp_cert_type_cd
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.pty_party_oper_corp_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_party_oper_corp_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
