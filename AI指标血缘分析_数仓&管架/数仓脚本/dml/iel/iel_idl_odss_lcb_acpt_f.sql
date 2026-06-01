: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_lcb_acpt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_lcb_acpt_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select LNCFNO
,ACPTCN
,ACPTNO
,CMSQNO
,PYERAC
,PYERNA
,ISSUDT
,ISSUSQ
,MATUDT
,BRCHNO
,CRCYCD
,ACPTAM
,FEESAM
,PYEEAC
,PYEENA
,PYEEBN
,COLLTG
,COLLAC
,COLLID
,CLOSDT
,CLOSSQ
,CLOSST
,DSCRTX
,ACPTST
,TERMCD
,RFTERM
,ACPTAC
,ACRYAC
,ACLFAC
,ACLFAM
,BLTYPE
,PYMCDT
,PYMCSQ
,PYMCTP from IDL.ODSS_LCB_ACPT where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_lcb_acpt_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes