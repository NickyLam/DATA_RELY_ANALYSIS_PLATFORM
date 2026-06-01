: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_md_transq_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_md_transq_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select MDPROD
,MDTSDT
,MDTSRF
,COLLDT
,PRCSCD
,CSBXNO
,BRCHNO
,CITYNO
,USERID
,ACCTNO
,CARDNO
,DCMTTP
,DCMTNO
,DRCTNO
,DRBRNO
,DRACNO
,DRCDNO
,DRNAME
,CRCTNO
,CRBRNO
,CRACNO
,CRCDNO
,CRNAME
,TRANTP
,DRAMCD
,CRCYCD
,TOTLAM
,TRANAM
,FEEAMT
,TRANAM1
,TRANAM2
,ONLNBL
,DRAWFS
,TRANPW
,TRANPW1
,CUNCOD
,MDOLTF
,MDOLDT
,SYSTDT
,TRANSQ
,OLDTSQ
,OLDSDT
,CHEKCD
,CHEKST
,CHEKUS
,CHEKNO1
,CHEKNO2
,CHEKAM1
,CHEKAM2
,CHEKPW
,MDTERM
,MNOTE1
,MNOTE2
,MNOTE3
,MNOTE4
,RETNCD
,TRANST from IDL.ODSS_MD_TRANSQ where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_md_transq_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes