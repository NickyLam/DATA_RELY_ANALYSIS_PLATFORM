: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crps_icms_mybk_cs_extent_info_f
CreateDate: 20230608
FileName:   ${iel_data_path}/crps_icms_mybk_cs_extent_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.serno as serno
,t1.registeraddressarea as registeraddressarea
,t1.statusid as statusid
,t1.sex as sex
,t1.city as city
,t1.registerno as registerno
,t1.orgcode as orgcode
,t1.managebegindate as managebegindate
,t1.opendate as opendate
,t1.economictype as economictype
,t1.registeraddressareacode as registeraddressareacode
,t1.area as area
,t1.companytype as companytype
,t1.registerdate as registerdate
,t1.industryname as industryname
,t1.nationality as nationality
,t1.registeraddress as registeraddress
,t1.registerdepartment as registerdepartment
,t1.migtflag as migtflag
,t1.busdatareqdate as busdatareqdate
,t1.businfoexistflag as businfoexistflag
,t1.fundcurrency as fundcurrency
,t1.companyinfoname as companyinfoname
,t1.tradecode as tradecode
,t1.managerange as managerange
,t1.mobile as mobile
,t1.certvalidenddate as certvalidenddate
,t1.statusdesc as statusdesc
,t1.certvalidstartdate as certvalidstartdate
,t1.manageenddate as manageenddate
,t1.targetjyflag1 as targetjyflag1
,t1.applyno as applyno
,t1.companyinfolawer as companyinfolawer
,t1.registerfund as registerfund
,t1.address as address
,t1.prov as prov
,t1.notexistreason as notexistreason
,t1.lastcheckyear as lastcheckyear
,t1.indivocc as indivocc

from ${idl_schema}.crps_icms_mybk_cs_extent_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crps_icms_mybk_cs_extent_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
