/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml agt_intrbnk_refactor_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.agt_intrbnk_refactor_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.agt_intrbnk_refactor_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_intrbnk_refactor_info_h(
    agt_id varchar2(250) -- 协议编号
    ,lp_id varchar2(100) -- 法人编号
    ,id varchar2(100) -- ID
    ,intrbnk_refactor_id varchar2(100) -- 跨行再保理编号
    ,bus_type_cd varchar2(30) -- 业务类型代码
    ,flow_status_cd varchar2(30) -- 流程状态代码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,init_agt_id varchar2(100) -- 原协议编号
    ,factor_bank_no varchar2(60) -- 保理行号
    ,factor_bank_name varchar2(500) -- 保理行名称
    ,refactor_bank_no varchar2(60) -- 再保理行号
    ,refactor_bank_name varchar2(500) -- 再保理行名称
    ,aldy_sell_refactor_id varchar2(100) -- 已卖出再保理编号
    ,sell_dt date -- 卖出日期
    ,buy_out_net_amnt number(30,8) -- 买断净额
    ,buy_out_amt number(30,8) -- 买断金额
    ,buy_out_int_rat number(30,2) -- 买断利率
    ,buy_int number(30,2) -- 买断利息
    ,buy_out_net_amnt_pay_tenor number(10) -- 买断净额支付期限
    ,comm_fee number(30,2) -- 手续费
    ,tenor number(30) -- 期限
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,crdt_risk_guar_bank_name varchar2(500) -- 信用风险担保行名称
    ,pre_recv_int_flg varchar2(10) -- 预收息标志
    ,int_paybl number(30,8) -- 应付利息
    ,cfm_closing_dt date -- 确认截止日期
    ,recvbl_acct_id varchar2(100) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,open_bank_num varchar2(60) -- 开户行号
    ,open_bank_name varchar2(500) -- 开户行名称
    ,lg_pay_id varchar2(100) -- 大额支付编号
    ,cotas_name varchar2(500) -- 联系人名称
    ,tel varchar2(60) -- 电话
    ,mailbox varchar2(60) -- 邮箱
    ,deduct_status_cd varchar2(30) -- 回款划出状态代码
    ,deduct_dt date -- 回款划出日期
    ,rededuct_flow_num varchar2(100) -- 回款划出转账流水号
    ,rededuct_dt date -- 回款划出转账日期
    ,rededuct_plat_flow_num varchar2(100) -- 回款划出转账平台流水号
    ,rededuct_plat_tran_dt date -- 回款划出转账平台交易日期
    ,rededuct_pay_acct_id varchar2(100) -- 回款划出付款账户编号
    ,rededuct_pay_name varchar2(500) -- 回款划出付款名称
    ,rededuct_pay_acct_bal number(30,2) -- 回款划出付款账户余额
    ,rededuct_recver_bank_id varchar2(100) -- 回款划出收款方银行编号
    ,rededuct_recver_acct_id varchar2(100) -- 回款划出收款人账户编号
    ,rededuct_recvbl_name varchar2(500) -- 回款划出收款名称
    ,rededuct_postsc varchar2(500) -- 回款划出附言
    ,amort_rgst_status_cd varchar2(30) -- 摊销登记状态代码
    ,sys_del_flg varchar2(10) -- 系统内删除标志
    ,remark varchar2(2000) -- 备注
    ,operr_id varchar2(100) -- 经办人编号
    ,oper_org_id varchar2(100) -- 经办机构编号
    ,oper_dt date -- 经办日期
    ,entry_org_id varchar2(100) -- 记账机构编号
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
grant select on ${iml_schema}.agt_intrbnk_refactor_info_h to ${icl_schema};
grant select on ${iml_schema}.agt_intrbnk_refactor_info_h to ${idl_schema};
grant select on ${iml_schema}.agt_intrbnk_refactor_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.agt_intrbnk_refactor_info_h is '跨行再保理信息历史';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.agt_id is '协议编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.id is 'ID';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.intrbnk_refactor_id is '跨行再保理编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.flow_status_cd is '流程状态代码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.init_agt_id is '原协议编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.factor_bank_no is '保理行号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.factor_bank_name is '保理行名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.refactor_bank_no is '再保理行号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.refactor_bank_name is '再保理行名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.aldy_sell_refactor_id is '已卖出再保理编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.sell_dt is '卖出日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.buy_out_net_amnt is '买断净额';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.buy_out_amt is '买断金额';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.buy_out_int_rat is '买断利率';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.buy_int is '买断利息';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.buy_out_net_amnt_pay_tenor is '买断净额支付期限';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.comm_fee is '手续费';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.tenor is '期限';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.value_dt is '起息日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.crdt_risk_guar_bank_name is '信用风险担保行名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.pre_recv_int_flg is '预收息标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.int_paybl is '应付利息';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.cfm_closing_dt is '确认截止日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.open_bank_num is '开户行号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.open_bank_name is '开户行名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.lg_pay_id is '大额支付编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.cotas_name is '联系人名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.tel is '电话';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.mailbox is '邮箱';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.deduct_status_cd is '回款划出状态代码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.deduct_dt is '回款划出日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_flow_num is '回款划出转账流水号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_dt is '回款划出转账日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_plat_flow_num is '回款划出转账平台流水号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_plat_tran_dt is '回款划出转账平台交易日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_pay_acct_id is '回款划出付款账户编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_pay_name is '回款划出付款名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_pay_acct_bal is '回款划出付款账户余额';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_recver_bank_id is '回款划出收款方银行编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_recver_acct_id is '回款划出收款人账户编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_recvbl_name is '回款划出收款名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.rededuct_postsc is '回款划出附言';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.amort_rgst_status_cd is '摊销登记状态代码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.sys_del_flg is '系统内删除标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.remark is '备注';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.operr_id is '经办人编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.oper_org_id is '经办机构编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.oper_dt is '经办日期';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.entry_org_id is '记账机构编号';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.agt_intrbnk_refactor_info_h.etl_timestamp is 'ETL处理时间戳';
