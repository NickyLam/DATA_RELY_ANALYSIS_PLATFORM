: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cabs_dephist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/dephist.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(TRANDT,chr(10),''),chr(13),'') as TRANDT,
replace(replace(BILLSQ,chr(10),''),chr(13),'') as BILLSQ,
replace(replace(ACCTNO,chr(10),''),chr(13),'') as ACCTNO,
replace(replace(SUBSAC,chr(10),''),chr(13),'') as SUBSAC,
replace(replace(AMNTCD,chr(10),''),chr(13),'') as AMNTCD ,
TRANAM,
TRANBL,
replace(replace(CRCYCD,chr(10),''),chr(13),'') as CRCYCD,
replace(replace(TOACCT,chr(10),''),chr(13),'') as TOACCT,
replace(replace(TOACNA,chr(10),''),chr(13),'') as TOACNA,
replace(replace(VALUNA ,chr(10),''),chr(13),'') as VALUNA 
from ${idl_schema}.cabs_dephist
;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/dephist.txt" \
        charset=zhs16gbk
        safe=yes
