: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_admin_pfb_froz_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_admin_pfb_froz_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select frozdt
,frozsq
,sortno
,transq
,frsptp
,susbtp
,status
,acctno
,subsac
,acctna
,refram
,cufram
,matudt
,idtftp
,idtfno
,remktx
,exorgn
,exidtp
,exidno
,eidtp2
,eidno2
,exusna
,exuna2
,userid
,brchno
,servtp from idl.pirs_f_evt_admin_pfb_froz where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_admin_pfb_froz_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes