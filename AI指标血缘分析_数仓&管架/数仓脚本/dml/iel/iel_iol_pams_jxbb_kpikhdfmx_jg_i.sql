: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_kpikhdfmx_jg_i
CreateDate: 20250804
FileName:   ${iel_data_path}/pams_jxbb_kpikhdfmx_jg.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,khdxdh
,replace(replace(t1.fabh,chr(13),''),chr(10),'') as fabh
,replace(replace(t1.famc,chr(13),''),chr(10),'') as famc
,replace(replace(t1.zbmc,chr(13),''),chr(10),'') as zbmc
,bzdf
,dfsx
,dfxx
,ndmbz
,sjjdz
,js
,zbz
,jzz
,khdf
,ndwcl
,sjjdwcl
,xh

from ${iol_schema}.pams_jxbb_kpikhdfmx_jg t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_kpikhdfmx_jg.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
