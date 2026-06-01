/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_intstl_remit_evt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_intstl_remit_evt
whenever sqlerror continue none;
drop table ${iml_schema}.evt_intstl_remit_evt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intstl_remit_evt(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,sorc_sys_id varchar2(30) -- 源系统编号
    ,tran_descb varchar2(90) -- 交易描述
    ,recver_cust_id varchar2(30) -- 收款人客户编号
    ,recver_addr_name varchar2(150) -- 收款人地址名称
    ,recver_en_name varchar2(150) -- 收款人英文名称
    ,pay_bank_id varchar2(30) -- 付款银行编号
    ,pay_bank_addr_name varchar2(150) -- 付款银行地址名称
    ,pay_bank_name varchar2(150) -- 付款银行名称
    ,remiter_cust_id varchar2(30) -- 汇款人客户编号
    ,remiter_addr_name varchar2(150) -- 汇款人地址名称
    ,remiter_name varchar2(150) -- 汇款人名称
    ,remit_bank_id varchar2(30) -- 汇款银行编号
    ,remit_bank_addr_name varchar2(150) -- 汇款银行地址名称
    ,remit_bank_name varchar2(150) -- 汇款银行名称
    ,value_dt date -- 起息日期
    ,tran_start_tm date -- 交易开始时间
    ,tran_close_tm date -- 交易关闭时间
    ,abmt_msg_fee_bear_way_cd varchar2(30) -- 汇入报文费用承担方式代码
    ,remit_oper_tm date -- 汇款经办时间
    ,oper_user varchar2(45) -- 经办用户
    ,remit_out_msg_fee_bear_way_cd varchar2(30) -- 汇出报文费用承担方式代码
    ,pay_type_cd varchar2(30) -- 付款类型代码
    ,clear_id varchar2(60) -- 清算编号
    ,abmt_comm_fee_curr_cd varchar2(30) -- 汇入手续费币种代码
    ,abmt_comm_fee_amt number(30,8) -- 汇入手续费金额
    ,remit_cate_cd varchar2(30) -- 汇款类别代码
    ,remit_way_cd varchar2(30) -- 汇款方式代码
    ,pay_dt date -- 付款日期
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,soe_type_cd varchar2(30) -- 结汇类型代码
    ,init_curr_cd varchar2(30) -- 原始币种代码
    ,remit_out_comm_fee_curr_cd varchar2(30) -- 汇出手续费币种代码
    ,remit_out_comm_fee_amt number(30,8) -- 汇出手续费金额
    ,init_amt number(30,8) -- 原始金额
    ,exch_rat number(30,8) -- 汇率
    ,sell_fx_type_cd varchar2(30) -- 售汇类型代码
    ,msg_type_cd varchar2(30) -- 报文类型代码
    ,belong_org_id varchar2(30) -- 归属机构编号
    ,oper_org_id varchar2(30) -- 经办机构编号
    ,remit_proc_type_cd varchar2(30) -- 汇款处理类型代码
    ,bal_pay_type_cd varchar2(30) -- 收支类型代码
    ,remiter_acct_id varchar2(60) -- 汇款人帐户编号
    ,recver_acct_id varchar2(60) -- 收款人帐户编号
    ,refund_flg varchar2(10) -- 退汇标志
    ,nra_acct_flg varchar2(10) -- NRA账户标志
    ,clear_chn_cd varchar2(30) -- 清算渠道代码
    ,cbec_flg varchar2(10) -- 跨境电商标志
    ,cross_bor_cap_pool_flg varchar2(10) -- 跨境资金池标志
    ,cap_pool_bus_type_cd varchar2(30) -- 资金池业务类型代码
    ,cap_pool_bus_pric number(30,8) -- 资金池业务本金
    ,cap_pool_bus_int number(30,8) -- 资金池业务利息
    ,entr_pay_id varchar2(60) -- 受托支付编号
    ,entr_pay_out_acct_dubil_id varchar2(30) -- 受托支付出账借据编号
    ,gpi_remit_flg varchar2(10) -- GPI汇款标志
    ,gpi_msg_feedback_status_cd varchar2(30) -- GPI报文反馈状态代码
    ,inquiry_flg varchar2(10) -- 询价标志
    ,deduct_acct_id varchar2(60) -- 扣费账户编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_intstl_remit_evt to ${icl_schema};
grant select on ${iml_schema}.evt_intstl_remit_evt to ${idl_schema};
grant select on ${iml_schema}.evt_intstl_remit_evt to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_intstl_remit_evt is '国结汇款事件';
comment on column ${iml_schema}.evt_intstl_remit_evt.evt_id is '事件编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.lp_id is '法人编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.sorc_sys_id is '源系统编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.tran_descb is '交易描述';
comment on column ${iml_schema}.evt_intstl_remit_evt.recver_cust_id is '收款人客户编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.recver_addr_name is '收款人地址名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.recver_en_name is '收款人英文名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.pay_bank_id is '付款银行编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.pay_bank_addr_name is '付款银行地址名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.pay_bank_name is '付款银行名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.remiter_cust_id is '汇款人客户编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.remiter_addr_name is '汇款人地址名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.remiter_name is '汇款人名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_bank_id is '汇款银行编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_bank_addr_name is '汇款银行地址名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_bank_name is '汇款银行名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.value_dt is '起息日期';
comment on column ${iml_schema}.evt_intstl_remit_evt.tran_start_tm is '交易开始时间';
comment on column ${iml_schema}.evt_intstl_remit_evt.tran_close_tm is '交易关闭时间';
comment on column ${iml_schema}.evt_intstl_remit_evt.abmt_msg_fee_bear_way_cd is '汇入报文费用承担方式代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_oper_tm is '汇款经办时间';
comment on column ${iml_schema}.evt_intstl_remit_evt.oper_user is '经办用户';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_out_msg_fee_bear_way_cd is '汇出报文费用承担方式代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.pay_type_cd is '付款类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.clear_id is '清算编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.abmt_comm_fee_curr_cd is '汇入手续费币种代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.abmt_comm_fee_amt is '汇入手续费金额';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_cate_cd is '汇款类别代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_way_cd is '汇款方式代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.pay_dt is '付款日期';
comment on column ${iml_schema}.evt_intstl_remit_evt.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.soe_type_cd is '结汇类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.init_curr_cd is '原始币种代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_out_comm_fee_curr_cd is '汇出手续费币种代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_out_comm_fee_amt is '汇出手续费金额';
comment on column ${iml_schema}.evt_intstl_remit_evt.init_amt is '原始金额';
comment on column ${iml_schema}.evt_intstl_remit_evt.exch_rat is '汇率';
comment on column ${iml_schema}.evt_intstl_remit_evt.sell_fx_type_cd is '售汇类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.msg_type_cd is '报文类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.belong_org_id is '归属机构编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.remit_proc_type_cd is '汇款处理类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.bal_pay_type_cd is '收支类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.remiter_acct_id is '汇款人帐户编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.recver_acct_id is '收款人帐户编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.refund_flg is '退汇标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.nra_acct_flg is 'NRA账户标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.clear_chn_cd is '清算渠道代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.cbec_flg is '跨境电商标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.cross_bor_cap_pool_flg is '跨境资金池标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.cap_pool_bus_type_cd is '资金池业务类型代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.cap_pool_bus_pric is '资金池业务本金';
comment on column ${iml_schema}.evt_intstl_remit_evt.cap_pool_bus_int is '资金池业务利息';
comment on column ${iml_schema}.evt_intstl_remit_evt.entr_pay_id is '受托支付编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.entr_pay_out_acct_dubil_id is '受托支付出账借据编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.gpi_remit_flg is 'GPI汇款标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.gpi_msg_feedback_status_cd is 'GPI报文反馈状态代码';
comment on column ${iml_schema}.evt_intstl_remit_evt.inquiry_flg is '询价标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.deduct_acct_id is '扣费账户编号';
comment on column ${iml_schema}.evt_intstl_remit_evt.start_dt is '开始时间';
comment on column ${iml_schema}.evt_intstl_remit_evt.end_dt is '结束时间';
comment on column ${iml_schema}.evt_intstl_remit_evt.id_mark is '增删标志';
comment on column ${iml_schema}.evt_intstl_remit_evt.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_intstl_remit_evt.job_cd is '任务编码';
comment on column ${iml_schema}.evt_intstl_remit_evt.etl_timestamp is 'ETL处理时间戳';
