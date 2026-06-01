: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a68tfintranlist_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a68tfintranlist.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.mainseq,chr(13),''),chr(10),'') as mainseq
,replace(replace(t1.transdt,chr(13),''),chr(10),'') as transdt
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.businesstrace,chr(13),''),chr(10),'') as businesstrace
,replace(replace(t1.transamt,chr(13),''),chr(10),'') as transamt
,replace(replace(t1.pckno,chr(13),''),chr(10),'') as pckno
,replace(replace(t1.hosttrcd,chr(13),''),chr(10),'') as hosttrcd
,replace(replace(t1.fronttrcd,chr(13),''),chr(10),'') as fronttrcd
,replace(replace(t1.magebrn,chr(13),''),chr(10),'') as magebrn
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.hostdate,chr(13),''),chr(10),'') as hostdate
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.payacct,chr(13),''),chr(10),'') as payacct
,replace(replace(t1.payname,chr(13),''),chr(10),'') as payname
,replace(replace(t1.rcvacct,chr(13),''),chr(10),'') as rcvacct
,replace(replace(t1.rcvname,chr(13),''),chr(10),'') as rcvname
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.errcode,chr(13),''),chr(10),'') as errcode
,replace(replace(t1.errms,chr(13),''),chr(10),'') as errms
,replace(replace(t1.colsts,chr(13),''),chr(10),'') as colsts
,replace(replace(t1.abscde,chr(13),''),chr(10),'') as abscde
,replace(replace(t1.colldt,chr(13),''),chr(10),'') as colldt
,replace(replace(t1.upporderid,chr(13),''),chr(10),'') as upporderid
 from iol.mpcs_a68tfintranlist T1
where transdt='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a68tfintranlist.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes