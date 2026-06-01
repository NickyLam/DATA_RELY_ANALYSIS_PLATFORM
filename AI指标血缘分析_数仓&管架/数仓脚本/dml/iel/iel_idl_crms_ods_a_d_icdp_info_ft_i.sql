: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ods_a_d_icdp_info_ft_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ods_a_d_icdp_info_ft_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,cust_no
,cust_na
,acct_no
,acct_st
,open_br
,open_sq
,clos_dt
,clos_sq
,idtf_tp
,std_idtftp
,idtf_no
,efct_dt
,inef_dt
,mx_blam
,mx_limt
,attr_pt
,attr_am
,save_am
,draw_am
,lst_off
,ls_trdt
,ls_trsq
,of_line
,icdp_bal
,icdp_mon_cml
,icdp_mon_avl
,icdp_qtr_cml
,icdp_qtr_avl
,icdp_year_cml
,icdp_year_avl
from ${idl_schema}.crms_ods_a_d_icdp_info_ft
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ods_a_d_icdp_info_ft_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes