: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_cbss_mds_serl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_cbss_mds_serl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.servtp,chr(13),''),chr(10),'') as servtp
,replace(replace(t1.trandt,chr(13),''),chr(10),'') as trandt
,replace(replace(t1.transq,chr(13),''),chr(10),'') as transq
,replace(replace(t1.otserv,chr(13),''),chr(10),'') as otserv
 from iol.cbss_mds_serl T1
where trandt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_cbss_mds_serl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes