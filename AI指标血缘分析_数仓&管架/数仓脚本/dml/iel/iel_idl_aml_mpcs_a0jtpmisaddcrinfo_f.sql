: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_mpcs_a0jtpmisaddcrinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a0jtpmisaddcrinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,mainseq
,transdt
,status
,trantype
,bank_self_num
,biz_type_code
,idtype_code
,idcode
,ctycode
,add_idcode
,person_name
,biz_tx_chnl_code
,txccy
,cr_amt
,acct_no
,remark
,refno
,code
,detail
,cr_amt_date
,cr_amt_year
,src
,des
,sendtime
,common_org_code
,msgno
,transmessage
,edit_reason_code
,edit_remark
,brcno
,tlrno
,srcseqno from idl.aml_mpcs_a0jtpmisaddcrinfo where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a0jtpmisaddcrinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes