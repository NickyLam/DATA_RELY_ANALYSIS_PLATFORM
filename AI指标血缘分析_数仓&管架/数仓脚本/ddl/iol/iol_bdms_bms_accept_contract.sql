/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_accept_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_accept_contract
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_accept_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_contract(
    id varchar2(60) -- ID
    ,protocol_no varchar2(45) -- 承兑协议号
    ,credit_no varchar2(45) -- 信贷合同号
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,prod_no varchar2(23) -- 产品类型编码
    ,actually_industy varchar2(15) -- 行业
    ,apply_accept_amount number(18,2) -- 申请承兑金额
    ,apply_remit_date varchar2(12) -- 申请出票日
    ,maturity_date varchar2(12) -- 到期日
    ,trans_amount number(18,2) -- 交易金额
    ,credit_contract_amount number(18,2) -- 信贷合同金额
    ,credit_flow_no varchar2(60) -- 信贷流水号
    ,apply_no varchar2(45) -- 申请编号
    ,audit_status varchar2(3) -- 审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)
    ,bail_ratio number(18,8) -- 保证金比例
    ,remitter_name varchar2(300) -- 出票人
    ,remitter_account varchar2(60) -- 出票人账号
    ,remitter_brch_no varchar2(30) -- 出票人开户机构
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(300) -- 出票人开户行行名
    ,drawee_bank_no varchar2(18) -- 付款行号
    ,drawee_bank_name varchar2(300) -- 付款行名
    ,remitter_cust_no varchar2(30) -- 出票人客户号
    ,top_branch_no varchar2(30) -- 总行机构号
    ,busi_branch_no varchar2(30) -- 业务发起机构号
    ,trans_branch_no varchar2(30) -- 交易机构号(记账机构)
    ,acct_branch_no varchar2(30) -- 账务机构号
    ,guarantee_type varchar2(3) -- 担保方式： 1 大额存单 2 抵制压物
    ,pledge_no varchar2(45) -- 抵质押编号
    ,pledge_amount number(18,2) -- 抵质押价值
    ,charge_ratio number(8,8) -- 手续费比例
    ,impawn_percent number(8,5) -- 质押比例
    ,protocol_status varchar2(3) -- 协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)
    ,credit_check_status varchar2(3) -- 授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过
    ,credit_fee_ratio number(8,5) -- 额度管理费比例
    ,source_type varchar2(2) -- 数据来源类型： 1 手工录入 2 网银获得
    ,department_no varchar2(30) -- 部门号
    ,manager_no varchar2(30) -- 客户经理号
    ,draft_pool_ratio number(8,5) -- 额度池占用比例
    ,mend_flag varchar2(3) -- 跟单资料后补标志： 0 否 1 是
    ,operator_no varchar2(45) -- 操作员号
    ,operator_date timestamp -- 操作日期
    ,task_type varchar2(3) -- 任务类型
    ,issuing_mode varchar2(3) -- 签发模式
    ,agency_bank_name varchar2(300) -- 被代理行全称
    ,agency_bank_no varchar2(18) -- 被代理行行号
    ,entrust_cust_no varchar2(30) -- 委托行客户号
    ,exposure_mgn_ratio number(8,5) -- 敞口费比例
    ,assurance_ratio number(8,5) -- 协议保证金比例
    ,assurance_amount number(16,2) -- 协议保证金金额
    ,add_last_date timestamp -- 资料后补日期
    ,apply_reason varchar2(150) -- 申请原因和用途
    ,reserve1 varchar2(384) -- 备注1
    ,reserve2 varchar2(384) -- 备注2
    ,reserve3 varchar2(384) -- 备注13
    ,agency_name varchar2(75) -- 被代理人全称
    ,agency_account varchar2(75) -- 被代理人帐号
    ,guarantee_state varchar2(3) -- 担保类型： 1 一对多 2 一对一
    ,last_txn_date timestamp -- 最后修改时间
    ,last_operator_no varchar2(45) -- 最后修改操作员
    ,credit_status varchar2(3) -- 风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人评级主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(15) -- 承兑人信用等级
    ,bail_rate number(9,6) -- 保证金利率
    ,drawee_address varchar2(225) -- 付款行地址
    ,webbank_contract_id number(22,0) -- 网银承兑协议ID
    ,repayment_acct varchar2(60) -- 还款账号
    ,unique_seq_num varchar2(50) -- 业务流水号(交易订单号)
    ,credit_fee_scale number(8,5) -- 额度管理费比例
    ,logic_check_status varchar2(2) -- 业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败
    ,misc varchar2(150) -- 信息域
    ,manage_fee number(18,2) -- 管理费
    ,accept_fee number(18,2) -- 承兑费
    ,contract_date varchar2(30) -- 信贷返回的协议到期日
    ,acct_amount number(18,2) -- 结算账号余额
    ,all_credit_exp number(18,2) -- 已批准使用授信敞口
    ,total_use_credit_exp number(18,2) -- 本次放款后累计使用敞口
    ,cert_type varchar2(15) -- 证件类型
    ,cert_id varchar2(75) -- 证件ID
    ,report_url varchar2(375) -- 征信报告URL
    ,core_enterprise varchar2(120) -- 核心企业名称
    ,core_enterprise_cmoncd varchar2(48) -- 核心企业组织机构代码
    ,batch_no varchar2(30) -- 网银批量号码
    ,file_name varchar2(150) -- 走文件方式文件名
    ,is_related varchar2(3) -- 是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实
    ,bail_term varchar2(6) -- 保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年
    ,bail_account varchar2(60) -- 保证金账号
    ,bail_type varchar2(6) -- 保证金类型 PG01 定期PG02 活期AC99 协议
    ,rates_type varchar2(6) -- 利率类型  0 我行挂牌利率1 协议利率2 浮动利率
    ,pdrifd varchar2(75) -- 保证金利率浮动类型
    ,pdrifm varchar2(75) -- 保证金利率浮动方式
    ,pdrifv number(18,2) -- 保证金浮动值
    ,business_exp number(18,2) -- 业务合同占用敞口金额
    ,low_risk varchar2(2) -- 是否低风险业务
    ,credit_protocol_no varchar2(75) -- 信贷业务合同号
    ,contract_status varchar2(3) -- 批次状态
    ,first_repayment_acct varchar2(60) -- 第一还款账号
    ,acct_status varchar2(3) -- 
    ,send_file_status varchar2(3) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.bdms_bms_accept_contract to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_accept_contract to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_accept_contract to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_accept_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_accept_contract is '承兑批次表';
