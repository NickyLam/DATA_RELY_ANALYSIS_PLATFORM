: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_ibs_ptaskrule_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_ibs_ptaskrule_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 jnlno
,transdate
,replace(replace(timertype,chr(13),''),chr(10),'') as timertype
,replace(replace(timerfreq,chr(13),''),chr(10),'') as timerfreq
,replace(replace(timerrule,chr(13),''),chr(10),'') as timerrule
,replace(replace(timerstate,chr(13),''),chr(10),'') as timerstate
,begindate
,enddate
,canceldate
,ordertimes
,exetimes
,replace(replace(bookingtype,chr(13),''),chr(10),'') as bookingtype
,cifseq
,userseq
,replace(replace(authtype,chr(13),''),chr(10),'') as authtype
,replace(replace(transauthtype,chr(13),''),chr(10),'') as transauthtype
,transtime
,suctimes
,sucamt
,failtimes
,failamt
,remaintimes
from iol.ibss_ptaskrule;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_ibs_ptaskrule_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes