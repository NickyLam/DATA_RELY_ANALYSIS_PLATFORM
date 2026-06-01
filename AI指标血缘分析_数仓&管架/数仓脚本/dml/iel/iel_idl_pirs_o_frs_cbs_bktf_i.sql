: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_frs_cbs_bktf_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_frs_cbs_bktf_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select TRANDT
,TRANSQ
,TRANTM
,TRANNO
,TRANST
,MDTRDT
,MDTRSQ
,CHANNL
,TYPFLG
,PYACCT
,PYACNA
,PYACBR
,SENDBK
,CRCYCD
,TRANAM
,CURREN
,FEEAMT
,CSEXTG
,RVACCT
,RVACNA
,RVBANK
,RVBKNA
,REMARK
,LEVELS
,COREDT
,CORESQ
,COLLDT
,COLLSQ
,BRCHNO
,USERID
,RSPSCD
,MSGTXT
,REFENO
,PRTCNT
,DOWNFG from idl.pirs_o_frs_cbs_bktf where trandt='${batch_date}';" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_frs_cbs_bktf_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes