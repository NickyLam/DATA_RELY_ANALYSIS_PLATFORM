: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a35tfintranslist_i
CreateDate: 20240311
FileName:   ${iel_data_path}/mpcs_a35tfintranslist.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.seqno,chr(13),''),chr(10),'') as seqno
,replace(replace(t1.trntm,chr(13),''),chr(10),'') as trntm
,replace(replace(t1.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t1.chnlseqno,chr(13),''),chr(10),'') as chnlseqno
,replace(replace(t1.chnltime,chr(13),''),chr(10),'') as chnltime
,replace(replace(t1.cobank,chr(13),''),chr(10),'') as cobank
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.seccd,chr(13),''),chr(10),'') as seccd
,replace(replace(t1.secname,chr(13),''),chr(10),'') as secname
,replace(replace(t1.capitalacctno,chr(13),''),chr(10),'') as capitalacctno
,replace(replace(t1.trntype,chr(13),''),chr(10),'') as trntype
,replace(replace(t1.trnamt,chr(13),''),chr(10),'') as trnamt
,replace(replace(t1.ccy,chr(13),''),chr(10),'') as ccy
,replace(replace(t1.acctbal,chr(13),''),chr(10),'') as acctbal
,replace(replace(t1.capitalacctbal,chr(13),''),chr(10),'') as capitalacctbal
,replace(replace(t1.hostseqno,chr(13),''),chr(10),'') as hostseqno
,replace(replace(t1.hostdt,chr(13),''),chr(10),'') as hostdt
,replace(replace(t1.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t1.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t1.dataid,chr(13),''),chr(10),'') as dataid
,replace(replace(t1.paechkflag,chr(13),''),chr(10),'') as paechkflag
,replace(replace(t1.paechkremark,chr(13),''),chr(10),'') as paechkremark
,replace(replace(t1.paechktime,chr(13),''),chr(10),'') as paechktime
,replace(replace(t1.jtechkflag,chr(13),''),chr(10),'') as jtechkflag
,replace(replace(t1.jtechkremark,chr(13),''),chr(10),'') as jtechkremark
,replace(replace(t1.jtechktime,chr(13),''),chr(10),'') as jtechktime
,replace(replace(t1.turnflag,chr(13),''),chr(10),'') as turnflag
,replace(replace(t1.hangflag,chr(13),''),chr(10),'') as hangflag
,replace(replace(t1.addflag,chr(13),''),chr(10),'') as addflag
,replace(replace(t1.glob_seq_num,chr(13),''),chr(10),'') as glob_seq_num
,replace(replace(t1.trnchnl,chr(13),''),chr(10),'') as trnchnl

from ${iol_schema}.mpcs_a35tfintranslist t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a35tfintranslist.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
