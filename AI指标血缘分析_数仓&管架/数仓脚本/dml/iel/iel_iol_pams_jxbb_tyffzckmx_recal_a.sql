: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_tyffzckmx_recal_a
CreateDate: 20250609
FileName:   ${iel_data_path}/pams_jxbb_tyffzckmx_recal.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tjrq
,jxdxdh
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.jrgjdm,chr(13),''),chr(10),'') as jrgjdm
,replace(replace(t1.jrgjmc,chr(13),''),chr(10),'') as jrgjmc
,replace(replace(t1.jyssjgdh,chr(13),''),chr(10),'') as jyssjgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.kjfl,chr(13),''),chr(10),'') as kjfl
,replace(replace(t1.cplx,chr(13),''),chr(10),'') as cplx
,jyrq
,replace(replace(t1.jydskhh,chr(13),''),chr(10),'') as jydskhh
,replace(replace(t1.jyds,chr(13),''),chr(10),'') as jyds
,replace(replace(t1.jydslx,chr(13),''),chr(10),'') as jydslx
,replace(replace(t1.sjrzrkhh,chr(13),''),chr(10),'') as sjrzrkhh
,replace(replace(t1.sjrzr,chr(13),''),chr(10),'') as sjrzr
,replace(replace(t1.sjrzrlx,chr(13),''),chr(10),'') as sjrzrlx
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,tzbj
,zxll
,qxr
,dqr
,scfxrq
,replace(replace(t1.fxpl,chr(13),''),chr(10),'') as fxpl
,replace(replace(t1.jxjz,chr(13),''),chr(10),'') as jxjz
,tzye
,zmye
,dqgyjgbdsy
,drlxsr
,dylxsr
,bnlxsr
,ljlxsr
,drlxzc
,dylxzc
,djlxzc
,dnlxzc
,lxsrzzs
,bnmmsy
,ljmmsy
,yzbwlx
,replace(replace(t1.bjkmh,chr(13),''),chr(10),'') as bjkmh
,replace(replace(t1.bjkmmc,chr(13),''),chr(10),'') as bjkmmc
,ftpll
,zhnrjye
,zhjrjye
,zhyrjye
,fphyrj
,fphjrj
,fphnrj
,zjsr
,ftpsyrlj
,ftpsyylj
,ftpsynlj
,ftpsyljlj
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,khdxdh
,zlbl
,replace(replace(t1.xplx,chr(13),''),chr(10),'') as xplx
,replace(replace(t1.jydslxms,chr(13),''),chr(10),'') as jydslxms
,replace(replace(t1.sjrzrlxms,chr(13),''),chr(10),'') as sjrzrlxms
,replace(replace(t1.jxjzms,chr(13),''),chr(10),'') as jxjzms
,replace(replace(t1.cplxmc,chr(13),''),chr(10),'') as cplxmc
,replace(replace(t1.sjly,chr(13),''),chr(10),'') as sjly
,replace(replace(t1.tzid,chr(13),''),chr(10),'') as tzid
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl
,hsfxjqzcje
,tzsy
,tzsyylj
,tzsyjlj
,tzsynlj
,blqtzsy
,blqtzsyylj
,blqtzsyjlj
,blqtzsynlj
,blsyje
,blsyjeylj
,blsyjejlj
,blsyjenlj
,recal_dt
,jgkhdxdh

from ${iol_schema}.pams_jxbb_tyffzckmx_recal t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_tyffzckmx_recal.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
