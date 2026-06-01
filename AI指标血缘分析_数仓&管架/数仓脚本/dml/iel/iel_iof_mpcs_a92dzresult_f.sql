: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a92dzresult_f
CreateDate: 20251112
FileName:   ${iel_data_path}/mpcs_a92dzresult.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.ztsdatetime,chr(13),''),chr(10),'') as ztsdatetime
,replace(replace(t1.settldate,chr(13),''),chr(10),'') as settldate
,replace(replace(t1.ymstatus,chr(13),''),chr(10),'') as ymstatus
,replace(replace(t1.acctdatestatus,chr(13),''),chr(10),'') as acctdatestatus
,replace(replace(t1.fcdivstatus,chr(13),''),chr(10),'') as fcdivstatus
,replace(replace(t1.fcdivtotcount,chr(13),''),chr(10),'') as fcdivtotcount
,replace(replace(t1.fcdivtotamt,chr(13),''),chr(10),'') as fcdivtotamt
,replace(replace(t1.fcintotcount,chr(13),''),chr(10),'') as fcintotcount
,replace(replace(t1.fcintotamt,chr(13),''),chr(10),'') as fcintotamt
,replace(replace(t1.fcouttotcount,chr(13),''),chr(10),'') as fcouttotcount
,replace(replace(t1.fcouttotamt,chr(13),''),chr(10),'') as fcouttotamt
,replace(replace(t1.cbsincount,chr(13),''),chr(10),'') as cbsincount
,replace(replace(t1.cbsinamt,chr(13),''),chr(10),'') as cbsinamt
,replace(replace(t1.cbsoutcount,chr(13),''),chr(10),'') as cbsoutcount
,replace(replace(t1.cbsoutamt,chr(13),''),chr(10),'') as cbsoutamt
,replace(replace(t1.cbsdivcount,chr(13),''),chr(10),'') as cbsdivcount
,replace(replace(t1.cbsdivamt,chr(13),''),chr(10),'') as cbsdivamt
,replace(replace(t1.dzerrmsg,chr(13),''),chr(10),'') as dzerrmsg
,replace(replace(t1.isworkday,chr(13),''),chr(10),'') as isworkday
,replace(replace(t1.reserve1,chr(13),''),chr(10),'') as reserve1
,replace(replace(t1.reserve2,chr(13),''),chr(10),'') as reserve2
,replace(replace(t1.reserve3,chr(13),''),chr(10),'') as reserve3
,replace(replace(t1.reserve4,chr(13),''),chr(10),'') as reserve4
,replace(replace(t1.reserve5,chr(13),''),chr(10),'') as reserve5
,replace(replace(t1.ordertotamt,chr(13),''),chr(10),'') as ordertotamt
,replace(replace(t1.ordertotcount,chr(13),''),chr(10),'') as ordertotcount
,replace(replace(t1.confirmtotamt,chr(13),''),chr(10),'') as confirmtotamt
,replace(replace(t1.confirmtotcount,chr(13),''),chr(10),'') as confirmtotcount
,replace(replace(t1.nettingoutflg,chr(13),''),chr(10),'') as nettingoutflg
,replace(replace(t1.nettinginflg,chr(13),''),chr(10),'') as nettinginflg

from ${iol_schema}.mpcs_a92dzresult t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a92dzresult.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
