: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_mybkzq_cs_extent_info_f
CreateDate: 20250822
FileName:   ${iel_data_path}/icms_mybkzq_cs_extent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.businessscene,chr(13),''),chr(10),'') as businessscene
,replace(replace(t1.businesstag,chr(13),''),chr(10),'') as businesstag
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.prov,chr(13),''),chr(10),'') as prov
,replace(replace(t1.city,chr(13),''),chr(10),'') as city
,replace(replace(t1.area,chr(13),''),chr(10),'') as area
,replace(replace(t1.certvalidenddate,chr(13),''),chr(10),'') as certvalidenddate
,replace(replace(t1.busdatareqdate,chr(13),''),chr(10),'') as busdatareqdate
,replace(replace(t1.businfoexistflag,chr(13),''),chr(10),'') as businfoexistflag
,replace(replace(t1.notexistreason,chr(13),''),chr(10),'') as notexistreason
,replace(replace(t1.companyinfoname,chr(13),''),chr(10),'') as companyinfoname
,replace(replace(t1.companyinfolawer,chr(13),''),chr(10),'') as companyinfolawer
,replace(replace(t1.companyinforegisterno,chr(13),''),chr(10),'') as companyinforegisterno
,replace(replace(t1.companyinforegisterdate,chr(13),''),chr(10),'') as companyinforegisterdate
,replace(replace(t1.companyinforegisteraddress,chr(13),''),chr(10),'') as companyinforegisteraddress
,replace(replace(t1.companyinforegisteraddressareacode,chr(13),''),chr(10),'') as companyinforegisteraddressareacode
,replace(replace(t1.companyinforegisteraddressarea,chr(13),''),chr(10),'') as companyinforegisteraddressarea
,replace(replace(t1.companyinforegisterfund,chr(13),''),chr(10),'') as companyinforegisterfund
,replace(replace(t1.companyinfofundcurrency,chr(13),''),chr(10),'') as companyinfofundcurrency
,replace(replace(t1.companyinfotradecode,chr(13),''),chr(10),'') as companyinfotradecode
,replace(replace(t1.companyinfomanagerange,chr(13),''),chr(10),'') as companyinfomanagerange
,replace(replace(t1.companyinfoorgcode,chr(13),''),chr(10),'') as companyinfoorgcode
,replace(replace(t1.companyinforegisterdepartment,chr(13),''),chr(10),'') as companyinforegisterdepartment
,replace(replace(t1.companyinfostatusid,chr(13),''),chr(10),'') as companyinfostatusid
,replace(replace(t1.companyinfostatusdesc,chr(13),''),chr(10),'') as companyinfostatusdesc
,replace(replace(t1.companyinfolastcheckyear,chr(13),''),chr(10),'') as companyinfolastcheckyear
,replace(replace(t1.companyinfomanagebegindate,chr(13),''),chr(10),'') as companyinfomanagebegindate
,replace(replace(t1.companyinfomanageenddate,chr(13),''),chr(10),'') as companyinfomanageenddate
,replace(replace(t1.companyinfoopendate,chr(13),''),chr(10),'') as companyinfoopendate
,replace(replace(t1.companyinfocompanytype,chr(13),''),chr(10),'') as companyinfocompanytype
,replace(replace(t1.companyinfoeconomictype,chr(13),''),chr(10),'') as companyinfoeconomictype
,replace(replace(t1.targetjyflag1,chr(13),''),chr(10),'') as targetjyflag1
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname
,replace(replace(t1.custipid,chr(13),''),chr(10),'') as custipid
,replace(replace(t1.custiproleid,chr(13),''),chr(10),'') as custiproleid
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.transmode,chr(13),''),chr(10),'') as transmode

from ${iol_schema}.icms_mybkzq_cs_extent_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_mybkzq_cs_extent_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
