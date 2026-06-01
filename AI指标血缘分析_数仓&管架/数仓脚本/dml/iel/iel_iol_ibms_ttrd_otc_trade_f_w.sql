: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_otc_trade_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_otc_trade_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
sysordid
,orddate
,ordtime
,condate
,contime
,insid
,intordid
,extordid
,custordid
,extbizid
,operator
,trdtype
,cash_ext_accid
,cash_accid
,secu_ext_accid
,secu_accid
,partyid
,cp_cash_accid
,cp_secu_accid
,i_code
,a_type
,m_type
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,ordcount
,ordprice
,ordamount
,trdfee
,setfee
,setdays
,setdate
,thenmktprice
,thenmktprice_u
,ordstatus
,errcode
,replace(replace(errinfo,chr(10),''),chr(13),'') as errinfo
,bnd_settype
,bnd_netprice
,bnd_aiamount
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,reservetype
,cp_reservetype
,reservechg
,cp_reservechg
,reservevalue
,cp_reservevalue
,replace(replace(resolve,chr(10),''),chr(13),'') as resolve
,trade_grp_id
,ref_orddate
,ref_sysordid
,ignore_flag
,exe_market
,replace(replace(trader,chr(10),''),chr(13),'') as trader
,replace(replace(trader_cp,chr(10),''),chr(13),'') as trader_cp
,dealtype
,agreenumber
,eval_netprice
,ordsource
,deal_count
,deal_avg_netprice
,deal_netamount
,deal_aiamount
,deal_amount
,bidaskid
,relatedparty
,terminate_amount
,setdate_terminate
,agreementtype
,replace(replace(partynametempority,chr(10),''),chr(13),'') as partynametempority
,replace(replace(party_zzdaccname,chr(10),''),chr(13),'') as party_zzdaccname
,seatno_cp
,replace(replace(executor,chr(10),''),chr(13),'') as executor
,union_sysordid
,replace(replace(party_zzdacccode,chr(10),''),chr(13),'') as party_zzdacccode
,replace(replace(party_bank_code,chr(10),''),chr(13),'') as party_bank_code
,replace(replace(party_acct_code,chr(10),''),chr(13),'') as party_acct_code
,replace(replace(party_bank_name,chr(10),''),chr(13),'') as party_bank_name
,replace(replace(party_acct_name,chr(10),''),chr(13),'') as party_acct_name
,dis_fee_kind_follow
,dis_fee_kind
,grpid_sub
,imp_time
,eval_ytm
,bnd_ytm
,update_time
,due_ai
,operator_id
,executor_id
,due_cp
,real_ai
,real_cp
,real_fee
,due_fee
,ref_type
,is_remain
,trader_id
,trademodel
,settlemodel
,ord_id
,insstatus
,entrust_ref_id
,close_trade_id
,ftprate
,conn_ordid
,replace(replace(two_effective_contract,chr(10),''),chr(13),'') as two_effective_contract
,source_type
,settlestate
,navdate
,qcurr_cash_ext_accid
,replace(replace(qcurr_party_bank_code,chr(10),''),chr(13),'') as qcurr_party_bank_code
,replace(replace(qcurr_party_bank_name,chr(10),''),chr(13),'') as qcurr_party_bank_name
,replace(replace(qcurr_party_acct_code,chr(10),''),chr(13),'') as qcurr_party_acct_code
,replace(replace(qcurr_party_acct_name,chr(10),''),chr(13),'') as qcurr_party_acct_name
,party_mid_bank_acct_code
,party_mid_bank_name
,party_mid_swift_code
,qcurr_party_mid_bank_acct_code
,qcurr_party_mid_bank_name
,qcurr_party_mid_swift_code
,party_swift_code
,qcurr_party_swift_code
,spv_id
,his_tradeflag
,his_ref_tradeid
,his_trade_setdate
,party_pset
,party_pset_country
,party_agent_code_type
,replace(replace(party_agent_code_dss,chr(10),''),chr(13),'') as party_agent_code_dss
,replace(replace(party_agent_code,chr(10),''),chr(13),'') as party_agent_code
,replace(replace(party_agent_account,chr(10),''),chr(13),'') as party_agent_account
,replace(replace(party_code_type,chr(10),''),chr(13),'') as party_code_type
,replace(replace(party_code_dss,chr(10),''),chr(13),'') as party_code_dss
,replace(replace(party_code,chr(10),''),chr(13),'') as party_code
,replace(replace(party_account,chr(10),''),chr(13),'') as party_account
,si_id
,party_i_bank_code
,party_i_swift_code
,split_inst_type
,cm_attr_parent
,cm_attr_master
,cm_attr_merge
,cm_attr_mirror
,cm_attr_relation
,cal_start_date
,cal_end_date
,strike_ytm
,replace(replace(settlement_type,chr(10),''),chr(13),'') as settlement_type
,replace(replace(aio_acct_no,chr(10),''),chr(13),'') as aio_acct_no
,replace(replace(acct_type,chr(10),''),chr(13),'') as acct_type
,replace(replace(user_name,chr(10),''),chr(13),'') as user_name
,replace(replace(contractparty,chr(10),''),chr(13),'') as contractparty
,marketing_manager_id
,marketing_org_id
,com_date
,party_branch
,max_val
,min_val
,collection_fst_fee
,transfer_type
,secu_setdate
,csdc_netprice
,ccdc_netprice
,shch_netprice
,se_netprice
,ctrct_id
,platform
,replace(replace(invest_direction,chr(10),''),chr(13),'') as invest_direction
,contractversion
,final_invest
,replace(replace(associatednumber,chr(10),''),chr(13),'') as associatednumber
,fiveclass
,prod_nature
,trd_acc_code
,store_code
,quote_type
,unit_id
,curcount
,can_div_amount
,is_remain_due_ai
,is_impair
,option_group
,entry_date
,party_pset_name
,relate_invest
,settlement_place
,trdfee_notset
,daycounter
,remain_due_cp
,include_inte
,exh_extordid
,exrcise_state
,sppiresult
,sppiclass
,mergeno
,resource_id
,replace(replace(party_relevance_info,chr(10),''),chr(13),'') as party_relevance_info
,full_flag
,brokerage_id
,replace(replace(brokerage_fee_info,chr(10),''),chr(13),'') as brokerage_fee_info
,released_credit_line
,out_range
,interest_out
,book
,xcc_trade_grp_id
,xcc_pre_sysordid
,etl_dt
,etl_timestamp
from iol.ibms_ttrd_otc_trade where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_otc_trade_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes