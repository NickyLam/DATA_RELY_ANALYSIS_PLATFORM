: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_kcl_ofbl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_kcl_ofbl_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select UQFILE
,FILENA
,RECDSQ
,FILEBR
,FILEDT
,TRANTP
,ACCTNO
,TRANAM
,CRCYCD
,TRANTM
,SYSTRN
,ACPTID
,SENDID
,MERCTP
,TERMID
,MERCID
,MERCAD
,MERCOR
,TRCERT
,CARDSQ
,TRTMRS
,TRRAND
,TRAPTC
,TRAPIP
,TRDATE
,TRCOUN
,TRRESP
,TRTYPE
,TRAUAM
,TRCRCY
,TROTAM
,TRISAP
,BTDATE
,BACHNO
,AGNTID
,BOOKST
,ERORTX
,BOOKBR
,CITYNO
,BOOKDT
,BOOKSQ
,TRANST from IDL.ODSS_KCL_OFBL where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_kcl_ofbl_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes