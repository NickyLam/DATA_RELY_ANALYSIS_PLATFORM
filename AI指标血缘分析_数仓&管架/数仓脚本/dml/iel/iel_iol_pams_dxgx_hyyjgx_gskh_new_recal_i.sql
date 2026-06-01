: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_dxgx_hyyjgx_gskh_new_recal_i
CreateDate: 20250829
FileName:   ${iel_data_path}/pams_dxgx_hyyjgx_gskh_new_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,recal_dt
,jxdxdh
,khdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx
,yz
,clbl
,zlbl
,replace(replace(t1.gxly,chr(13),''),chr(10),'') as gxly
,replace(replace(t1.gxzt,chr(13),''),chr(10),'') as gxzt

from ${iol_schema}.pams_dxgx_hyyjgx_gskh_new_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_dxgx_hyyjgx_gskh_new_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
