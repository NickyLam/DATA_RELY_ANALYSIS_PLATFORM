: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ods_a_d_card_info_ft_i
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ods_a_d_card_info_ft_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
date_id
,agreement_id
,cardno
,accstp
,acctna
,brchno
,custno
,custna
,custtp
,mangno
,mangna
,maxsac
,subsnm
,opendt
,closdt
,lsacdt
,lstsdt
,acctst
,dcmtno
,un_acctno
,un_dcmtno
,cardpd
,cardbn
,substp
,cardna
,cardcd
,cardlv
,unit_crd_flg
,staff_crd_flg
,credit_card_flg
,sfdfgzk
,sfjrick
,sflmk
,dp_bal
,dp_mon_cml
,dp_quar_cml
,dp_year_cml
,dp_mon_avl
,dp_quar_avl
,dp_year_avl
,dplc_bal
,dplc_mon_cml
,dplc_quar_cml
,dplc_year_cml
,dplc_mon_avl
,dplc_quar_avl
,dplc_year_avl
,bblc_bal
,bblc_mon_cml
,bblc_quar_cml
,bblc_year_cml
,bblc_mon_avl
,bblc_quar_avl
,bblc_year_avl
,fbblc_bal
,fbblc_mon_cml
,fbblc_quar_cml
,fbblc_year_cml
,fbblc_mon_avl
,fbblc_quar_avl
,fbblc_year_avl
,coopcn
,coopcd
from ${idl_schema}.crms_ods_a_d_card_info_ft
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ods_a_d_card_info_ft_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes