: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tgls_cbrc_cell_info_f
CreateDate: 20250820
FileName:   ${iel_data_path}/tgls_cbrc_cell_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,subsys
,replace(replace(t1.shetcd,chr(13),''),chr(10),'') as shetcd
,stacid
,replace(replace(t1.rowsna,chr(13),''),chr(10),'') as rowsna
,replace(replace(t1.coluna,chr(13),''),chr(10),'') as coluna
,verson
,replace(replace(t1.itemcd,chr(13),''),chr(10),'') as itemcd
,cellid
,replace(replace(t1.itemna,chr(13),''),chr(10),'') as itemna
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.upitem,chr(13),''),chr(10),'') as upitem
,replace(replace(t1.totltp,chr(13),''),chr(10),'') as totltp
,totllv
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.plusfg,chr(13),''),chr(10),'') as plusfg
,begndt
,overdt
,replace(replace(t1.inptfg,chr(13),''),chr(10),'') as inptfg
,replace(replace(t1.fomutp,chr(13),''),chr(10),'') as fomutp
,replace(replace(t1.foluma,chr(13),''),chr(10),'') as foluma
,replace(replace(t1.datatp,chr(13),''),chr(10),'') as datatp
,replace(replace(t1.fomuds,chr(13),''),chr(10),'') as fomuds
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,unitnm
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.tgls_cbrc_cell_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_cbrc_cell_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
