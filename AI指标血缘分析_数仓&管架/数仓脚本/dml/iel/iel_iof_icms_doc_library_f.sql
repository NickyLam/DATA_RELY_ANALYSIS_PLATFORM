: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_doc_library_f
CreateDate: 20240328
FileName:   ${iel_data_path}/icms_doc_library.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.docno,chr(13),''),chr(10),'') as docno
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.doctitle,chr(13),''),chr(10),'') as doctitle
,replace(replace(t1.doctype,chr(13),''),chr(10),'') as doctype
,replace(replace(t1.doclength,chr(13),''),chr(10),'') as doclength
,replace(replace(t1.docimportance,chr(13),''),chr(10),'') as docimportance
,replace(replace(t1.docsecret,chr(13),''),chr(10),'') as docsecret
,replace(replace(t1.docstage,chr(13),''),chr(10),'') as docstage
,replace(replace(t1.docsource,chr(13),''),chr(10),'') as docsource
,replace(replace(t1.docunit,chr(13),''),chr(10),'') as docunit
,docdate
,replace(replace(t1.docorganizer,chr(13),''),chr(10),'') as docorganizer
,replace(replace(t1.dockeyword,chr(13),''),chr(10),'') as dockeyword
,replace(replace(t1.docabstract,chr(13),''),chr(10),'') as docabstract
,replace(replace(t1.doclocation,chr(13),''),chr(10),'') as doclocation
,replace(replace(t1.docattribute,chr(13),''),chr(10),'') as docattribute
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,inputdate
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,updatedate
,replace(replace(t1.corporgid,chr(13),''),chr(10),'') as corporgid
,replace(replace(t1.olddocno,chr(13),''),chr(10),'') as olddocno
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag

from ${iol_schema}.icms_doc_library t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_doc_library.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
