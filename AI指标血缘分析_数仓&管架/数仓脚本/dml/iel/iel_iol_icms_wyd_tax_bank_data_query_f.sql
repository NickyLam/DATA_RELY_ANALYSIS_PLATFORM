: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_wyd_tax_bank_data_query_f
CreateDate: 20251110
FileName:   ${iel_data_path}/icms_wyd_tax_bank_data_query.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.taxsno,chr(13),''),chr(10),'') as taxsno
,replace(replace(t1.taxpayerid,chr(13),''),chr(10),'') as taxpayerid
,replace(replace(t1.enterprisename,chr(13),''),chr(10),'') as enterprisename
,replace(replace(t1.tokenid,chr(13),''),chr(10),'') as tokenid
,replace(replace(t1.biztype,chr(13),''),chr(10),'') as biztype
,replace(replace(t1.taxqueryflag,chr(13),''),chr(10),'') as taxqueryflag
,replace(replace(t1.taxdatamajormsg,chr(13),''),chr(10),'') as taxdatamajormsg
,replace(replace(t1.taxdatacallrcrddtl,chr(13),''),chr(10),'') as taxdatacallrcrddtl
,replace(replace(t1.iscratefile,chr(13),''),chr(10),'') as iscratefile
,replace(replace(t1.isinform,chr(13),''),chr(10),'') as isinform
,replace(replace(t1.filepath,chr(13),''),chr(10),'') as filepath
,replace(replace(t1.filename,chr(13),''),chr(10),'') as filename
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.noncestr,chr(13),''),chr(10),'') as noncestr

from ${iol_schema}.icms_wyd_tax_bank_data_query t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_tax_bank_data_query.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
