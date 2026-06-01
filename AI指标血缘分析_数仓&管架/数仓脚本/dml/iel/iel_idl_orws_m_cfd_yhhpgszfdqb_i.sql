: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_m_cfd_yhhpgszfdqb_i
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_m_cfd_yhhpgszfdqb_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select * from dual where 1=0;" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/orws_m_cfd_yhhpgszfdqb_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes