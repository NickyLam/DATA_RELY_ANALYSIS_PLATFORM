: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_icms_mybkzd_cs_extent_info_f
CreateDate: 20250822
FileName:   ${iel_data_path}/icms_mybkzd_cs_extent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
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
,replace(replace(t1.registerno,chr(13),''),chr(10),'') as registerno
,replace(replace(t1.registerdate,chr(13),''),chr(10),'') as registerdate
,replace(replace(t1.registeraddress,chr(13),''),chr(10),'') as registeraddress
,replace(replace(t1.registeraddressareacode,chr(13),''),chr(10),'') as registeraddressareacode
,replace(replace(t1.registeraddressarea,chr(13),''),chr(10),'') as registeraddressarea
,registerfund
,replace(replace(t1.fundcurrency,chr(13),''),chr(10),'') as fundcurrency
,replace(replace(t1.tradecode,chr(13),''),chr(10),'') as tradecode
,replace(replace(t1.managerange,chr(13),''),chr(10),'') as managerange
,replace(replace(t1.orgcode,chr(13),''),chr(10),'') as orgcode
,replace(replace(t1.registerdepartment,chr(13),''),chr(10),'') as registerdepartment
,replace(replace(t1.statusid,chr(13),''),chr(10),'') as statusid
,replace(replace(t1.statusdesc,chr(13),''),chr(10),'') as statusdesc
,replace(replace(t1.lastcheckyear,chr(13),''),chr(10),'') as lastcheckyear
,replace(replace(t1.managebegindate,chr(13),''),chr(10),'') as managebegindate
,replace(replace(t1.manageenddate,chr(13),''),chr(10),'') as manageenddate
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.companytype,chr(13),''),chr(10),'') as companytype
,replace(replace(t1.economictype,chr(13),''),chr(10),'') as economictype
,replace(replace(t1.targetjyflag1,chr(13),''),chr(10),'') as targetjyflag1
,replace(replace(t1.industryname,chr(13),''),chr(10),'') as industryname
,replace(replace(t1.certvalidstartdate,chr(13),''),chr(10),'') as certvalidstartdate
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.indivocc,chr(13),''),chr(10),'') as indivocc
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.businessscene,chr(13),''),chr(10),'') as businessscene
,replace(replace(t1.businesstag,chr(13),''),chr(10),'') as businesstag
,replace(replace(t1.pushreason,chr(13),''),chr(10),'') as pushreason
,replace(replace(t1.custverifytype,chr(13),''),chr(10),'') as custverifytype
,replace(replace(t1.custverifyresult,chr(13),''),chr(10),'') as custverifyresult
,replace(replace(t1.custverifytime,chr(13),''),chr(10),'') as custverifytime
,replace(replace(t1.customertag,chr(13),''),chr(10),'') as customertag
,replace(replace(t1.employee_id,chr(13),''),chr(10),'') as employee_id
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.company_info_org_code,chr(13),''),chr(10),'') as company_info_org_code

from ${iol_schema}.icms_mybkzd_cs_extent_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_mybkzd_cs_extent_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
