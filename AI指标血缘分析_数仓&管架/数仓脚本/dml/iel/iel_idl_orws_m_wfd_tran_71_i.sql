: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_wfd_tran_71_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_wfd_tran_71_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,brchno
,frozdt
,acctno
,acctna
,subsac
,refram
,cufram
,matudt
,frsptp
,userid
,sqgy_id
,exorgn
,idtftp_na
,idtfno
,exusna1
,exusna2
,exidtp
,exidno
,eidtp2
,eidno2
,frozsq
,status
,remktx
,jysj
,jyls
,jqrq
,jqsj
,jqls
,jqgy
,jqsqgy
from ${idl_schema}.orws_m_wfd_tran_71
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_wfd_tran_71_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes