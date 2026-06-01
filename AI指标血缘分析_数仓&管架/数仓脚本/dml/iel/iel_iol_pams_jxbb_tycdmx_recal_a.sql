: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_tycdmx_recal_a
CreateDate: 20250609
FileName:   ${iel_data_path}/pams_jxbb_tycdmx_recal.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,tjrq
,jxdxdh
,khdxdh
,jgkhdxdh
,replace(replace(t1.jgdh,chr(13),''),chr(10),'') as jgdh
,replace(replace(t1.jgmc,chr(13),''),chr(10),'') as jgmc
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.ywbh,chr(13),''),chr(10),'') as ywbh
,replace(replace(t1.cddm,chr(13),''),chr(10),'') as cddm
,replace(replace(t1.cdjc,chr(13),''),chr(10),'') as cdjc
,ssjgkhdxdh
,replace(replace(t1.ssjgdh,chr(13),''),chr(10),'') as ssjgdh
,replace(replace(t1.ssjgmc,chr(13),''),chr(10),'') as ssjgmc
,fxrq
,qxrq
,dqrq
,dfrq
,replace(replace(t1.qx,chr(13),''),chr(10),'') as qx
,jxts
,fxjg
,nll
,fxl
,fxje
,bqye
,replace(replace(t1.sjtzrkhh,chr(13),''),chr(10),'') as sjtzrkhh
,replace(replace(t1.sjtzrqc,chr(13),''),chr(10),'') as sjtzrqc
,replace(replace(t1.fxjgmc,chr(13),''),chr(10),'') as fxjgmc
,replace(replace(t1.xsjgmc,chr(13),''),chr(10),'') as xsjgmc
,nrj
,yrj
,nzc
,yzc
,ftpll
,dyftpjsr
,ljftpjsr
,fpbl
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,ftplxsrylj
,ftplxsrnlj
,rzc
,drftpjsr
,dnftpjsr
,ftplxsr
,replace(replace(t1.xsjgmczh,chr(13),''),chr(10),'') as xsjgmczh
,replace(replace(t1.xsjgmczb,chr(13),''),chr(10),'') as xsjgmczb
,replace(replace(t1.gsjgmczh,chr(13),''),chr(10),'') as gsjgmczh
,replace(replace(t1.gsjgmczb,chr(13),''),chr(10),'') as gsjgmczb
,replace(replace(t1.cpdm,chr(13),''),chr(10),'') as cpdm
,replace(replace(t1.fptx,chr(13),''),chr(10),'') as fptx
,txfpbl
,replace(replace(t1.cjdrgjgkhh,chr(13),''),chr(10),'') as cjdrgjgkhh
,replace(replace(t1.cjdrgjg,chr(13),''),chr(10),'') as cjdrgjg
,replace(replace(t1.sjrgfkhh,chr(13),''),chr(10),'') as sjrgfkhh
,replace(replace(t1.sjrgfqc,chr(13),''),chr(10),'') as sjrgfqc
,tycb
,recal_dt

from ${iol_schema}.pams_jxbb_tycdmx_recal t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_tycdmx_recal.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
