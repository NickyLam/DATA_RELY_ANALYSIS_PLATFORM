: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_credit2_jb_inbasinf_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_credit2_jb_inbasinf.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.infrectype,chr(13),''),chr(10),'') as infrectype
    ,replace(replace(t.name,chr(13),''),chr(10),'') as name
    ,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
    ,replace(replace(t.idnum,chr(13),''),chr(10),'') as idnum
    ,replace(replace(t.infsurccode,chr(13),''),chr(10),'') as infsurccode
    ,replace(replace(t.rptdate,chr(13),''),chr(10),'') as rptdate
    ,replace(replace(t.rptdatecode,chr(13),''),chr(10),'') as rptdatecode
    ,replace(replace(t.cimoc,chr(13),''),chr(10),'') as cimoc
    ,replace(replace(t.customertype,chr(13),''),chr(10),'') as customertype
    ,replace(replace(t.idsgmt_updflag,chr(13),''),chr(10),'') as idsgmt_updflag
    ,replace(replace(t.fcsinfsgmt_updflag,chr(13),''),chr(10),'') as fcsinfsgmt_updflag
    ,replace(replace(t.spsinfsgmt_updflag,chr(13),''),chr(10),'') as spsinfsgmt_updflag
    ,replace(replace(t.eduinfsgmt_updflag,chr(13),''),chr(10),'') as eduinfsgmt_updflag
    ,replace(replace(t.octpninfsgmt_updflag,chr(13),''),chr(10),'') as octpninfsgmt_updflag
    ,replace(replace(t.redncinfsgmt_updflag,chr(13),''),chr(10),'') as redncinfsgmt_updflag
    ,replace(replace(t.mlginfsgmt_updflag,chr(13),''),chr(10),'') as mlginfsgmt_updflag
    ,replace(replace(t.incinfsgmt_updflag,chr(13),''),chr(10),'') as incinfsgmt_updflag
    ,t.idnm as idnm
    ,replace(replace(t.idsgmtdata,chr(13),''),chr(10),'') as idsgmtdata
    ,replace(replace(t.sex,chr(13),''),chr(10),'') as sex
    ,replace(replace(t.dob,chr(13),''),chr(10),'') as dob
    ,replace(replace(t.nation,chr(13),''),chr(10),'') as nation
    ,replace(replace(t.houseadd,chr(13),''),chr(10),'') as houseadd
    ,replace(replace(t.hhdist,chr(13),''),chr(10),'') as hhdist
    ,replace(replace(t.cellphone,chr(13),''),chr(10),'') as cellphone
    ,replace(replace(t.email,chr(13),''),chr(10),'') as email
    ,replace(replace(t.fcsinfoupdate,chr(13),''),chr(10),'') as fcsinfoupdate
    ,replace(replace(t.maristatus,chr(13),''),chr(10),'') as maristatus
    ,replace(replace(t.sponame,chr(13),''),chr(10),'') as sponame
    ,replace(replace(t.spoidtype,chr(13),''),chr(10),'') as spoidtype
    ,replace(replace(t.spoidnum,chr(13),''),chr(10),'') as spoidnum
    ,replace(replace(t.spotel,chr(13),''),chr(10),'') as spotel
    ,replace(replace(t.spscmpynm,chr(13),''),chr(10),'') as spscmpynm
    ,replace(replace(t.spsinfoupdate,chr(13),''),chr(10),'') as spsinfoupdate
    ,replace(replace(t.edulevel,chr(13),''),chr(10),'') as edulevel
    ,replace(replace(t.acadegree,chr(13),''),chr(10),'') as acadegree
    ,replace(replace(t.eduinfoupdate,chr(13),''),chr(10),'') as eduinfoupdate
    ,replace(replace(t.empstatus,chr(13),''),chr(10),'') as empstatus
    ,replace(replace(t.cpnname,chr(13),''),chr(10),'') as cpnname
    ,replace(replace(t.cpntype,chr(13),''),chr(10),'') as cpntype
    ,replace(replace(t.industry,chr(13),''),chr(10),'') as industry
    ,replace(replace(t.cpnaddr,chr(13),''),chr(10),'') as cpnaddr
    ,replace(replace(t.cpnpc,chr(13),''),chr(10),'') as cpnpc
    ,replace(replace(t.cpndist,chr(13),''),chr(10),'') as cpndist
    ,replace(replace(t.cpntel,chr(13),''),chr(10),'') as cpntel
    ,replace(replace(t.occupation,chr(13),''),chr(10),'') as occupation
    ,replace(replace(t.title,chr(13),''),chr(10),'') as title
    ,replace(replace(t.techtitle,chr(13),''),chr(10),'') as techtitle
    ,replace(replace(t.workstartdate,chr(13),''),chr(10),'') as workstartdate
    ,replace(replace(t.octpninfoupdate,chr(13),''),chr(10),'') as octpninfoupdate
    ,replace(replace(t.resistatus,chr(13),''),chr(10),'') as resistatus
    ,replace(replace(t.resiaddr,chr(13),''),chr(10),'') as resiaddr
    ,replace(replace(t.resipc,chr(13),''),chr(10),'') as resipc
    ,replace(replace(t.residist,chr(13),''),chr(10),'') as residist
    ,replace(replace(t.hometel,chr(13),''),chr(10),'') as hometel
    ,replace(replace(t.resiinfoupdate,chr(13),''),chr(10),'') as resiinfoupdate
    ,replace(replace(t.mailaddr,chr(13),''),chr(10),'') as mailaddr
    ,replace(replace(t.mailpc,chr(13),''),chr(10),'') as mailpc
    ,replace(replace(t.maildist,chr(13),''),chr(10),'') as maildist
    ,replace(replace(t.mlginfoupdate,chr(13),''),chr(10),'') as mlginfoupdate
    ,replace(replace(t.annlinc,chr(13),''),chr(10),'') as annlinc
    ,replace(replace(t.taxincome,chr(13),''),chr(10),'') as taxincome
    ,replace(replace(t.incinfoupdate,chr(13),''),chr(10),'') as incinfoupdate
    ,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
from iol.rcrs_credit2_jb_inbasinf t
where  t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_credit2_jb_inbasinf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes