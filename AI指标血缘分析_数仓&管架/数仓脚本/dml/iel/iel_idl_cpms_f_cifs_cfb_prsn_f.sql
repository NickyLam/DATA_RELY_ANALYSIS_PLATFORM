: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_f_cifs_cfb_prsn_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_f_cifs_cfb_prsn_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select custno
,prsntp
,renatg
,psrntg
,gender
,brthdt
,age
,brthad
,racecd
,ntplcd
,hutype
,idadss
,homads
,limacd
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
,usertg
,wkexis
,wkutna
,wkctgy
,wkutad
,wkptcd
,wkstat
,workdt
,workyr
,workdy
,ocptid
,dutycd
,roleid
,slryno
,slrybk
,nwhock
,incmyr
,incmfy
,hmyrpy
,gudian
,relatg
,ispart
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
,prfd05 from idl.cpms_f_cifs_cfb_prsn where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_f_cifs_cfb_prsn_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes