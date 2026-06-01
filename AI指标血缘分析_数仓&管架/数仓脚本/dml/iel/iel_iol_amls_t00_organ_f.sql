: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t00_organ_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t00_organ.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.organkey,chr(13),''),chr(10),'') as organkey
    ,replace(replace(t.organno,chr(13),''),chr(10),'') as organno
    ,replace(replace(t.organname,chr(13),''),chr(10),'') as organname
    ,replace(replace(t.organsf,chr(13),''),chr(10),'') as organsf
    ,replace(replace(t.organlevel,chr(13),''),chr(10),'') as organlevel
    ,replace(replace(t.uporgankey,chr(13),''),chr(10),'') as uporgankey
    ,replace(replace(t.organaddress,chr(13),''),chr(10),'') as organaddress
    ,replace(replace(t.postalcode,chr(13),''),chr(10),'') as postalcode
    ,replace(replace(t.telephone,chr(13),''),chr(10),'') as telephone
    ,replace(replace(t.organmanager,chr(13),''),chr(10),'') as organmanager
    ,t.organpamount as organpamount
    ,replace(replace(t.linkman,chr(13),''),chr(10),'') as linkman
    ,replace(replace(t.builddate,chr(13),''),chr(10),'') as builddate
    ,replace(replace(t.organdes,chr(13),''),chr(10),'') as organdes
    ,replace(replace(t.validatedate,chr(13),''),chr(10),'') as validatedate
    ,replace(replace(t.invalidatedate,chr(13),''),chr(10),'') as invalidatedate
    ,replace(replace(t.createdate,chr(13),''),chr(10),'') as createdate
    ,replace(replace(t.creator,chr(13),''),chr(10),'') as creator
    ,replace(replace(t.modifydate,chr(13),''),chr(10),'') as modifydate
    ,replace(replace(t.modifier,chr(13),''),chr(10),'') as modifier
    ,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
    ,replace(replace(t.unionorgkey,chr(13),''),chr(10),'') as unionorgkey
    ,replace(replace(t.org_area,chr(13),''),chr(10),'') as org_area
    ,replace(replace(t.settleorgkey,chr(13),''),chr(10),'') as settleorgkey
    ,replace(replace(t.uporgankey_sor,chr(13),''),chr(10),'') as uporgankey_sor
    ,replace(replace(t.organcode,chr(13),''),chr(10),'') as organcode
    ,replace(replace(t.is_cross,chr(13),''),chr(10),'') as is_cross
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t00_organ t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t00_organ.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes