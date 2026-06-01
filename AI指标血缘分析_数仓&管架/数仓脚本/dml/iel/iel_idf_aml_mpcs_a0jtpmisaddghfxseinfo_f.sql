: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_mpcs_a0jtpmisaddghfxseinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_mpcs_a0jtpmisaddghfxseinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,mainseq
,transdt
,businesstrace
,status
,trantype
,bank_self_num
,biz_type_code
,idtype_code
,idcode
,ctycode
,add_idcode
,person_name
,purfx_type_code
,txccy
,purfx_amt
,purfx_cash_amt
,fcy_remit_amt
,fcy_acct_amt
,tchk_amt
,purfx_acct_cny
,lcy_acct_no
,biz_tx_chnl_code
,agent_corp_code
,agent_corp_name
,indiv_org_code
,indiv_org_name
,pay_org_code
,capitalno
,biz_tx_time
,rein_reason_code
,rein_remark
,remark
,refno
,ret_bank_self_num
,purfx_amt_usd
,ann_rem_fcyamt_usd
,type_status
,pub_date
,end_date
,pub_reason
,pub_code
,code
,detail
,pckheadsrc
,pckheaddes
,pckheadsendtime
,pckheadcommon_org_code
,pckheadmsgno
,transmessage
,srcsysid
,srcseqno
,edit_reason_code
,edit_remark from idl.aml_mpcs_a0jtpmisaddghfxseinfo where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_mpcs_a0jtpmisaddghfxseinfo.f.${batch_date}.dat" \
        charset=utf8
        safe=yes