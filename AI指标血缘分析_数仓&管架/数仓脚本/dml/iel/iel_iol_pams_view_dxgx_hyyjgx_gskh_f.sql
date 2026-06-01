: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_view_dxgx_hyyjgx_gskh_f
CreateDate: 20240416
FileName:   ${iel_data_path}/pams_view_dxgx_hyyjgx_gskh.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,khdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,qsrq
,jsrq
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,yz
,clbl
,zlbl
,replace(replace(t1.gxly,chr(13),''),chr(10),'') as gxly

from ${iol_schema}.pams_view_dxgx_hyyjgx_gskh t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_view_dxgx_hyyjgx_gskh.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
