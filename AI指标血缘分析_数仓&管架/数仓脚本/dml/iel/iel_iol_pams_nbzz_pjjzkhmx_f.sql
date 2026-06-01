: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_nbzz_pjjzkhmx_f
CreateDate: 20240919
FileName:   ${iel_data_path}/pams_nbzz_pjjzkhmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,cknrj
,nljsy
,ckljsy
,sxfljsy
,txljsy

from ${iol_schema}.pams_nbzz_pjjzkhmx t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_nbzz_pjjzkhmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
