: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_pam_m_acctno_rela_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_pam_m_acctno_rela_info_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,acct_no
,pamac_no
from ${idl_schema}.crms_pam_m_acctno_rela_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_pam_m_acctno_rela_info_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes