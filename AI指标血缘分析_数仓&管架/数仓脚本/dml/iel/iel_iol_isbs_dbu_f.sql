: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_dbu_f
CreateDate: 20231121
FileName:   ${iel_data_path}/isbs_dbu.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inr,chr(13),''),chr(10),'') as inr
,replace(replace(t1.dbusta,chr(13),''),chr(10),'') as dbusta
,replace(replace(t1.extkey,chr(13),''),chr(10),'') as extkey
,replace(replace(t1.ver,chr(13),''),chr(10),'') as ver
,replace(replace(t1.custcode,chr(13),''),chr(10),'') as custcode
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.areacode,chr(13),''),chr(10),'') as areacode
,replace(replace(t1.custaddr,chr(13),''),chr(10),'') as custaddr
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.industrycode,chr(13),''),chr(10),'') as industrycode
,replace(replace(t1.attrcode,chr(13),''),chr(10),'') as attrcode
,replace(replace(t1.countrycode,chr(13),''),chr(10),'') as countrycode
,replace(replace(t1.istaxfree,chr(13),''),chr(10),'') as istaxfree
,replace(replace(t1.taxfreecode,chr(13),''),chr(10),'') as taxfreecode
,replace(replace(t1.invcountry,chr(13),''),chr(10),'') as invcountry
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.rptmethod,chr(13),''),chr(10),'') as rptmethod
,replace(replace(t1.ecexaddr,chr(13),''),chr(10),'') as ecexaddr
,replace(replace(t1.remarks,chr(13),''),chr(10),'') as remarks
,moddat
,snddat
,replace(replace(t1.bankinfos,chr(13),''),chr(10),'') as bankinfos
,replace(replace(t1.shortname,chr(13),''),chr(10),'') as shortname
,replace(replace(t1.customerengname,chr(13),''),chr(10),'') as customerengname
,regdate
,replace(replace(t1.corlmt,chr(13),''),chr(10),'') as corlmt
,replace(replace(t1.corscope,chr(13),''),chr(10),'') as corscope
,replace(replace(t1.incorporator,chr(13),''),chr(10),'') as incorporator
,replace(replace(t1.incorporatoridcode,chr(13),''),chr(10),'') as incorporatoridcode
,replace(replace(t1.custcontact,chr(13),''),chr(10),'') as custcontact
,replace(replace(t1.custtel,chr(13),''),chr(10),'') as custtel
,replace(replace(t1.custfax,chr(13),''),chr(10),'') as custfax
,replace(replace(t1.orgtype,chr(13),''),chr(10),'') as orgtype
,replace(replace(t1.customno,chr(13),''),chr(10),'') as customno
,replace(replace(t1.creditcode,chr(13),''),chr(10),'') as creditcode
,replace(replace(t1.leicode,chr(13),''),chr(10),'') as leicode
,replace(replace(t1.swiftcode,chr(13),''),chr(10),'') as swiftcode

from ${iol_schema}.isbs_dbu t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_dbu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
