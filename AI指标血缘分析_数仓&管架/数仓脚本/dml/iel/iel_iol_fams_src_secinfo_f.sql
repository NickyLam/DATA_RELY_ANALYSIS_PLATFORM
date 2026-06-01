: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_src_secinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_src_secinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.secid,chr(13),''),chr(10),'') as secid
,replace(replace(t1.secname,chr(13),''),chr(10),'') as secname
,replace(replace(t1.seccode,chr(13),''),chr(10),'') as seccode
,replace(replace(t1.market,chr(13),''),chr(10),'') as market
,replace(replace(t1.secfullname,chr(13),''),chr(10),'') as secfullname
,replace(replace(t1.source,chr(13),''),chr(10),'') as source
,replace(replace(t1.ratebasic,chr(13),''),chr(10),'') as ratebasic
,replace(replace(t1.couponspecies,chr(13),''),chr(10),'') as couponspecies
,replace(replace(t1.interestrate,chr(13),''),chr(10),'') as interestrate
,t1.vdate as vdate
,t1.mdate as mdate
,t1.interestfrequency as interestfrequency
,t1.facevalue as facevalue
,t1.issueprice as issueprice
,t1.paperir as paperir
,replace(replace(t1.intpayrule,chr(13),''),chr(10),'') as intpayrule
,replace(replace(t1.schecalrule,chr(13),''),chr(10),'') as schecalrule
,t1.firstrateday as firstrateday
,replace(replace(t1.workdayrule,chr(13),''),chr(10),'') as workdayrule
,replace(replace(t1.issuershort,chr(13),''),chr(10),'') as issuershort
,replace(replace(t1.isredemption,chr(13),''),chr(10),'') as isredemption
,replace(replace(t1.isprecash,chr(13),''),chr(10),'') as isprecash
,t1.rateresetdate as rateresetdate
,t1.lstmntdate as lstmntdate
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.toprateflag,chr(13),''),chr(10),'') as toprateflag
,t1.toprate as toprate
,replace(replace(t1.bottomrateflag,chr(13),''),chr(10),'') as bottomrateflag
,t1.bottomrate as bottomrate
,replace(replace(t1.ratevaluetype,chr(13),''),chr(10),'') as ratevaluetype
,replace(replace(t1.ratevalueperiod,chr(13),''),chr(10),'') as ratevalueperiod
,replace(replace(t1.ratevaluecdtn,chr(13),''),chr(10),'') as ratevaluecdtn
,t1.ratevaluedays as ratevaluedays
,t1.issueamt as issueamt
,replace(replace(t1.ratecode,chr(13),''),chr(10),'') as ratecode
,t1.spreadrate_8 as spreadrate_8
,t1.coefficient as coefficient
,replace(replace(t1.sectype,chr(13),''),chr(10),'') as sectype
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.counterid,chr(13),''),chr(10),'') as counterid
,replace(replace(t1.counterid2,chr(13),''),chr(10),'') as counterid2
,replace(replace(t1.counterid3,chr(13),''),chr(10),'') as counterid3
,replace(replace(t1.counterid4,chr(13),''),chr(10),'') as counterid4
,t1.importdate as importdate
,replace(replace(t1.calloption,chr(13),''),chr(10),'') as calloption
,replace(replace(t1.putoption,chr(13),''),chr(10),'') as putoption
,replace(replace(t1.comproperty,chr(13),''),chr(10),'') as comproperty
,replace(replace(t1.institution,chr(13),''),chr(10),'') as institution
,replace(replace(t1.institutiontext,chr(13),''),chr(10),'') as institutiontext
,replace(replace(t1.markettext,chr(13),''),chr(10),'') as markettext
,replace(replace(t1.market2,chr(13),''),chr(10),'') as market2
,replace(replace(t1.industry,chr(13),''),chr(10),'') as industry
,replace(replace(t1.checktypecode,chr(13),''),chr(10),'') as checktypecode
,replace(replace(t1.vatbreakeven,chr(13),''),chr(10),'') as vatbreakeven
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_src_secinfo t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_src_secinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes