: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_gsdjb_d_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_gsdjb_d_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,indexno
,brchno
,rplssq
,rplsdt
,acctno
,acctna
,rplsfs
,dcmttp
,dcmtno
,rplstp
,idtftp
,idtfno
,agcuna
,agidtp
,agidno
,rplsus
,authus
,unlsus
,ckbkus
,unlsdt
,unchtg
,ugcuna
,ugidtp
,ugidno
,tranbr
,gstranti
,gsrplssq
,gsservtp
,jgtranti
,unlssq
,jgservtp
,transq
from ${idl_schema}.orws_m_omd_gsdjb_d
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_gsdjb_d_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes