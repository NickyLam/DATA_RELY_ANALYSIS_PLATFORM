/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_evt_bigamt_tran_evt
CreateDate: 20230118
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_evt_bigamt_tran_evt purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_evt_bigamt_tran_evt(
etl_dt date --数据日期
,evt_id varchar2(60) --事件编号
,lp_id varchar2(60) --法人编号
,pay_decl_form_id varchar2(60) --支付报单编号
,tran_dt date --交易日期
,curr_cd varchar2(10) --币种代码
,tran_amt number(30,2) --交易金额
,out_line_pay_tran_seq_num varchar2(60) --行外支付交易序号
,bank_int_bus_seq_num varchar2(60) --行内业务序号
,msg_type_id varchar2(60) --报文类型编号
,host_tran_code varchar2(30) --主机交易码
,midgrod_tran_code varchar2(30) --中台交易码
,entr_dt date --委托日期
,host_dt date --主机日期
,host_flow_num varchar2(60) --主机流水号
,spec_prmssn_prtcptr_id varchar2(60) --特许参与者编号
,send_msg_center_cd varchar2(10) --发报中心代码
,init_clear_bk_no varchar2(60) --发起清算行行号
,origi_bank_no varchar2(60) --发起行行号
,payer_open_bank_dept_id varchar2(60) --付款人开户行部门编号
,payer_open_bank_no varchar2(60) --付款人开户行行号
,payer_open_bank_name varchar2(250) --付款人开户行名称
,payer_acct_num varchar2(60) --付款人账号
,payer_name varchar2(250) --付款人名称
,payer_addr varchar2(250) --付款人地址
,recv_msg_center_cd varchar2(10) --收报中心代码
,recv_clear_bk_no varchar2(60) --接收清算行行号
,recv_bank_bank_no varchar2(60) --接收行行号
,recver_open_bank_no varchar2(60) --收款人开户行行号
,recver_open_bank_name varchar2(250) --收款人开户行名称
,recver_acct_num varchar2(60) --收款人账号
,recver_name varchar2(250) --收款人名称
,recver_addr varchar2(250) --收款人地址
,bus_kind_cd varchar2(20) --业务种类代码
,bus_type_cd varchar2(10) --业务类型代码
,init_entr_dt date --原委托日期
,init_pay_tran_seq_num varchar2(60) --原支付交易序号
,init_prtcpt_org_id varchar2(60) --原发起参与机构编号
,init_msg_type_id varchar2(60) --原报文类型编号
,proc_status_cd varchar2(10) --处理状态代码
,pbc_bus_status_cd varchar2(10) --人行业务状态代码
,npc_proc_cd varchar2(60) --npc处理代码
,sys_type_cd varchar2(10) --系统类型代码
,node_type_cd varchar2(10) --节点类型代码
,npc_rest_cd varchar2(10) --npc处理结果代码
,check_revs_flow_num varchar2(60) --复核冲正流水号
,send_revs_flow_num varchar2(60) --发送冲正流水号
,clear_dt date --清算日期
,err_return_code varchar2(30) --错误返回编码
,err_info varchar2(500) --错误信息
,prior_level varchar2(20) --优先级别
,input_teller_id varchar2(60) --录入柜员编号
,check_teller_id varchar2(60) --复核柜员编号
,auth_teller_id varchar2(60) --授权柜员编号
,input_check_teller_dept_id varchar2(60) --录入复核柜员部门编号
,auth_teller_dept_id varchar2(60) --授权柜员部门编号
,check_entry_status_cd varchar2(10) --对账状态代码
,print_cnt number(10,0) --打印次数
,revid_tm timestamp(6) --收到时间
,send_tm timestamp(6) --发送时间
,sugst_pay_dt date --提示付款日期
,nostro_flg varchar2(10) --往来账标志
,charge_flg varchar2(10) --收费标志
,debit_crdt_cd varchar2(10) --借贷代码
,reg_main_acct_num varchar2(60) --挂账或维护入账账号
,reg_main_name varchar2(250) --挂账或维护入账姓名
,matn_enter_acct_dt date --维护入账日期
,matn_enter_acct_teller_id varchar2(60) --维护入账柜员编号
,matn_enter_acct_dept_id varchar2(60) --维护入账部门编号
,clarify_enter_acct_num varchar2(60) --清分入账账号
,clarify_flow_num varchar2(60) --清分流水号
,agent_flg varchar2(10) --代理标志
,jnl_flow_num varchar2(60) --日志流水号
,send_jnl_flow_num varchar2(60) --发送日志流水号
,vouch_type_cd varchar2(10) --凭证类型代码
,vouch_dt date --凭证日期
,vouch_no varchar2(60) --凭证号码
,cert_kind_cd varchar2(10) --证件种类代码
,cert_no varchar2(60) --证件号码
,tran_lmt number(30,2) --转账限额
,tran_flow_num varchar2(60) --交易流水号
,send_tran_flow_num varchar2(30) --发送交易流水号
,modif_tm timestamp(6) --修改时间
,cc_bank_draft_id varchar2(60) --城商行汇票编号
,rec_update_edit_num varchar2(60) --记录更新版本号
,rec_status_cd varchar2(10) --记录状态代码
,mode_pay_cd varchar2(10) --支付方式代码
,exch_bus_tran_chn_cd varchar2(10) --汇兑业务交易渠道代码
,modif_dt date --修改日期
,bus_flow_num varchar2(60) --业务流水号
,mgmt_org_id varchar2(60) --管理机构编号
,comm_fee_amt number(30,8) --手续费用金额
,remit_tran_fee_amt number(30,8) --汇划费用金额
,todos number(30,8) --工本费
,mpr_teller_id varchar2(60) --维护入账冲账柜员编号
,revs_tran_flow_num varchar2(30) --冲正交易流水号
,revs_tran_dt date --冲正交易日期
,prod_cd varchar2(10) --产品代码
,intnal_acct_flg varchar2(10) --内部账标志
,actl_deduct_acct_num varchar2(60) --实际扣账账号
,actl_deduct_acct_name varchar2(100) --实际扣账户名称
,bank_int_sys_edit_num varchar2(60) --行内系统版本号
,cntpty_sys_edit_num varchar2(60) --对手系统版本号
,ground_proc_status_cd varchar2(10) --落地处理状态代码
,verify_proc_status_cd varchar2(10) --查证处理状态代码
,rgst_addit_data_name varchar2(100) --登记附加数据表名称
,on_acct_rs_cd varchar2(10) --挂账原因代码
,scd_gener_msg_type_id varchar2(60) --二代报文类型编号
,scd_gener_bus_type_cd varchar2(10) --二代业务类型代码
,scd_gener_bus_kind_cd varchar2(20) --二代业务种类代码
,charge_way_cd varchar2(10) --收费方式代码
,e_acct_cd varchar2(10) --电子账户代码
,chn_flow_num varchar2(60) --渠道流水号
,next_day_tran_flg varchar2(10) --次日转账标志
,auto_refund_flg varchar2(10) --自动退汇标志
,auto_refund_cnt number(10,0) --自动退汇次数
,vtual_acct_bind_acct varchar2(60) --虚户绑定账户
,vtual_acct_bind_acct_name varchar2(250) --虚户绑定账户名称
,acct_type_cd varchar2(20) --账户类型代码
,vtual_open_acct_org_id varchar2(60) --虚户绑定账户开户机构编号
,acct_gen_cd varchar2(20) --账户大类型代码
,lmt_order_no varchar2(60) --限额订单号
,ova_flow_num varchar2(60) --全局流水号
,esb_intfc_return_code varchar2(30) --esb接口返回码
,esb_intfc_return_info varchar2(2000) --esb接口返回信息
,esb_intfc_tran_flow_num varchar2(60) --esb接口交易流水号
,send_pbc_tm timestamp(6) --发送人行时间
,src_table_name varchar2(100) --源表名称

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_evt_bigamt_tran_evt to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_evt_bigamt_tran_evt is '大额交易事件';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.evt_id is '事件编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.lp_id is '法人编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.pay_decl_form_id is '支付报单编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.tran_dt is '交易日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.curr_cd is '币种代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.tran_amt is '交易金额';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.out_line_pay_tran_seq_num is '行外支付交易序号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.bank_int_bus_seq_num is '行内业务序号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.msg_type_id is '报文类型编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.host_tran_code is '主机交易码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.midgrod_tran_code is '中台交易码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.entr_dt is '委托日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.host_dt is '主机日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.host_flow_num is '主机流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.spec_prmssn_prtcptr_id is '特许参与者编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_msg_center_cd is '发报中心代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.init_clear_bk_no is '发起清算行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.origi_bank_no is '发起行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_open_bank_dept_id is '付款人开户行部门编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_open_bank_no is '付款人开户行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_open_bank_name is '付款人开户行名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_acct_num is '付款人账号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_name is '付款人名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.payer_addr is '付款人地址';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recv_msg_center_cd is '收报中心代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recv_clear_bk_no is '接收清算行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recv_bank_bank_no is '接收行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recver_open_bank_no is '收款人开户行行号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recver_open_bank_name is '收款人开户行名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recver_acct_num is '收款人账号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recver_name is '收款人名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.recver_addr is '收款人地址';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.bus_kind_cd is '业务种类代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.bus_type_cd is '业务类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.init_entr_dt is '原委托日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.init_pay_tran_seq_num is '原支付交易序号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.init_prtcpt_org_id is '原发起参与机构编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.init_msg_type_id is '原报文类型编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.proc_status_cd is '处理状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.pbc_bus_status_cd is '人行业务状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.npc_proc_cd is 'npc处理代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.sys_type_cd is '系统类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.node_type_cd is '节点类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.npc_rest_cd is 'npc处理结果代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.check_revs_flow_num is '复核冲正流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_revs_flow_num is '发送冲正流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.clear_dt is '清算日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.err_return_code is '错误返回编码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.err_info is '错误信息';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.prior_level is '优先级别';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.input_teller_id is '录入柜员编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.check_teller_id is '复核柜员编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.auth_teller_id is '授权柜员编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.input_check_teller_dept_id is '录入复核柜员部门编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.auth_teller_dept_id is '授权柜员部门编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.check_entry_status_cd is '对账状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.print_cnt is '打印次数';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.revid_tm is '收到时间';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_tm is '发送时间';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.sugst_pay_dt is '提示付款日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.nostro_flg is '往来账标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.charge_flg is '收费标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.debit_crdt_cd is '借贷代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.reg_main_acct_num is '挂账或维护入账账号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.reg_main_name is '挂账或维护入账姓名';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.matn_enter_acct_dt is '维护入账日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.matn_enter_acct_teller_id is '维护入账柜员编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.matn_enter_acct_dept_id is '维护入账部门编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.clarify_enter_acct_num is '清分入账账号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.clarify_flow_num is '清分流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.agent_flg is '代理标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.jnl_flow_num is '日志流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_jnl_flow_num is '发送日志流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vouch_type_cd is '凭证类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vouch_dt is '凭证日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vouch_no is '凭证号码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.cert_kind_cd is '证件种类代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.cert_no is '证件号码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.tran_lmt is '转账限额';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_tran_flow_num is '发送交易流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.modif_tm is '修改时间';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.cc_bank_draft_id is '城商行汇票编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.rec_update_edit_num is '记录更新版本号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.rec_status_cd is '记录状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.mode_pay_cd is '支付方式代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.exch_bus_tran_chn_cd is '汇兑业务交易渠道代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.modif_dt is '修改日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.mgmt_org_id is '管理机构编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.comm_fee_amt is '手续费用金额';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.remit_tran_fee_amt is '汇划费用金额';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.todos is '工本费';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.mpr_teller_id is '维护入账冲账柜员编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.revs_tran_flow_num is '冲正交易流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.revs_tran_dt is '冲正交易日期';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.prod_cd is '产品代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.intnal_acct_flg is '内部账标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.actl_deduct_acct_num is '实际扣账账号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.actl_deduct_acct_name is '实际扣账户名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.bank_int_sys_edit_num is '行内系统版本号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.cntpty_sys_edit_num is '对手系统版本号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.ground_proc_status_cd is '落地处理状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.verify_proc_status_cd is '查证处理状态代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.rgst_addit_data_name is '登记附加数据表名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.on_acct_rs_cd is '挂账原因代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.scd_gener_msg_type_id is '二代报文类型编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.scd_gener_bus_type_cd is '二代业务类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.scd_gener_bus_kind_cd is '二代业务种类代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.charge_way_cd is '收费方式代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.e_acct_cd is '电子账户代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.chn_flow_num is '渠道流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.next_day_tran_flg is '次日转账标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.auto_refund_flg is '自动退汇标志';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.auto_refund_cnt is '自动退汇次数';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vtual_acct_bind_acct is '虚户绑定账户';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vtual_acct_bind_acct_name is '虚户绑定账户名称';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.acct_type_cd is '账户类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.vtual_open_acct_org_id is '虚户绑定账户开户机构编号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.acct_gen_cd is '账户大类型代码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.lmt_order_no is '限额订单号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.ova_flow_num is '全局流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.esb_intfc_return_code is 'esb接口返回码';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.esb_intfc_return_info is 'esb接口返回信息';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.esb_intfc_tran_flow_num is 'esb接口交易流水号';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.send_pbc_tm is '发送人行时间';
comment on column ${idl_schema}.oass_evt_bigamt_tran_evt.src_table_name is '源表名称';

