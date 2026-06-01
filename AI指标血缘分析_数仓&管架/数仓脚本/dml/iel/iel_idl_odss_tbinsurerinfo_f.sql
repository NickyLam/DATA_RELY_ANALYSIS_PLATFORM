: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_tbinsurerinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_tbinsurerinfo_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
ta_code
,insure_bank_no
,ta_name
,ta_short_name
,ta_busin_name
,ta_type
,ta_limit_flag
,charge_flag
,begin_date
,end_date
,master_internal
,master_branch
,insurer_acc
,in_busin_no
,out_busin_no
,ip_address
,port
,wait_time
,file_ip
,file_port
,file_wait_time
,link_name
,link_tel
,signin_flag
,signin_date
,m_pkg_key
,m_pwd_key
,m_mac_key
,pkg_key
,pwd_key
,mac_key
,control_flag
,open_time
,close_time
,reserve1
,reserve2
from ${idl_schema}.odss_tbinsurerinfo
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_tbinsurerinfo_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes