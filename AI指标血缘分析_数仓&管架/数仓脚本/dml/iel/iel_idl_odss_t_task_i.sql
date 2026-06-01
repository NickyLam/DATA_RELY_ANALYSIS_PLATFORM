: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_t_task_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_t_task_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,taskid
,taskname
,tasktype
,srcid
,msgtype
,msgtype2
,msgtype3
,msgtype4
,busitype
,busicode
,subport
,priority
,status
,objtype
,objno
,maxrecs
,maxdayrecs
,feeflag
,wordflag
,strflag
,commentflag
,contenttype
,filetype
,commentno
,content
,spid
,scheduledate
,scheduletime
,deadlinedate
,deadlinetime
,srvtimeno
,policyid
,senddeptid
,senduserid
,checkuserid1
,checkuserid2
,approveuserid1
,approveuserid2
,crtuserid
,crtdate
,crttime
,checkflag
,checkdate
,checktime
,checkuserid
,approveflag
,approvedate
,approvetime
,approveuserid
,begindate
,begintime
,enddate
,endtime
,pausedate
,pausetime
,filesize
,recordtotals
,totals
,finishtotals
,refreshdate
,refreshtime
,totals1
,finishtotals1
,sendtotals1
,succtotals1
,totals2
,finishtotals2
,sendtotals2
,succtotals2
,totals3
,finishtotals3
,sendtotals3
,succtotals3
,totals4
,finishtotals4
,sendtotals4
,succtotals4
,flag
,workdate
,dayrecs
,alldayflag
,nextsenddate
,nextsendtime
,starttime1
,endtime1
,starttime2
,endtime2
,starttime3
,endtime3
,holidayflag
,srcidflag
,remark
,flag1
,flag2
,remark1
,remark2
,blackfiles
,sepchar
,fromno
from ${idl_schema}.odss_t_task
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_t_task_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes