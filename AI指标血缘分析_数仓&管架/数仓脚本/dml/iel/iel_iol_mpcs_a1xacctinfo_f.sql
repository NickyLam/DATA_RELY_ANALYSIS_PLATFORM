: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a1xacctinfo_f
CreateDate: 20250508
FileName:   ${iel_data_path}/mpcs_a1xacctinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fntdt,chr(13),''),chr(10),'') as fntdt
,replace(replace(t1.phoneno,chr(13),''),chr(10),'') as phoneno
,replace(replace(t1.customid,chr(13),''),chr(10),'') as customid
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.issinscode,chr(13),''),chr(10),'') as issinscode
,replace(replace(t1.txnno,chr(13),''),chr(10),'') as txnno
,txntm
,replace(replace(t1.bussid,chr(13),''),chr(10),'') as bussid
,replace(replace(t1.elemmode,chr(13),''),chr(10),'') as elemmode
,replace(replace(t1.idcardtyp,chr(13),''),chr(10),'') as idcardtyp
,replace(replace(t1.certifid1,chr(13),''),chr(10),'') as certifid1
,replace(replace(t1.certifid2,chr(13),''),chr(10),'') as certifid2
,replace(replace(t1.familynm,chr(13),''),chr(10),'') as familynm
,replace(replace(t1.firstnm,chr(13),''),chr(10),'') as firstnm
,replace(replace(t1.custna,chr(13),''),chr(10),'') as custna
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.ocpdsc,chr(13),''),chr(10),'') as ocpdsc
,replace(replace(t1.taxresidenttype,chr(13),''),chr(10),'') as taxresidenttype
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.validstart,chr(13),''),chr(10),'') as validstart
,replace(replace(t1.validuntil,chr(13),''),chr(10),'') as validuntil
,replace(replace(t1.photoqryid,chr(13),''),chr(10),'') as photoqryid
,replace(replace(t1.provincecode,chr(13),''),chr(10),'') as provincecode
,replace(replace(t1.citycode,chr(13),''),chr(10),'') as citycode
,replace(replace(t1.districtcode,chr(13),''),chr(10),'') as districtcode
,replace(replace(t1.crsresidenttaxnation,chr(13),''),chr(10),'') as crsresidenttaxnation
,replace(replace(t1.crsresidenttaxid,chr(13),''),chr(10),'') as crsresidenttaxid
,replace(replace(t1.crstaxntnungetreason,chr(13),''),chr(10),'') as crstaxntnungetreason
,replace(replace(t1.crstaxidungetreason,chr(13),''),chr(10),'') as crstaxidungetreason
,replace(replace(t1.entrychannel,chr(13),''),chr(10),'') as entrychannel
,replace(replace(t1.verifyresult,chr(13),''),chr(10),'') as verifyresult
,replace(replace(t1.channelid,chr(13),''),chr(10),'') as channelid
,replace(replace(t1.channelname,chr(13),''),chr(10),'') as channelname
,replace(replace(t1.globalseq,chr(13),''),chr(10),'') as globalseq
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.degree,chr(13),''),chr(10),'') as degree
,replace(replace(t1.subaccprd,chr(13),''),chr(10),'') as subaccprd
,replace(replace(t1.limitamt,chr(13),''),chr(10),'') as limitamt
,replace(replace(t1.sumamt,chr(13),''),chr(10),'') as sumamt
,replace(replace(t1.tkamt,chr(13),''),chr(10),'') as tkamt
,updatetm
,unsigndt
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t1.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t1.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t1.remark8,chr(13),''),chr(10),'') as remark8

from ${iol_schema}.mpcs_a1xacctinfo t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a1xacctinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
