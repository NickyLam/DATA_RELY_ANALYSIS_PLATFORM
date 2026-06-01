: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_dxezfxtwfh_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_dxezfxtwfh_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,jbwd
,lrrqjsj
,jbgy
,sqgy
,zfjyxh
,jyls
,ywzt
,sjfkrzh
,sjfkrmc
,jyje
,jbwdmc
,zfxt
from ${idl_schema}.orws_m_omd_dxezfxtwfh
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_dxezfxtwfh_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes