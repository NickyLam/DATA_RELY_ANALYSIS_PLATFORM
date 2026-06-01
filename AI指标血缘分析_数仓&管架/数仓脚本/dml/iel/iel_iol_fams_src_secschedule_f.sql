: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_fams_src_secschedule_f
CreateDate: 20180529
FileName:   ${iel_data_path}/fams_src_secschedule.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t1.secid,chr(13),''),chr(10),'') as secid
,t1.schedulenum as schedulenum
,t1.totalintereststartday as totalintereststartday
,t1.totalinterestendday as totalinterestendday
,t1.intereststartday as intereststartday
,t1.interestendday as interestendday
,t1.interestpayday as interestpayday
,t1.couponrate as couponrate
,t1.accrueintamt as accrueintamt
,t1.dailyaccrueint as dailyaccrueint
,t1.lstmntdate as lstmntdate
,replace(replace(t1.lstmntuser,chr(13),''),chr(10),'') as lstmntuser
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,t1.prinamtpay as prinamtpay
,t1.cashpay as cashpay
,t1.prinamt as prinamt
,t1.basicrate as basicrate
,t1.coefficient as coefficient
,t1.spreadrate_8 as spreadrate_8
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,t1.etl_timestamp as etl_timestamp
from iol.fams_src_secschedule t1
where t1.start_dt<=TO_DATE('${batch_date}','yyyymmdd') and t1.end_dt>TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fams_src_secschedule.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes