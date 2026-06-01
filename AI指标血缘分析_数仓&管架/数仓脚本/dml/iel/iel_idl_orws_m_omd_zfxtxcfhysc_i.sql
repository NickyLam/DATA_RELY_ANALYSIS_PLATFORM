: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_omd_zfxtxcfhysc_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_omd_zfxtxcfhysc_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 date_id
,xh
,zfjyxh
,ywzl
,jyrq
,jysj
,jygy
,jygymc
,sqgy
,sqgymc
,jywd
,jywdmc
,jyls
,fkrzhmc
,fkrzh
,khwd
,khwdmc
,skrzhmc
,skrzh
,je
,jyzt
,zfxt
,ywlx
from ${idl_schema}.orws_m_omd_zfxtxcfhysc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_omd_zfxtxcfhysc_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes