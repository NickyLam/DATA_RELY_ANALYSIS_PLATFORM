: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_yy_cbzjkb_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_yy_cbzjkb_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,brchno
,brchna
,nums
,usertp
,trantp
,cz_dt
,prcscd
,jyna
,cz_item
,cz_amntcd
,cz_acctno
,cz_acctna
,cz_tranam
,cz_transq
,cz_bz
,gyh
,gy_na
,sqgyh
,sqgy_na
,sttsdt
,st_amntcd
,st_acctno
,st_acctna
,st_tranam
,st_transq
,st_gyh
,st_gyna
,st_sqgyh
,st_sqgyna
,bz_tsdt
,bz_amntcd
,bz_acctno
,bz_acctna
,bz_tranam
,bz_transq
,bz_gyh
,bz_gyna
,bz_sqgyh
,bz_sqgyna
,bz_bz
,jy_qd
,gz_clqk
,bz
from ${idl_schema}.orws_m_yy_cbzjkb
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_yy_cbzjkb_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes