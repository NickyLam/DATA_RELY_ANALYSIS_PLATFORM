: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cpms_f_cifs_cfb_cust_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cpms_f_cifs_cfb_cust_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select custno
,custcn
,custen
,custlc
,custle
,custtp
,custlv
,statlv
,jonttg
,isblak
,doubtp
,tttrib
,ttrema
,risklv
,custst
,opendt
,openbr
,openus
,closdt
,closbr
,closus
,datatp
,crecdt
,cardlevel
,bankage from idl.cpms_f_cifs_cfb_cust where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/cpms_f_cifs_cfb_cust_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes