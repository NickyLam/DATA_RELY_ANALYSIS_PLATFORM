: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_cif_corp_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_cif_corp_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
custno
,cropcd
,corppr
,corptp
,corpid
,regisz
,opcfno
,regicd
,regicy
,regiam
,dealsp
,psrntg
,locatx
,natitx
,upcrna
,uprgcy
,uprgam
,upcrps
,upidtp
,upidno
,opcfdt
,retxtg
,txdpid
,upopno
,upcpcd
,upmudt
from idl.ecrs_cif_corp
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_cif_corp_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes