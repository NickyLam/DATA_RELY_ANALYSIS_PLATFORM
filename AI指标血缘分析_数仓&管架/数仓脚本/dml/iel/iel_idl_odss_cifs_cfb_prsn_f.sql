: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_cifs_cfb_prsn_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_cifs_cfb_prsn_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
custno
,prsntp
,renatg
,psrntg
,gender
,brthdt
,brthad
,racecd
,ntlycd
,rgstad
,sjcate
,oralla
,marrst
,plvscd
,health
,fvrttx
,chartg
,credre
,fmlynm
,livest
,finled
,degree
,school
,insrid
,lncdno
,lncdpw
,lncdtg
,lncddt
,lncdst
,lcditg
,lcdidt
,lcdrdt
,usertg
,wkutna
,wkctgy
,wkutad
,wkptcd
,wkstat
,ocptid
,dutycd
,roleid
,workdy
,incmyr
,incmfy
,hmyrpy
,gudian
,relatg
,mtname
,mttype
,mttyid
,mtwork
,mtphon
,remark
,prfd01
,prfd02
,prfd03
,prfd04
,prfd05
,ispart
,slrybk
,slryno
,nwhock
,workyr
,workdt
,wkexis
,limacd
,homads
,idadss
,hutype
,ntplcd
,hmsupp
,hmasse
,identf
from ${idl_schema}.odss_cifs_cfb_prsn
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_cifs_cfb_prsn_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes