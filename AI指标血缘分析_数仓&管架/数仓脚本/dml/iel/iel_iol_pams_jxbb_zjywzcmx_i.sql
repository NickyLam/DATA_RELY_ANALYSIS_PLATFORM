: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zjywzcmx_i
CreateDate: 20241105
FileName:   ${iel_data_path}/pams_jxbb_zjywzcmx.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,khdxdh
,gsjgdxdh
,replace(replace(t1.gsjgdh,chr(13),''),chr(10),'') as gsjgdh
,replace(replace(t1.gsjgmc,chr(13),''),chr(10),'') as gsjgmc
,zwjgdxdh
,replace(replace(t1.zwjgdh,chr(13),''),chr(10),'') as zwjgdh
,replace(replace(t1.zwjgmc,chr(13),''),chr(10),'') as zwjgmc
,replace(replace(t1.khlx,chr(13),''),chr(10),'') as khlx
,replace(replace(t1.jylsh,chr(13),''),chr(10),'') as jylsh
,replace(replace(t1.qjlsh,chr(13),''),chr(10),'') as qjlsh
,replace(replace(t1.ywlsh,chr(13),''),chr(10),'') as ywlsh
,replace(replace(t1.sfdjh,chr(13),''),chr(10),'') as sfdjh
,replace(replace(t1.sflsh,chr(13),''),chr(10),'') as sflsh
,sfrq
,jsrq
,zwrq
,replace(replace(t1.txbz,chr(13),''),chr(10),'') as txbz
,replace(replace(t1.txlsh,chr(13),''),chr(10),'') as txlsh
,txksrq
,txjsrq
,ljtxje
,dtze
,jyje
,replace(replace(t1.bz,chr(13),''),chr(10),'') as bz
,replace(replace(t1.kmh,chr(13),''),chr(10),'') as kmh
,replace(replace(t1.kmmc,chr(13),''),chr(10),'') as kmmc
,replace(replace(t1.bzcpbh,chr(13),''),chr(10),'') as bzcpbh
,replace(replace(t1.khh,chr(13),''),chr(10),'') as khh
,replace(replace(t1.khmc,chr(13),''),chr(10),'') as khmc
,replace(replace(t1.khgstxlxdm,chr(13),''),chr(10),'') as khgstxlxdm
,replace(replace(t1.jyjgdh,chr(13),''),chr(10),'') as jyjgdh
,jyjgdxdh
,replace(replace(t1.jyjgmc,chr(13),''),chr(10),'') as jyjgmc
,replace(replace(t1.jyzhbh,chr(13),''),chr(10),'') as jyzhbh
,replace(replace(t1.jyzzhbh,chr(13),''),chr(10),'') as jyzzhbh
,replace(replace(t1.jyczhbh,chr(13),''),chr(10),'') as jyczhbh
,replace(replace(t1.jyqddm,chr(13),''),chr(10),'') as jyqddm
,replace(replace(t1.yxtdm,chr(13),''),chr(10),'') as yxtdm
,replace(replace(t1.hydh,chr(13),''),chr(10),'') as hydh
,replace(replace(t1.hymc,chr(13),''),chr(10),'') as hymc
,replace(replace(t1.sffsdm,chr(13),''),chr(10),'') as sffsdm
,replace(replace(t1.sxfzqfs,chr(13),''),chr(10),'') as sxfzqfs
,replace(replace(t1.jylxdm,chr(13),''),chr(10),'') as jylxdm
,replace(replace(t1.jdbz,chr(13),''),chr(10),'') as jdbz
,replace(replace(t1.mzbz,chr(13),''),chr(10),'') as mzbz
,replace(replace(t1.czbz,chr(13),''),chr(10),'') as czbz
,replace(replace(t1.xjjybz,chr(13),''),chr(10),'') as xjjybz
,replace(replace(t1.etl_t,chr(13),''),chr(10),'') as etl_t
,replace(replace(t1.ywzhbh,chr(13),''),chr(10),'') as ywzhbh
,replace(replace(t1.ybbz,chr(13),''),chr(10),'') as ybbz
,jyjeylj
,jyjejlj
,jyjenlj

from ${iol_schema}.pams_jxbb_zjywzcmx t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zjywzcmx.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
