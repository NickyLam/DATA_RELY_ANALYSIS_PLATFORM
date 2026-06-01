: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icps_afa_jzck_customer_a1
CreateDate: 20240812
FileName:   ${iel_data_path}/icps_afa_jzck_customer.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.productcode,chr(13),''),chr(10),'') as productcode
,replace(replace(t1.workdate,chr(13),''),chr(10),'') as workdate
,replace(replace(t1.agentserialno,chr(13),''),chr(10),'') as agentserialno
,replace(replace(t1.worktime,chr(13),''),chr(10),'') as worktime
,replace(replace(t1.transserialnumber,chr(13),''),chr(10),'') as transserialnumber
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.result,chr(13),''),chr(10),'') as result
,replace(replace(t1.description,chr(13),''),chr(10),'') as description
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idnumber,chr(13),''),chr(10),'') as idnumber
,replace(replace(t1.accountname,chr(13),''),chr(10),'') as accountname
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.mobilephone,chr(13),''),chr(10),'') as mobilephone
,replace(replace(t1.operatorname,chr(13),''),chr(10),'') as operatorname
,replace(replace(t1.operatorcredentialtype,chr(13),''),chr(10),'') as operatorcredentialtype
,replace(replace(t1.operatorcredentialnumber,chr(13),''),chr(10),'') as operatorcredentialnumber
,replace(replace(t1.residentaddress,chr(13),''),chr(10),'') as residentaddress
,replace(replace(t1.residenttelnumber,chr(13),''),chr(10),'') as residenttelnumber
,replace(replace(t1.workcompanyname,chr(13),''),chr(10),'') as workcompanyname
,replace(replace(t1.workaddress,chr(13),''),chr(10),'') as workaddress
,replace(replace(t1.worktelnumber,chr(13),''),chr(10),'') as worktelnumber
,replace(replace(t1.emailaddress,chr(13),''),chr(10),'') as emailaddress
,replace(replace(t1.legalpersonrep,chr(13),''),chr(10),'') as legalpersonrep
,replace(replace(t1.legalpersonrepcredentialtype,chr(13),''),chr(10),'') as legalpersonrepcredentialtype
,replace(replace(t1.legalpersonrepcredentialnumber,chr(13),''),chr(10),'') as legalpersonrepcredentialnumber
,replace(replace(t1.businesslicensenumber,chr(13),''),chr(10),'') as businesslicensenumber
,replace(replace(t1.statetaxserial,chr(13),''),chr(10),'') as statetaxserial
,replace(replace(t1.localtaxserial,chr(13),''),chr(10),'') as localtaxserial
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.zddz,chr(13),''),chr(10),'') as zddz
,replace(replace(t1.dbrlxdh,chr(13),''),chr(10),'') as dbrlxdh
,replace(replace(t1.sjyhblrq,chr(13),''),chr(10),'') as sjyhblrq
,replace(replace(t1.sjyhkhwd,chr(13),''),chr(10),'') as sjyhkhwd
,replace(replace(t1.sjyhkhwddm,chr(13),''),chr(10),'') as sjyhkhwddm
,replace(replace(t1.sjyhkhwdszd,chr(13),''),chr(10),'') as sjyhkhwdszd
,replace(replace(t1.sjyhzhm,chr(13),''),chr(10),'') as sjyhzhm
,replace(replace(t1.wyblrq,chr(13),''),chr(10),'') as wyblrq
,replace(replace(t1.wykhwd,chr(13),''),chr(10),'') as wykhwd
,replace(replace(t1.wykhwddm,chr(13),''),chr(10),'') as wykhwddm
,replace(replace(t1.wykhwdszd,chr(13),''),chr(10),'') as wykhwdszd
,replace(replace(t1.wyzhm,chr(13),''),chr(10),'') as wyzhm
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.addr,chr(13),''),chr(10),'') as addr
,replace(replace(t1.credentialexpirydate,chr(13),''),chr(10),'') as credentialexpirydate
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.upddate,chr(13),''),chr(10),'') as upddate
,replace(replace(t1.updtime,chr(13),''),chr(10),'') as updtime

from ${iol_schema}.icps_afa_jzck_customer t1
where t1.workdate <= '${batch_date}'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_customer.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
