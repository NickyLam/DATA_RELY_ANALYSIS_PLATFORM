: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a60tchkbatdetail_a
CreateDate: 20240812
FileName:   ${iel_data_path}/mpcs_a60tchkbatdetail.i.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.trannbr,chr(13),''),chr(10),'') as trannbr
,replace(replace(t1.trandate,chr(13),''),chr(10),'') as trandate
,replace(replace(t1.trantime,chr(13),''),chr(10),'') as trantime
,replace(replace(t1.batdt,chr(13),''),chr(10),'') as batdt
,replace(replace(t1.batno,chr(13),''),chr(10),'') as batno
,replace(replace(t1.batseqno,chr(13),''),chr(10),'') as batseqno
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
,replace(replace(t1.checkchnl,chr(13),''),chr(10),'') as checkchnl
,replace(replace(t1.recordstat,chr(13),''),chr(10),'') as recordstat
,replace(replace(t1.checkdept,chr(13),''),chr(10),'') as checkdept
,replace(replace(t1.checktype,chr(13),''),chr(10),'') as checktype
,replace(replace(t1.photo,chr(13),''),chr(10),'') as photo
,replace(replace(t1.businesstype,chr(13),''),chr(10),'') as businesstype
,replace(replace(t1.trantype,chr(13),''),chr(10),'') as trantype
,replace(replace(t1.chkrspmsg,chr(13),''),chr(10),'') as chkrspmsg
,replace(replace(t1.transeqno,chr(13),''),chr(10),'') as transeqno
,replace(replace(t1.loadflg,chr(13),''),chr(10),'') as loadflg
,replace(replace(t1.dealflg,chr(13),''),chr(10),'') as dealflg
,replace(replace(t1.feecntflg,chr(13),''),chr(10),'') as feecntflg

from ${iol_schema}.mpcs_a60tchkbatdetail t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a60tchkbatdetail.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
