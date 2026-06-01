: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_tax_data_f
CreateDate: 20251110
FileName:   ${iel_data_path}/icms_wyd_tax_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.taxseqno,chr(13),''),chr(10),'') as taxseqno
,replace(replace(t1.corptaxbursite,chr(13),''),chr(10),'') as corptaxbursite
,replace(replace(t1.taxburauthseqnum,chr(13),''),chr(10),'') as taxburauthseqnum
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,callcnt
,replace(replace(t1.fkseqno,chr(13),''),chr(10),'') as fkseqno
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.wzurl,chr(13),''),chr(10),'') as wzurl

from ${iol_schema}.icms_wyd_tax_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_tax_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
