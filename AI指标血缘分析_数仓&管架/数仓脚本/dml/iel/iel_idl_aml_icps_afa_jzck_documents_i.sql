: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_icps_afa_jzck_documents_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_icps_afa_jzck_documents.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.productcode as productcode
,t1.workdate as workdate
,t1.agentserialno as agentserialno
,t1.worktime as worktime
,t1.fileflag as fileflag
,t1.fileid as fileid
,t1.transserialnumber as transserialnumber
,t1.applicationid as applicationid
,t1.casenumber as casenumber
,t1.documentnumber as documentnumber
,t1.filename as filename
,t1.filetype as filetype
,t1.filetypename as filetypename
,t1.documenttype as documenttype
,t1.documenttypename as documenttypename
,t1.documentmd5 as documentmd5
,t1.filepath as filepath
,t1.content as content
,t1.remark1 as remark1
,t1.remark2 as remark2
,t1.remark3 as remark3
,t1.remark4 as remark4
,t1.tradesystem as tradesystem
,t1.tradetype as tradetype
,t1.zjmc as zjmc
,t1.djr as djr
,t1.djrq as djrq
from idl.aml_icps_afa_jzck_documents t1
where t1.etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_icps_afa_jzck_documents.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes