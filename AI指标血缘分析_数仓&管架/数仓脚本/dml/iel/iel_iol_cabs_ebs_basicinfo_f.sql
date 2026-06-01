: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cabs_ebs_basicinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cabs_ebs_basicinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.autoid as autoid
,replace(replace(t.accno,chr(13),''),chr(10),'') as accno
,replace(replace(t.accson,chr(13),''),chr(10),'') as accson
,replace(replace(t.idbank,chr(13),''),chr(10),'') as idbank
,replace(replace(t.accname,chr(13),''),chr(10),'') as accname
,replace(replace(t.sealaccno,chr(13),''),chr(10),'') as sealaccno
,replace(replace(t.currency,chr(13),''),chr(10),'') as currency
,replace(replace(t.address,chr(13),''),chr(10),'') as address
,replace(replace(t.zip,chr(13),''),chr(10),'') as zip
,replace(replace(t.linkman,chr(13),''),chr(10),'') as linkman
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t.sendmode,chr(13),''),chr(10),'') as sendmode
,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t.acctype,chr(13),''),chr(10),'') as acctype
,replace(replace(t.custid,chr(13),''),chr(10),'') as custid
,replace(replace(t.accstate,chr(13),''),chr(10),'') as accstate
,replace(replace(t.idbranch,chr(13),''),chr(10),'') as idbranch
,replace(replace(t.idcenter,chr(13),''),chr(10),'') as idcenter
,replace(replace(t.bankname,chr(13),''),chr(10),'') as bankname
,replace(replace(t.faceflag,chr(13),''),chr(10),'') as faceflag
,replace(replace(t.specialflag,chr(13),''),chr(10),'') as specialflag
,replace(replace(t.acccycle,chr(13),''),chr(10),'') as acccycle
,replace(replace(t.subjectno,chr(13),''),chr(10),'') as subjectno
,replace(replace(t.productno,chr(13),''),chr(10),'') as productno
,replace(replace(t.productdesc,chr(13),''),chr(10),'') as productdesc
,replace(replace(t.signflag,chr(13),''),chr(10),'') as signflag
,replace(replace(t.signtime,chr(13),''),chr(10),'') as signtime
,replace(replace(t.signopcode,chr(13),''),chr(10),'') as signopcode
,replace(replace(t.signcontractno,chr(13),''),chr(10),'') as signcontractno
,replace(replace(t.sealmode,chr(13),''),chr(10),'') as sealmode
,replace(replace(t.singleaccno,chr(13),''),chr(10),'') as singleaccno
,replace(replace(t.changesendmode,chr(13),''),chr(10),'') as changesendmode
,replace(replace(t.regaddress,chr(13),''),chr(10),'') as regaddress
,replace(replace(t.alonevoucherno,chr(13),''),chr(10),'') as alonevoucherno
,replace(replace(t.filtdetail,chr(13),''),chr(10),'') as filtdetail
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.cabs_ebs_basicinfo t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cabs_ebs_basicinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes