: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_user_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_user_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select userid
   ,loginid
   ,username
   ,password
   ,belongorg
   ,attribute1
   ,attribute2
   ,attribute3
   ,attribute4
   ,attribute5
   ,attribute6
   ,attribute7
   ,attribute8
   ,attribute
   ,describe1
   ,describe2
   ,describe3
   ,describe4
   ,status
   ,certtype
   ,certid
   ,companytel
   ,mobiletel
   ,email
   ,accountid
   ,id1
   ,id2
   ,sum1
   ,sum2
   ,inputorg
   ,inputuser
   ,inputdate
   ,updatedate
   ,inputtime
   ,updateuser
   ,updatetime
   ,remark
   ,birthday
   ,gender
   ,familyadd
   ,educationalbg
   ,amlevel
   ,title
   ,educationexp
   ,vocationexp
   ,position
   ,qualification
   ,ntid
   ,belongteam
   ,lob
from ${idl_schema}.odss_user_info
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_user_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes