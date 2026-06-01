: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_nibs_ib_log_finance_log_i
CreateDate: 20231115
FileName:   ${iel_data_path}/nibs_ib_log_finance_log.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.tx_seq,chr(13),''),chr(10),'') as tx_seq
,replace(replace(t1.financestatus,chr(13),''),chr(10),'') as financestatus
,trandate
,trantim
,replace(replace(t1.trancode,chr(13),''),chr(10),'') as trancode
,replace(replace(t1.branchnum,chr(13),''),chr(10),'') as branchnum
,replace(replace(t1.usernum,chr(13),''),chr(10),'') as usernum
,replace(replace(t1.actflag,chr(13),''),chr(10),'') as actflag
,replace(replace(t1.servicecontent,chr(13),''),chr(10),'') as servicecontent
,replace(replace(t1.tranccy,chr(13),''),chr(10),'') as tranccy
,tranamt
,replace(replace(t1.drawccy,chr(13),''),chr(10),'') as drawccy
,drawamt
,replace(replace(t1.applyname,chr(13),''),chr(10),'') as applyname
,replace(replace(t1.applysex,chr(13),''),chr(10),'') as applysex
,applybirthday
,replace(replace(t1.applycountry,chr(13),''),chr(10),'') as applycountry
,replace(replace(t1.applycerttype,chr(13),''),chr(10),'') as applycerttype
,replace(replace(t1.applycertnum,chr(13),''),chr(10),'') as applycertnum
,replace(replace(t1.applycertsta,chr(13),''),chr(10),'') as applycertsta
,replace(replace(t1.applycertend,chr(13),''),chr(10),'') as applycertend
,replace(replace(t1.certbranchnum,chr(13),''),chr(10),'') as certbranchnum
,replace(replace(t1.certbranchaddr,chr(13),''),chr(10),'') as certbranchaddr
,replace(replace(t1.loc,chr(13),''),chr(10),'') as loc
,replace(replace(t1.postcode,chr(13),''),chr(10),'') as postcode
,replace(replace(t1.telephone,chr(13),''),chr(10),'') as telephone
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.actnaem,chr(13),''),chr(10),'') as actnaem
,replace(replace(t1.actcountry,chr(13),''),chr(10),'') as actcountry
,replace(replace(t1.actcerttyp,chr(13),''),chr(10),'') as actcerttyp
,replace(replace(t1.actcertnum,chr(13),''),chr(10),'') as actcertnum
,replace(replace(t1.actcertsta,chr(13),''),chr(10),'') as actcertsta
,replace(replace(t1.actcertend,chr(13),''),chr(10),'') as actcertend
,replace(replace(t1.acttelephone,chr(13),''),chr(10),'') as acttelephone
,replace(replace(t1.actphone,chr(13),''),chr(10),'') as actphone
,replace(replace(t1.actreason,chr(13),''),chr(10),'') as actreason
,replace(replace(t1.careerone,chr(13),''),chr(10),'') as careerone
,replace(replace(t1.careertwo,chr(13),''),chr(10),'') as careertwo
,replace(replace(t1.careeronename,chr(13),''),chr(10),'') as careeronename
,replace(replace(t1.careertwoname,chr(13),''),chr(10),'') as careertwoname
,replace(replace(t1.careerdesc,chr(13),''),chr(10),'') as careerdesc
,replace(replace(t1.cretaddrflag,chr(13),''),chr(10),'') as cretaddrflag
,replace(replace(t1.cretprovincecode,chr(13),''),chr(10),'') as cretprovincecode
,replace(replace(t1.cretcitycode,chr(13),''),chr(10),'') as cretcitycode
,replace(replace(t1.cretcountycode,chr(13),''),chr(10),'') as cretcountycode
,replace(replace(t1.cretprovincename,chr(13),''),chr(10),'') as cretprovincename
,replace(replace(t1.cretcityname,chr(13),''),chr(10),'') as cretcityname
,replace(replace(t1.cretcountyname,chr(13),''),chr(10),'') as cretcountyname
,replace(replace(t1.cretaddresdesc,chr(13),''),chr(10),'') as cretaddresdesc
,replace(replace(t1.provincecode,chr(13),''),chr(10),'') as provincecode
,replace(replace(t1.citycode,chr(13),''),chr(10),'') as citycode
,replace(replace(t1.countycode,chr(13),''),chr(10),'') as countycode
,replace(replace(t1.provincename,chr(13),''),chr(10),'') as provincename
,replace(replace(t1.cityname,chr(13),''),chr(10),'') as cityname
,replace(replace(t1.countyname,chr(13),''),chr(10),'') as countyname
,replace(replace(t1.addresdesc,chr(13),''),chr(10),'') as addresdesc
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5

from ${iol_schema}.nibs_ib_log_finance_log t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/nibs_ib_log_finance_log.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
