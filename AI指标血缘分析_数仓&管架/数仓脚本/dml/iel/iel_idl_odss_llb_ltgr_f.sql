: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_llb_ltgr_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_llb_ltgr_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select LTGRCN
,CMSQNO
,ITEMCD
,LTGRTP
,LTGRBR
,PYERAC
,ISSUDT
,MATUDT
,CRCYCD
,LTGRAM
,BENEAC
,BENENA
,BENEBN
,OVDUIR
,FEESRT
,OPENDT
,OPENSQ
,LTGRAC
,CLOSDT
,CLOSSQ
,CLOSTG
,CMPSAM
,PYEEAC
,ADVATG
,LNCFNO
,LNCFAM
,REMARK
,LTGRST
,CNSTTP
,GRTEAM
,TERMCD
,LTGRNO from IDL.ODSS_LLB_LTGR where etl_dt=TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_llb_ltgr_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes