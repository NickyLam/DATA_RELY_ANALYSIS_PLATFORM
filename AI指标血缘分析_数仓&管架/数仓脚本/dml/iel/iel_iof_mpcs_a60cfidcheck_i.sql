: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_mpcs_a60cfidcheck_i
CreateDate: 20250910
FileName:   ${iel_data_path}/mpcs_a60cfidcheck.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.trannbr,chr(13),''),chr(10),'') as trannbr
,trandate
,trantime
,replace(replace(t1.trancode,chr(13),''),chr(10),'') as trancode
,linkid
,replace(replace(t1.bnakcode,chr(13),''),chr(10),'') as bnakcode
,replace(replace(t1.identype,chr(13),''),chr(10),'') as identype
,replace(replace(t1.idennbr,chr(13),''),chr(10),'') as idennbr
,replace(replace(t1.nationality,chr(13),''),chr(10),'') as nationality
,replace(replace(t1.cltname,chr(13),''),chr(10),'') as cltname
,replace(replace(t1.issueoffice,chr(13),''),chr(10),'') as issueoffice
,replace(replace(t1.photoname,chr(13),''),chr(10),'') as photoname
,replace(replace(t1.chkresult,chr(13),''),chr(10),'') as chkresult
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.srcseqno,chr(13),''),chr(10),'') as srcseqno
,replace(replace(t1.srcsysid,chr(13),''),chr(10),'') as srcsysid
,replace(replace(t1.tlrno,chr(13),''),chr(10),'') as tlrno
,replace(replace(t1.brcno,chr(13),''),chr(10),'') as brcno
,replace(replace(t1.trndt,chr(13),''),chr(10),'') as trndt
,replace(replace(t1.chkrtp,chr(13),''),chr(10),'') as chkrtp
,replace(replace(t1.hostnbr,chr(13),''),chr(10),'') as hostnbr
,replace(replace(t1.hostdt,chr(13),''),chr(10),'') as hostdt
,replace(replace(t1.mutrcd,chr(13),''),chr(10),'') as mutrcd
,replace(replace(t1.trnname,chr(13),''),chr(10),'') as trnname
,replace(replace(t1.tmip,chr(13),''),chr(10),'') as tmip
,replace(replace(t1.tmmac,chr(13),''),chr(10),'') as tmmac
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.tmtype,chr(13),''),chr(10),'') as tmtype
,replace(replace(t1.formername,chr(13),''),chr(10),'') as formername
,replace(replace(t1.gender,chr(13),''),chr(10),'') as gender
,replace(replace(t1.birthday,chr(13),''),chr(10),'') as birthday
,replace(replace(t1.birthplace,chr(13),''),chr(10),'') as birthplace
,replace(replace(t1.nativeplace,chr(13),''),chr(10),'') as nativeplace
,replace(replace(t1.edulevel,chr(13),''),chr(10),'') as edulevel
,replace(replace(t1.marriage,chr(13),''),chr(10),'') as marriage
,replace(replace(t1.job,chr(13),''),chr(10),'') as job
,replace(replace(t1.engageaddr,chr(13),''),chr(10),'') as engageaddr
,replace(replace(t1.address,chr(13),''),chr(10),'') as address
,replace(replace(t1.checkchnl,chr(13),''),chr(10),'') as checkchnl
,replace(replace(t1.recordstat,chr(13),''),chr(10),'') as recordstat
,replace(replace(t1.checkdept,chr(13),''),chr(10),'') as checkdept
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.chkrspmsg,chr(13),''),chr(10),'') as chkrspmsg

from ${iol_schema}.mpcs_a60cfidcheck t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60cfidcheck.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
