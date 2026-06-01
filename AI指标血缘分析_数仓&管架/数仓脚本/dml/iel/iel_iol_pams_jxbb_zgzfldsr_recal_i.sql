: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_pams_jxbb_zgzfldsr_recal_i
CreateDate: 20250710
FileName:   ${iel_data_path}/pams_jxbb_zgzfldsr_recal.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,tjrq
,jxdxdh
,sjrq
,replace(replace(t1.zcbm,chr(13),''),chr(10),'') as zcbm
,replace(replace(t1.zcmc,chr(13),''),chr(10),'') as zcmc
,zcqxr
,zcdqr
,fzdqr
,replace(replace(t1.jxjc,chr(13),''),chr(10),'') as jxjc
,csfxje
,cxje
,zcsyl
,fhfcbl
,zjcb
,replace(replace(t1.fzcb,chr(13),''),chr(10),'') as fzcb
,fhfcje
,shfhfcje
,tzfcje
,shtzfcje
,fhfchj
,shfhfchj
,replace(replace(t1.ssfh,chr(13),''),chr(10),'') as ssfh
,replace(replace(t1.sskhjlgh,chr(13),''),chr(10),'') as sskhjlgh
,hyfcbl
,shkhjlfchj
,replace(replace(t1.sszhjgdh,chr(13),''),chr(10),'') as sszhjgdh
,replace(replace(t1.sszhjgmc,chr(13),''),chr(10),'') as sszhjgmc
,replace(replace(t1.beiz,chr(13),''),chr(10),'') as beiz
,recal_dt

from ${iol_schema}.pams_jxbb_zgzfldsr_recal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pams_jxbb_zgzfldsr_recal.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
