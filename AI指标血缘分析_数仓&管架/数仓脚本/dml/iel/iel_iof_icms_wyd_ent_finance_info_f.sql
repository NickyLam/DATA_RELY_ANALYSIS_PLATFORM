: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_wyd_ent_finance_info_f
CreateDate: 20250312
FileName:   ${iel_data_path}/icms_wyd_ent_finance_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.datadt,chr(13),''),chr(10),'') as datadt
,replace(replace(t1.entname,chr(13),''),chr(10),'') as entname
,replace(replace(t1.registernumber,chr(13),''),chr(10),'') as registernumber
,replace(replace(t1.registerdate,chr(13),''),chr(10),'') as registerdate
,replace(replace(t1.zzm,chr(13),''),chr(10),'') as zzm
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname
,replace(replace(t1.staffnumber,chr(13),''),chr(10),'') as staffnumber
,replace(replace(t1.ancheyear,chr(13),''),chr(10),'') as ancheyear
,assgro
,liagro
,vendinc
,maibusinc
,progro
,netinc
,ratgro
,totequ
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.reportformtype,chr(13),''),chr(10),'') as reportformtype
,replace(replace(t1.reportstartdate,chr(13),''),chr(10),'') as reportstartdate
,replace(replace(t1.reportclosingdate,chr(13),''),chr(10),'') as reportclosingdate
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.productid,chr(13),''),chr(10),'') as productid
,replace(replace(t1.classifyresult,chr(13),''),chr(10),'') as classifyresult

from ${iol_schema}.icms_wyd_ent_finance_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_wyd_ent_finance_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
