: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icps_afa_jzck_customer_a
CreateDate: 20220819
FileName:   ${iel_data_path}/icps_afa_jzck_customer.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.productcode,chr(13),''),chr(10),'') as productcode
    ,replace(replace(t.workdate,chr(13),''),chr(10),'') as workdate
    ,replace(replace(t.agentserialno,chr(13),''),chr(10),'') as agentserialno
    ,replace(replace(t.worktime,chr(13),''),chr(10),'') as worktime
    ,replace(replace(t.transserialnumber,chr(13),''),chr(10),'') as transserialnumber
    ,replace(replace(t.applicationid,chr(13),''),chr(10),'') as applicationid
    ,replace(replace(t.result,chr(13),''),chr(10),'') as result
    ,replace(replace(t.description,chr(13),''),chr(10),'') as description
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnumber,chr(13),''),chr(10),'') as idnumber
    ,replace(replace(t.accountname,chr(13),''),chr(10),'') as accountname
    ,replace(replace(t.telephone,chr(13),''),chr(10),'') as telephone
    ,replace(replace(t.mobilephone,chr(13),''),chr(10),'') as mobilephone
    ,replace(replace(t.operatorname,chr(13),''),chr(10),'') as operatorname
    ,replace(replace(t.operatorcredentialtype,chr(13),''),chr(10),'') as operatorcredentialtype
    ,replace(replace(t.operatorcredentialnumber,chr(13),''),chr(10),'') as operatorcredentialnumber
    ,replace(replace(t.residentaddress,chr(13),''),chr(10),'') as residentaddress
    ,replace(replace(t.residenttelnumber,chr(13),''),chr(10),'') as residenttelnumber
    ,replace(replace(t.workcompanyname,chr(13),''),chr(10),'') as workcompanyname
    ,replace(replace(t.workaddress,chr(13),''),chr(10),'') as workaddress
    ,replace(replace(t.worktelnumber,chr(13),''),chr(10),'') as worktelnumber
    ,replace(replace(t.emailaddress,chr(13),''),chr(10),'') as emailaddress
    ,replace(replace(t.legalpersonrep,chr(13),''),chr(10),'') as legalpersonrep
    ,replace(replace(t.legalpersonrepcredentialtype,chr(13),''),chr(10),'') as legalpersonrepcredentialtype
    ,replace(replace(t.legalpersonrepcredentialnumber,chr(13),''),chr(10),'') as legalpersonrepcredentialnumber
    ,replace(replace(t.businesslicensenumber,chr(13),''),chr(10),'') as businesslicensenumber
    ,replace(replace(t.statetaxserial,chr(13),''),chr(10),'') as statetaxserial
    ,replace(replace(t.localtaxserial,chr(13),''),chr(10),'') as localtaxserial
    ,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
    ,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
    ,replace(replace(t.remark3,chr(13),''),chr(10),'') as remark3
    ,replace(replace(t.remark4,chr(13),''),chr(10),'') as remark4
    ,replace(replace(t.zddz,chr(13),''),chr(10),'') as zddz
    ,replace(replace(t.dbrlxdh,chr(13),''),chr(10),'') as dbrlxdh
    ,replace(replace(t.sjyhblrq,chr(13),''),chr(10),'') as sjyhblrq
    ,replace(replace(t.sjyhkhwd,chr(13),''),chr(10),'') as sjyhkhwd
    ,replace(replace(t.sjyhkhwddm,chr(13),''),chr(10),'') as sjyhkhwddm
    ,replace(replace(t.sjyhkhwdszd,chr(13),''),chr(10),'') as sjyhkhwdszd
    ,replace(replace(t.sjyhzhm,chr(13),''),chr(10),'') as sjyhzhm
    ,replace(replace(t.wyblrq,chr(13),''),chr(10),'') as wyblrq
    ,replace(replace(t.wykhwd,chr(13),''),chr(10),'') as wykhwd
    ,replace(replace(t.wykhwddm,chr(13),''),chr(10),'') as wykhwddm
    ,replace(replace(t.wykhwdszd,chr(13),''),chr(10),'') as wykhwdszd
    ,replace(replace(t.wyzhm,chr(13),''),chr(10),'') as wyzhm
    ,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
    ,replace(replace(t.addr,chr(13),''),chr(10),'') as addr
    ,replace(replace(t.credentialexpirydate,chr(13),''),chr(10),'') as credentialexpirydate
    ,replace(replace(t.postcode,chr(13),''),chr(10),'') as postcode
    ,replace(replace(t.upddate,chr(13),''),chr(10),'') as upddate
    ,replace(replace(t.updtime,chr(13),''),chr(10),'') as updtime
from iol.icps_afa_jzck_customer t
where 1=1  " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icps_afa_jzck_customer.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes