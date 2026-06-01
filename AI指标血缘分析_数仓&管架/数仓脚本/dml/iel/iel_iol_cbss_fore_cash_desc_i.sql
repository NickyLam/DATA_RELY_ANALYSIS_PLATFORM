: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_fore_cash_desc_i
CreateDate: 20220719
FileName:   ${iel_data_path}/cbss_fore_cash_desc.i.${batch_date}.dat
IF_mark:    i
Logs:
   sundexin
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.trandt,chr(13),''),chr(10),'') as trandt
    ,replace(replace(t.transq,chr(13),''),chr(10),'') as transq
    ,replace(replace(t.purpos,chr(13),''),chr(10),'') as purpos
    ,replace(replace(t.areacd,chr(13),''),chr(10),'') as areacd
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.prcscd,chr(13),''),chr(10),'') as prcscd
    ,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
    ,t.rvam01 as rvam01
    ,t.rvam02 as rvam02
    ,t.rvam03 as rvam03
    ,replace(replace(t.rvch01,chr(13),''),chr(10),'') as rvch01
    ,replace(replace(t.rvch02,chr(13),''),chr(10),'') as rvch02
    ,replace(replace(t.rvch03,chr(13),''),chr(10),'') as rvch03
 from iol.cbss_fore_cash_desc t
where trandt= '${batch_date}' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_fore_cash_desc.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes