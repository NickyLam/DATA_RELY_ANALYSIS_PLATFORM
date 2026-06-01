: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_mpcs_a0jtpmisqryfxsatqquota_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a0jtpmisqryfxsatqquota.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,mainseq
,transdt
,status
,trantype
,idtype_code
,idcode
,ctycode
,ann_lcyamt_usd
,ann_rem_lcyamt_usd
,cr_amt_usd_sumday
,cr_amt_usd_sumyear
,ann_fcyamt_usd
,ann_rem_fcyamt_usd
,zq_amt_usd_date
,zq_amt_usd_year
,custname
,custtype_code
,type_status
,pub_date
,end_date
,pub_reason
,pub_code
,pub_org
,sign_status
,is_check
,is_notice
,check_pub_date
,check_end_date
,check_pub_reason
,check_pub_code
,check_pub_branch
,magebrn
,oprtlr
,fronttrcd
,servicepath
,remark
,src
,des
,sendtime
,common_org_code
,msgno
,zyed_flag from idl.aml_mpcs_a0jtpmisqryfxsatqquota where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a0jtpmisqryfxsatqquota.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes