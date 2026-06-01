: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_dszh_d_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_dszh_d_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,branch_code
,branch_name
,custno
,acctno
,acctna
,certtp
,certno
,tel
,opendate
,processor
,openti
,transq
,tran_user
,usernam
,branch_code_ex
from ${idl_schema}.orws_m_omd_dszh_d
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_dszh_d_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes