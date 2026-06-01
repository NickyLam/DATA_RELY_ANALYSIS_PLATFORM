: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_a49tefetsreg_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_a49tefetsreg_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
signdt
,signsq
,signtm
,cntrno
,txpycd
,txbrch
,origcd
,custtp
,acctno
,acctna
,openbr
,idtftp
,idtfno
,brchno
,userid
,ckbkus
,mainbr
,mainus
,clckus
,maindt
,maintm
,signst
,remark
,etsflg
,origna
from ${idl_schema}.odss_a49tefetsreg
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_a49tefetsreg_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes