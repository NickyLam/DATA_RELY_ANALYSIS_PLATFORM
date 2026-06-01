: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tgls_cbrc_data_base_i
CreateDate: 20250820
FileName:   ${iel_data_path}/tgls_cbrc_data_base.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.brchno,chr(13),''),chr(10),'') as brchno
,replace(replace(t1.shetcd,chr(13),''),chr(10),'') as shetcd
,replace(replace(t1.itemcd,chr(13),''),chr(10),'') as itemcd
,replace(replace(t1.itemvl,chr(13),''),chr(10),'') as itemvl
,replace(replace(t1.adjtvl,chr(13),''),chr(10),'') as adjtvl
,replace(replace(t1.adjttp,chr(13),''),chr(10),'') as adjttp
,replace(replace(t1.tranus,chr(13),''),chr(10),'') as tranus
,trandt
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.geldtp,chr(13),''),chr(10),'') as geldtp
,stacid
,replace(replace(t1.systid,chr(13),''),chr(10),'') as systid
,replace(replace(t1.acctdt,chr(13),''),chr(10),'') as acctdt

from ${iol_schema}.tgls_cbrc_data_base t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tgls_cbrc_data_base.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
