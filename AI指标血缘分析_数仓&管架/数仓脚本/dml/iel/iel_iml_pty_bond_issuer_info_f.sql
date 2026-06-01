: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_bond_issuer_info_f
CreateDate: 20221114
FileName:   ${iel_data_path}/pty_bond_issuer_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_status_cd,chr(13),''),chr(10),'') as issuer_status_cd
,replace(replace(t1.cn_name,chr(13),''),chr(10),'') as cn_name
,replace(replace(t1.en_name,chr(13),''),chr(10),'') as en_name
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iml_schema}.pty_bond_issuer_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_bond_issuer_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
