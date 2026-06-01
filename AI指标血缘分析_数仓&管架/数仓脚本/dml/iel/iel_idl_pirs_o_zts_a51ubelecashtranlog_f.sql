: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_zts_a51ubelecashtranlog_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_zts_a51ubelecashtranlog_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select filedate
,gatetype
,fwdinstid
,systrace
,acqinstid
,transtime
,settlmtdate
,trandate
,priacct
,cardsq
,trantp
,crcycd
,tranam
,provstatus
,merctp
,termid
,mercid
,mercad
,trcert
,trauam
,trotam
,trcoun
,trcrcy
,trdate
,trtype
,trrand
,trapip
,traptc
,trresp
,idprest
,isdata
,oldtrantp
,oldsystrace
,oldsettlmtdate
,oldtranstime
,feeamt
,cardholdrate
,cardholdamt
,cardholdcy
,settlmtamt
,settlmtcy
,ratefeeamt
,openbrn
,hostdate
,hostnbr
,dataid
,errcode
,errmsg
,qsstatus
,opstatus
,retrflg
,magacct
 from idl.pirs_o_zts_a51ubelecashtranlog where 1=1;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_zts_a51ubelecashtranlog_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes