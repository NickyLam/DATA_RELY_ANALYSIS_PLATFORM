: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_cif_cifs_knp_para_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_cif_cifs_knp_para_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
subscd
,paratp
,paracd
,parana
,paraam
,paradt
,parach
,parbch
,parcch
,pardch
,parech
,enblst
from ${idl_schema}.crms_cif_cifs_knp_para
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_cif_cifs_knp_para_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes