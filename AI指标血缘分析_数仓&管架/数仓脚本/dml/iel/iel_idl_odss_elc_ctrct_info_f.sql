: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_elc_ctrct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_elc_ctrct_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,off_type
,bank_ctrct_nb
,ctrct_nb
,customer_id
,ctrct_dt
,ctrct_rscin_dt
,ctrct_tp
,ctrct_comtmt_ddln
,ctrct_cxlmrkr
,ctrct_rscisntp
,ctrct_xtnsn
,ctrct_cnts_file
,ctrct_rtntnprd
,offerr_role
,offerr_nm
,offerr_cmonid
,offerr_acctid
,offerr_acctsvcr
,offeree_role
,offeree_nm
,offeree_cmonid
,offeree_acctid
,offeree_acctsvcr
,rscisn_role
,rscisn_rsn_cd
,rscisn_rsn_rmrk
,ctrct_rscisntp_type
,status
,tmp_status
,misc
,last_upd_oper_id
,last_upd_time
from ${idl_schema}.odss_elc_ctrct_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_elc_ctrct_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes