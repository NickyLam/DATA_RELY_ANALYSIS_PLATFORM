: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_o_ibs_peacctcif_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_o_ibs_peacctcif_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        acctseq
       ,replace(replace(rtrim(t1.idtype),chr(13),''),chr(10),'') as idtype
       ,replace(replace(rtrim(t1.idno),chr(13),''),chr(10),'') as idno
       ,replace(replace(rtrim(t1.cifname),chr(13),''),chr(10),'') as cifname
       ,replace(replace(rtrim(t1.cifno),chr(13),''),chr(10),'') as cifno
       ,replace(replace(rtrim(t1.acno),chr(13),''),chr(10),'') as acno
       ,replace(replace(rtrim(t1.deptid),chr(13),''),chr(10),'') as deptid
       ,replace(replace(rtrim(t1.password),chr(13),''),chr(10),'') as password
       ,replace(replace(rtrim(t1.mobilephone),chr(13),''),chr(10),'') as mobilephone
       ,replace(replace(rtrim(t1.bindacno),chr(13),''),chr(10),'') as bindacno
       ,replace(replace(rtrim(t1.openid),chr(13),''),chr(10),'') as openid
       ,replace(replace(rtrim(t1.tousername),chr(13),''),chr(10),'') as tousername
       ,replace(replace(rtrim(t1.referrerno),chr(13),''),chr(10),'') as referrerno
       ,replace(replace(rtrim(t1.referrerphone),chr(13),''),chr(10),'') as referrerphone
       ,replace(replace(rtrim(t1.referreropenid),chr(13),''),chr(10),'') as referreropenid
       ,opendate
       ,activedate
       ,replace(replace(rtrim(t1.state),chr(13),''),chr(10),'') as state
       ,replace(replace(rtrim(t1.signchannel),chr(13),''),chr(10),'') as signchannel
 from iol.ibss_peacctcif t1
;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_o_ibs_peacctcif_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes