: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_mpcs_a0jtpmisaddtqinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a0jtpmisaddtqinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,mainseq
,transdt
,trantype
,biz_type_code
,bank_self_num
,idtype_code
,idcode
,person_name
,ctycode
,add_idcode
,biz_tx_chnl_code
,txccy
,zq_amt
,acct_no
,biz_tx_time
,remark
,rein_reason_code
,rein_remark
,status
,refno
,code
,detail
,tq_amt_date
,tq_amt_year
,src
,des
,sendtime
,common_org_code
,msgno
,brcno
,tlrno
,srcsysid
,srcseqno
,uptm
,upbrcno
,uptlrno
,uptype
,upreason_code
,upremark
,uprefno
,upbank_self_num from idl.aml_mpcs_a0jtpmisaddtqinfo where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a0jtpmisaddtqinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes