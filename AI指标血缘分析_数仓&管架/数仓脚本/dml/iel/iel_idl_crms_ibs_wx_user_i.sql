: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ibs_wx_user_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ibs_wx_user_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
userseq
,tousername
,openid
,cifno
,userstate
,binddate
,unbinddate
,idtype
,idno
,ciflevel
,cifseq
,password
,userpausestate
,pausedate
,pauseenddate
,userfreezestate
,pwdstate
,pwdlockdate
,pwdfailcount
,finstate
,findate
,prdcode
from ${idl_schema}.crms_ibs_wx_user
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ibs_wx_user_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes