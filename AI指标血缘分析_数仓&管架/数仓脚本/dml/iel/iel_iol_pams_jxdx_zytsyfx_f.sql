: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxdx_zytsyfx_f
CreateDate: 20240131
FileName:   ${iel_data_path}/pams_jxdx_zytsyfx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,jxdxdh
,replace(replace(t1.tjrq,chr(13),''),chr(10),'') as tjrq
,replace(replace(t1.zqdm,chr(13),''),chr(10),'') as zqdm
,tzid
,replace(replace(t1.zqmc,chr(13),''),chr(10),'') as zqmc
,replace(replace(t1.qxrq,chr(13),''),chr(10),'') as qxrq
,replace(replace(t1.dqrq,chr(13),''),chr(10),'') as dqrq
,me
,sybj
,pjcb
,zytjj
,yjlx
,replace(replace(t1.zcfzfl,chr(13),''),chr(10),'') as zcfzfl
,replace(replace(t1.zqdmmc,chr(13),''),chr(10),'') as zqdmmc
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,xzrq
,replace(replace(t1.dv01,chr(13),''),chr(10),'') as dv01
,replace(replace(t1.jytzmc,chr(13),''),chr(10),'') as jytzmc
,replace(replace(t1.tzsfl,chr(13),''),chr(10),'') as tzsfl
,zhid
,replace(replace(t1.zhdm,chr(13),''),chr(10),'') as zhdm
,replace(replace(t1.zhmc,chr(13),''),chr(10),'') as zhmc
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.bzcp,chr(13),''),chr(10),'') as bzcp
,dqsyl
,replace(replace(t1.dcq,chr(13),''),chr(10),'') as dcq
,replace(replace(t1.zqlx,chr(13),''),chr(10),'') as zqlx
,lxsr
,zyt
,mmjc
,fdyk
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,khdxdh
,replace(replace(t1.gxhslx,chr(13),''),chr(10),'') as gxhslx

from ${iol_schema}.pams_jxdx_zytsyfx t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxdx_zytsyfx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
