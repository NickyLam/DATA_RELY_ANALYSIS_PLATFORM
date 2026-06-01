: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_lsxdcptjwbzmy_jg_recal_i
CreateDate: 20250819
FileName:   ${iel_data_path}/pams_jxbb_lsxdcptjwbzmy_jg_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jgkhdxdh
,replace(replace(t1.jgjb,chr(13),''),chr(10),'') as jgjb
,replace(replace(t1.fpjs,chr(13),''),chr(10),'') as fpjs
,replace(replace(t1.cpbh,chr(13),''),chr(10),'') as cpbh
,replace(replace(t1.cpmc,chr(13),''),chr(10),'') as cpmc
,hyye
,yrj
,jrj
,nrj
,jsr
,jsrylj
,jsrjlj
,jsrnlj
,lxsrylj
,lxsrjlj
,lxsrnlj
,ftpzycbnlj
,replace(replace(t1.xwdkbs,chr(13),''),chr(10),'') as xwdkbs
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.zdbfs,chr(13),''),chr(10),'') as zdbfs
,replace(replace(t1.zhbs,chr(13),''),chr(10),'') as zhbs
,lxsr
,fkje
,zxll
,replace(replace(t1.jjh,chr(13),''),chr(10),'') as jjh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,ffrq
,recal_dt

from ${iol_schema}.pams_jxbb_lsxdcptjwbzmy_jg_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_lsxdcptjwbzmy_jg_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