comment on column ${iol_schema}.bdms_bms_accept_contract.id is 'ID';
comment on column ${iol_schema}.bdms_bms_accept_contract.protocol_no is '承兑协议号';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_no is '信贷合同号';
comment on column ${iol_schema}.bdms_bms_accept_contract.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_accept_contract.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_accept_contract.prod_no is '产品类型编码';
comment on column ${iol_schema}.bdms_bms_accept_contract.actually_industy is '行业';
comment on column ${iol_schema}.bdms_bms_accept_contract.apply_accept_amount is '申请承兑金额';
comment on column ${iol_schema}.bdms_bms_accept_contract.apply_remit_date is '申请出票日';
comment on column ${iol_schema}.bdms_bms_accept_contract.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_bms_accept_contract.trans_amount is '交易金额';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_contract_amount is '信贷合同金额';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_flow_no is '信贷流水号';
comment on column ${iol_schema}.bdms_bms_accept_contract.apply_no is '申请编号';
comment on column ${iol_schema}.bdms_bms_accept_contract.audit_status is '审核状态： 0 未审核 1 已提交审核 2 审核中 3 审核成功 4 审核失败 5 回退 6 审批中(单笔退回)';
comment on column ${iol_schema}.bdms_bms_accept_contract.bail_ratio is '保证金比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_name is '出票人';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_brch_no is '出票人开户机构';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_bank_name is '出票人开户行行名';
comment on column ${iol_schema}.bdms_bms_accept_contract.drawee_bank_no is '付款行号';
comment on column ${iol_schema}.bdms_bms_accept_contract.drawee_bank_name is '付款行名';
comment on column ${iol_schema}.bdms_bms_accept_contract.remitter_cust_no is '出票人客户号';
comment on column ${iol_schema}.bdms_bms_accept_contract.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_bms_accept_contract.busi_branch_no is '业务发起机构号';
comment on column ${iol_schema}.bdms_bms_accept_contract.trans_branch_no is '交易机构号(记账机构)';
comment on column ${iol_schema}.bdms_bms_accept_contract.acct_branch_no is '账务机构号';
comment on column ${iol_schema}.bdms_bms_accept_contract.guarantee_type is '担保方式： 1 大额存单 2 抵制压物';
comment on column ${iol_schema}.bdms_bms_accept_contract.pledge_no is '抵质押编号';
comment on column ${iol_schema}.bdms_bms_accept_contract.pledge_amount is '抵质押价值';
comment on column ${iol_schema}.bdms_bms_accept_contract.charge_ratio is '手续费比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.impawn_percent is '质押比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.protocol_status is '协议状态： 0 已录入 1 已提交审批 2 审批完成 3 已提交票号分配 4 已提交保证金冻结　待记账 5 记账完成 6 承兑完成（签发） 7 回退 8 已抹账 9 已撤票 10 审批中(单笔退回)';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_check_status is '授信检查状态： 00 无效 01 成功 02 失败 04 恢复 05 检查通过';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_fee_ratio is '额度管理费比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.source_type is '数据来源类型： 1 手工录入 2 网银获得';
comment on column ${iol_schema}.bdms_bms_accept_contract.department_no is '部门号';
comment on column ${iol_schema}.bdms_bms_accept_contract.manager_no is '客户经理号';
comment on column ${iol_schema}.bdms_bms_accept_contract.draft_pool_ratio is '额度池占用比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.mend_flag is '跟单资料后补标志： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_accept_contract.operator_no is '操作员号';
comment on column ${iol_schema}.bdms_bms_accept_contract.operator_date is '操作日期';
comment on column ${iol_schema}.bdms_bms_accept_contract.task_type is '任务类型';
comment on column ${iol_schema}.bdms_bms_accept_contract.issuing_mode is '签发模式';
comment on column ${iol_schema}.bdms_bms_accept_contract.agency_bank_name is '被代理行全称';
comment on column ${iol_schema}.bdms_bms_accept_contract.agency_bank_no is '被代理行行号';
comment on column ${iol_schema}.bdms_bms_accept_contract.entrust_cust_no is '委托行客户号';
comment on column ${iol_schema}.bdms_bms_accept_contract.exposure_mgn_ratio is '敞口费比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.assurance_ratio is '协议保证金比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.assurance_amount is '协议保证金金额';
comment on column ${iol_schema}.bdms_bms_accept_contract.add_last_date is '资料后补日期';
comment on column ${iol_schema}.bdms_bms_accept_contract.apply_reason is '申请原因和用途';
comment on column ${iol_schema}.bdms_bms_accept_contract.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_accept_contract.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_accept_contract.reserve3 is '备注13';
comment on column ${iol_schema}.bdms_bms_accept_contract.agency_name is '被代理人全称';
comment on column ${iol_schema}.bdms_bms_accept_contract.agency_account is '被代理人帐号';
comment on column ${iol_schema}.bdms_bms_accept_contract.guarantee_state is '担保类型： 1 一对多 2 一对一';
comment on column ${iol_schema}.bdms_bms_accept_contract.last_txn_date is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_accept_contract.last_operator_no is '最后修改操作员';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_status is '风险检查状态： 0 无效 1 检查通过 2 检查通过，存在风险 3 检查不通过';
comment on column ${iol_schema}.bdms_bms_accept_contract.acceptor_ratg_agcy is '承兑人评级主体';
comment on column ${iol_schema}.bdms_bms_accept_contract.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_bms_accept_contract.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_bms_accept_contract.bail_rate is '保证金利率';
comment on column ${iol_schema}.bdms_bms_accept_contract.drawee_address is '付款行地址';
comment on column ${iol_schema}.bdms_bms_accept_contract.webbank_contract_id is '网银承兑协议ID';
comment on column ${iol_schema}.bdms_bms_accept_contract.repayment_acct is '还款账号';
comment on column ${iol_schema}.bdms_bms_accept_contract.unique_seq_num is '业务流水号(交易订单号)';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_fee_scale is '额度管理费比例';
comment on column ${iol_schema}.bdms_bms_accept_contract.logic_check_status is '业务逻辑检查状态1-业务逻辑未检查2-业务逻辑检查成功3-业务逻辑检查失败';
comment on column ${iol_schema}.bdms_bms_accept_contract.misc is '信息域';
comment on column ${iol_schema}.bdms_bms_accept_contract.manage_fee is '管理费';
comment on column ${iol_schema}.bdms_bms_accept_contract.accept_fee is '承兑费';
comment on column ${iol_schema}.bdms_bms_accept_contract.contract_date is '信贷返回的协议到期日';
comment on column ${iol_schema}.bdms_bms_accept_contract.acct_amount is '结算账号余额';
comment on column ${iol_schema}.bdms_bms_accept_contract.all_credit_exp is '已批准使用授信敞口';
comment on column ${iol_schema}.bdms_bms_accept_contract.total_use_credit_exp is '本次放款后累计使用敞口';
comment on column ${iol_schema}.bdms_bms_accept_contract.cert_type is '证件类型';
comment on column ${iol_schema}.bdms_bms_accept_contract.cert_id is '证件ID';
comment on column ${iol_schema}.bdms_bms_accept_contract.report_url is '征信报告URL';
comment on column ${iol_schema}.bdms_bms_accept_contract.core_enterprise is '核心企业名称';
comment on column ${iol_schema}.bdms_bms_accept_contract.core_enterprise_cmoncd is '核心企业组织机构代码';
comment on column ${iol_schema}.bdms_bms_accept_contract.batch_no is '网银批量号码';
comment on column ${iol_schema}.bdms_bms_accept_contract.file_name is '走文件方式文件名';
comment on column ${iol_schema}.bdms_bms_accept_contract.is_related is '是否关联方查询 Y-是我行关联方N-未在我行关联方信息库中找出完全匹配信息P-关联方是自然人，须同时输入姓名和证件号进行查询M-通过输入信息查询出多个关联方,请输入更详细的信息进行查询L-名称非常接近，请做进一步核实';
comment on column ${iol_schema}.bdms_bms_accept_contract.bail_term is '保证金期限 000 活期203 三个月206 六个月301 一年302 两年303 三年305 五年';
comment on column ${iol_schema}.bdms_bms_accept_contract.bail_account is '保证金账号';
comment on column ${iol_schema}.bdms_bms_accept_contract.bail_type is '保证金类型 PG01 定期PG02 活期AC99 协议';
comment on column ${iol_schema}.bdms_bms_accept_contract.rates_type is '利率类型  0 我行挂牌利率1 协议利率2 浮动利率';
comment on column ${iol_schema}.bdms_bms_accept_contract.pdrifd is '保证金利率浮动类型';
comment on column ${iol_schema}.bdms_bms_accept_contract.pdrifm is '保证金利率浮动方式';
comment on column ${iol_schema}.bdms_bms_accept_contract.pdrifv is '保证金浮动值';
comment on column ${iol_schema}.bdms_bms_accept_contract.business_exp is '业务合同占用敞口金额';
comment on column ${iol_schema}.bdms_bms_accept_contract.low_risk is '是否低风险业务';
comment on column ${iol_schema}.bdms_bms_accept_contract.credit_protocol_no is '信贷业务合同号';
comment on column ${iol_schema}.bdms_bms_accept_contract.contract_status is '批次状态';
comment on column ${iol_schema}.bdms_bms_accept_contract.first_repayment_acct is '第一还款账号';
comment on column ${iol_schema}.bdms_bms_accept_contract.acct_status is '';
comment on column ${iol_schema}.bdms_bms_accept_contract.send_file_status is '';
comment on column ${iol_schema}.bdms_bms_accept_contract.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_accept_contract.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_accept_contract.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_accept_contract.etl_timestamp is 'ETL处理时间戳';
