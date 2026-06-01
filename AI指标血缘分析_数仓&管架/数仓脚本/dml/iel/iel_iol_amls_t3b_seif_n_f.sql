: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t3b_seif_n_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t3b_seif_n.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.rpt_id,chr(13),''),chr(10),'') as rpt_id
    ,t.stat_dt as stat_dt
    ,t.seif_seq as seif_seq
    ,replace(replace(t.csnm,chr(13),''),chr(10),'') as csnm
    ,replace(replace(t.sevc,chr(13),''),chr(10),'') as sevc
    ,replace(replace(t.senm,chr(13),''),chr(10),'') as senm
    ,replace(replace(t.setp,chr(13),''),chr(10),'') as setp
    ,replace(replace(t.oitp,chr(13),''),chr(10),'') as oitp
    ,replace(replace(t.seid,chr(13),''),chr(10),'') as seid
    ,replace(replace(t.stnt,chr(13),''),chr(10),'') as stnt
    ,replace(replace(t.sctl1,chr(13),''),chr(10),'') as sctl1
    ,replace(replace(t.sctl2,chr(13),''),chr(10),'') as sctl2
    ,replace(replace(t.sear1,chr(13),''),chr(10),'') as sear1
    ,replace(replace(t.sear2,chr(13),''),chr(10),'') as sear2
    ,replace(replace(t.seei1,chr(13),''),chr(10),'') as seei1
    ,replace(replace(t.seei2,chr(13),''),chr(10),'') as seei2
    ,replace(replace(t.srnm,chr(13),''),chr(10),'') as srnm
    ,replace(replace(t.srit,chr(13),''),chr(10),'') as srit
    ,replace(replace(t.orit,chr(13),''),chr(10),'') as orit
    ,replace(replace(t.srid,chr(13),''),chr(10),'') as srid
    ,replace(replace(t.scnm,chr(13),''),chr(10),'') as scnm
    ,replace(replace(t.scit,chr(13),''),chr(10),'') as scit
    ,replace(replace(t.ocit,chr(13),''),chr(10),'') as ocit
    ,replace(replace(t.scid,chr(13),''),chr(10),'') as scid
    ,replace(replace(t.bs_valid,chr(13),''),chr(10),'') as bs_valid
    ,replace(replace(t.err_type,chr(13),''),chr(10),'') as err_type
    ,replace(replace(t.pbc_rcpt_tm,chr(13),''),chr(10),'') as pbc_rcpt_tm
    ,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
from iol.amls_t3b_seif_n t
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t3b_seif_n.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes