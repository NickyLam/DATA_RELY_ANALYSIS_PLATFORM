: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_isbs_v_fee_inf_i
CreateDate: 20231110
FileName:   ${iel_data_path}/isbs_v_fee_inf.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.finr,chr(13),''),chr(10),'') as finr
,replace(replace(t1.fdat,chr(13),''),chr(10),'') as fdat
,replace(replace(t1.fbchnam,chr(13),''),chr(10),'') as fbchnam
,replace(replace(t1.fcno,chr(13),''),chr(10),'') as fcno
,replace(replace(t1.fact,chr(13),''),chr(10),'') as fact
,replace(replace(t1.fcur,chr(13),''),chr(10),'') as fcur
,famt
,replace(replace(t1.ftxt,chr(13),''),chr(10),'') as ftxt
,replace(replace(t1.ftyp,chr(13),''),chr(10),'') as ftyp

from ${iol_schema}.isbs_v_fee_inf t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/isbs_v_fee_inf.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
