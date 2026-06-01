: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_pjcbsyfxmx_f
CreateDate: 20240124
FileName:   ${iel_data_path}/pams_jxbb_pjcbsyfxmx.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,zlbl
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.gsjgdh,chr(13),''),chr(10),'') as gsjgdh
,replace(replace(t1.gsjgmc,chr(13),''),chr(10),'') as gsjgmc
,replace(replace(t1.zqdm,chr(13),''),chr(10),'') as zqdm
,replace(replace(t1.zqmc,chr(13),''),chr(10),'') as zqmc
,replace(replace(t1.qxrq,chr(13),''),chr(10),'') as qxrq
,replace(replace(t1.dqrq,chr(13),''),chr(10),'') as dqrq
,hyme
,hymeylj
,hymenlj
,hysybj
,hysybjylj
,hysybjnlj
,hypjcb
,hypjcbylj
,hypjcbnlj
,hyzytjj
,hyzytjjylj
,hyzytjjnlj
,hyyjlx
,hyyjlxylj
,hyyjlxnlj
,replace(replace(t1.zcfzfl,chr(13),''),chr(10),'') as zcfzfl
,replace(replace(t1.zqdmmc,chr(13),''),chr(10),'') as zqdmmc
,xzrq
,replace(replace(t1.dv01,chr(13),''),chr(10),'') as dv01
,tzid
,replace(replace(t1.jytzmc,chr(13),''),chr(10),'') as jytzmc
,replace(replace(t1.tzsfl,chr(13),''),chr(10),'') as tzsfl
,zhid
,replace(replace(t1.zhdm,chr(13),''),chr(10),'') as zhdm
,replace(replace(t1.zhmc,chr(13),''),chr(10),'') as zhmc
,replace(replace(t1.khjg,chr(13),''),chr(10),'') as khjg
,replace(replace(t1.bzcp,chr(13),''),chr(10),'') as bzcp
,dqsyl
,replace(replace(t1.dcq,chr(13),''),chr(10),'') as dcq
,replace(replace(t1.zqlx,chr(13),''),chr(10),'') as zqlx
,hylxsr
,hylxsrylj
,hylxsrnlj
,hyzyt
,hyzytylj
,hyzytnlj
,hymmjc
,hymmjcylj
,hymmjcnlj
,hyfdyk
,hyfdykylj
,hyfdyknlj

from ${iol_schema}.pams_jxbb_pjcbsyfxmx t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_pjcbsyfxmx.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
