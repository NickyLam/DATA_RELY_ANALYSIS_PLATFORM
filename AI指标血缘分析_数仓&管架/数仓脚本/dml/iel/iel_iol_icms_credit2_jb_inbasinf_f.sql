: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_credit2_jb_inbasinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icms_credit2_jb_inbasinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.incinfsgmt_updflag,chr(13),''),chr(10),'') as incinfsgmt_updflag
,replace(replace(t1.resistatus,chr(13),''),chr(10),'') as resistatus
,replace(replace(t1.resiaddr,chr(13),''),chr(10),'') as resiaddr
,replace(replace(t1.mlginfoupdate,chr(13),''),chr(10),'') as mlginfoupdate
,t1.idnm as idnm
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.fcsinfoupdate,chr(13),''),chr(10),'') as fcsinfoupdate
,replace(replace(t1.title,chr(13),''),chr(10),'') as title
,replace(replace(t1.resiinfoupdate,chr(13),''),chr(10),'') as resiinfoupdate
,replace(replace(t1.infrectype,chr(13),''),chr(10),'') as infrectype
,replace(replace(t1.infsurccode,chr(13),''),chr(10),'') as infsurccode
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.spscmpynm,chr(13),''),chr(10),'') as spscmpynm
,replace(replace(t1.cpndist,chr(13),''),chr(10),'') as cpndist
,replace(replace(t1.cpntel,chr(13),''),chr(10),'') as cpntel
,replace(replace(t1.occupation,chr(13),''),chr(10),'') as occupation
,replace(replace(t1.mlginfsgmt_updflag,chr(13),''),chr(10),'') as mlginfsgmt_updflag
,replace(replace(t1.idsgmtdata,chr(13),''),chr(10),'') as idsgmtdata
,replace(replace(t1.empstatus,chr(13),''),chr(10),'') as empstatus
,replace(replace(t1.cpntype,chr(13),''),chr(10),'') as cpntype
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.techtitle,chr(13),''),chr(10),'') as techtitle
,replace(replace(t1.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
,replace(replace(t1.idsgmt_updflag,chr(13),''),chr(10),'') as idsgmt_updflag
,replace(replace(t1.eduinfsgmt_updflag,chr(13),''),chr(10),'') as eduinfsgmt_updflag
,replace(replace(t1.octpninfsgmt_updflag,chr(13),''),chr(10),'') as octpninfsgmt_updflag
,replace(replace(t1.spoidtype,chr(13),''),chr(10),'') as spoidtype
,replace(replace(t1.maildist,chr(13),''),chr(10),'') as maildist
,replace(replace(t1.dob,chr(13),''),chr(10),'') as dob
,replace(replace(t1.houseadd,chr(13),''),chr(10),'') as houseadd
,replace(replace(t1.hhdist,chr(13),''),chr(10),'') as hhdist
,replace(replace(t1.maristatus,chr(13),''),chr(10),'') as maristatus
,replace(replace(t1.eduinfoupdate,chr(13),''),chr(10),'') as eduinfoupdate
,replace(replace(t1.incinfoupdate,chr(13),''),chr(10),'') as incinfoupdate
,replace(replace(t1.spsinfsgmt_updflag,chr(13),''),chr(10),'') as spsinfsgmt_updflag
,replace(replace(t1.sponame,chr(13),''),chr(10),'') as sponame
,replace(replace(t1.mailaddr,chr(13),''),chr(10),'') as mailaddr
,replace(replace(t1.edulevel,chr(13),''),chr(10),'') as edulevel
,replace(replace(t1.cpnname,chr(13),''),chr(10),'') as cpnname
,replace(replace(t1.idnum,chr(13),''),chr(10),'') as idnum
,replace(replace(t1.spsinfoupdate,chr(13),''),chr(10),'') as spsinfoupdate
,replace(replace(t1.octpninfoupdate,chr(13),''),chr(10),'') as octpninfoupdate
,replace(replace(t1.resipc,chr(13),''),chr(10),'') as resipc
,replace(replace(t1.annlinc,chr(13),''),chr(10),'') as annlinc
,replace(replace(t1.nation,chr(13),''),chr(10),'') as nation
,replace(replace(t1.cellphone,chr(13),''),chr(10),'') as cellphone
,replace(replace(t1.sex,chr(13),''),chr(10),'') as sex
,replace(replace(t1.spotel,chr(13),''),chr(10),'') as spotel
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.acadegree,chr(13),''),chr(10),'') as acadegree
,replace(replace(t1.name,chr(13),''),chr(10),'') as name
,replace(replace(t1.cimoc,chr(13),''),chr(10),'') as cimoc
,replace(replace(t1.redncinfsgmt_updflag,chr(13),''),chr(10),'') as redncinfsgmt_updflag
,replace(replace(t1.spoidnum,chr(13),''),chr(10),'') as spoidnum
,replace(replace(t1.cpnpc,chr(13),''),chr(10),'') as cpnpc
,replace(replace(t1.workstartdate,chr(13),''),chr(10),'') as workstartdate
,replace(replace(t1.residist,chr(13),''),chr(10),'') as residist
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.rptdate,chr(13),''),chr(10),'') as rptdate
,replace(replace(t1.fcsinfsgmt_updflag,chr(13),''),chr(10),'') as fcsinfsgmt_updflag
,replace(replace(t1.cpnaddr,chr(13),''),chr(10),'') as cpnaddr
,replace(replace(t1.hometel,chr(13),''),chr(10),'') as hometel
,replace(replace(t1.mailpc,chr(13),''),chr(10),'') as mailpc
,replace(replace(t1.taxincome,chr(13),''),chr(10),'') as taxincome
from ${iol_schema}.icms_credit2_jb_inbasinf t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_credit2_jb_inbasinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes