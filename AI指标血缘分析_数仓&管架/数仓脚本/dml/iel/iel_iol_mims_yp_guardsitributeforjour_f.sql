: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mims_yp_guardsitributeforjour_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mims_yp_guardsitributeforjour.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sccode,chr(13),''),chr(10),'') as sccode
    ,replace(replace(t.contractno,chr(13),''),chr(10),'') as contractno
    ,t.balance as balance
    ,t.distvalue as distvalue
    ,replace(replace(t.contguartype,chr(13),''),chr(10),'') as contguartype
    ,replace(replace(t.guartype,chr(13),''),chr(10),'') as guartype
    ,replace(replace(t.credittype,chr(13),''),chr(10),'') as credittype
    ,replace(replace(t.barsign,chr(13),''),chr(10),'') as barsign
    ,replace(replace(t.interindustry,chr(13),''),chr(10),'') as interindustry
    ,replace(replace(t.custscale,chr(13),''),chr(10),'') as custscale
    ,replace(replace(t.reporttype,chr(13),''),chr(10),'') as reporttype
    ,replace(replace(t.deptcode,chr(13),''),chr(10),'') as deptcode
    ,replace(replace(t.fiveclass,chr(13),''),chr(10),'') as fiveclass
    ,replace(replace(t.credno,chr(13),''),chr(10),'') as credno
    ,t.bal as bal
    ,t.confmamt as confmamt
    ,t.firstconfmamt as firstconfmamt
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.mims_yp_guardsitributeforjour t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mims_yp_guardsitributeforjour.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes