: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_iers_fip_relation_f
CreateDate: 20230130
FileName:   ${iel_data_path}/iers_fip_relation.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.batchno,chr(13),''),chr(10),'') as batchno
,replace(replace(t1.busimessage1,chr(13),''),chr(10),'') as busimessage1
,replace(replace(t1.busimessage2,chr(13),''),chr(10),'') as busimessage2
,replace(replace(t1.busimessage3,chr(13),''),chr(10),'') as busimessage3
,replace(replace(t1.des_billtype,chr(13),''),chr(10),'') as des_billtype
,replace(replace(t1.des_busidate,chr(13),''),chr(10),'') as des_busidate
,replace(replace(t1.des_defdoc1,chr(13),''),chr(10),'') as des_defdoc1
,replace(replace(t1.des_defdoc2,chr(13),''),chr(10),'') as des_defdoc2
,replace(replace(t1.des_defdoc3,chr(13),''),chr(10),'') as des_defdoc3
,replace(replace(t1.des_freedef1,chr(13),''),chr(10),'') as des_freedef1
,replace(replace(t1.des_freedef2,chr(13),''),chr(10),'') as des_freedef2
,replace(replace(t1.des_freedef3,chr(13),''),chr(10),'') as des_freedef3
,replace(replace(t1.des_freedef4,chr(13),''),chr(10),'') as des_freedef4
,replace(replace(t1.des_freedef5,chr(13),''),chr(10),'') as des_freedef5
,replace(replace(t1.des_group,chr(13),''),chr(10),'') as des_group
,replace(replace(t1.des_operator,chr(13),''),chr(10),'') as des_operator
,replace(replace(t1.des_org,chr(13),''),chr(10),'') as des_org
,replace(replace(t1.des_relationid,chr(13),''),chr(10),'') as des_relationid
,replace(replace(t1.des_system,chr(13),''),chr(10),'') as des_system
,dr
,replace(replace(t1.pk_relation,chr(13),''),chr(10),'') as pk_relation
,replace(replace(t1.saga_btxid,chr(13),''),chr(10),'') as saga_btxid
,saga_frozen
,replace(replace(t1.saga_gtxid,chr(13),''),chr(10),'') as saga_gtxid
,saga_status
,replace(replace(t1.src_billtype,chr(13),''),chr(10),'') as src_billtype
,replace(replace(t1.src_busidate,chr(13),''),chr(10),'') as src_busidate
,replace(replace(t1.src_defdoc1,chr(13),''),chr(10),'') as src_defdoc1
,replace(replace(t1.src_defdoc2,chr(13),''),chr(10),'') as src_defdoc2
,replace(replace(t1.src_defdoc3,chr(13),''),chr(10),'') as src_defdoc3
,replace(replace(t1.src_freedef1,chr(13),''),chr(10),'') as src_freedef1
,replace(replace(t1.src_freedef2,chr(13),''),chr(10),'') as src_freedef2
,replace(replace(t1.src_freedef3,chr(13),''),chr(10),'') as src_freedef3
,replace(replace(t1.src_freedef4,chr(13),''),chr(10),'') as src_freedef4
,replace(replace(t1.src_freedef5,chr(13),''),chr(10),'') as src_freedef5
,replace(replace(t1.src_group,chr(13),''),chr(10),'') as src_group
,replace(replace(t1.src_operator,chr(13),''),chr(10),'') as src_operator
,replace(replace(t1.src_org,chr(13),''),chr(10),'') as src_org
,replace(replace(t1.src_relationid,chr(13),''),chr(10),'') as src_relationid
,replace(replace(t1.src_system,chr(13),''),chr(10),'') as src_system
,replace(replace(t1.sumflag,chr(13),''),chr(10),'') as sumflag
,replace(replace(t1.ts,chr(13),''),chr(10),'') as ts
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.iers_fip_relation t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/iers_fip_relation.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
