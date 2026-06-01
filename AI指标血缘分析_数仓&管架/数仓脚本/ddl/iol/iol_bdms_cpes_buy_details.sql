/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_buy_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_buy_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_buy_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_buy_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 协议ID
    ,draft_id varchar2(60) -- 票据表ID
    ,apply_id varchar2(60) -- 解析表ID
    ,draft_category varchar2(6) -- 票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台
    ,cd_range varchar2(38) -- 子票区间
    ,repurchase_interest number(16,2) -- 赎回利息
    ,settle_type varchar2(6) -- 结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)
    ,clear_type varchar2(6) -- 清算类型:CT01 全额清算;CT02 净额清算
    ,settle_date varchar2(12) -- 结算日期
    ,rate_type varchar2(2) -- 利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,rate number(9,6) -- 利率
    ,prom_note_no varchar2(45) -- 借票号
    ,repurchase_rate_type varchar2(2) -- 赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)
    ,repurchase_rate number(9,6) -- 赎回利率
    ,repurchase_begin_date varchar2(12) -- 赎回开放日
    ,repurchase_end_date varchar2(12) -- 赎回截止日
    ,payment_date varchar2(12) -- 计息到期日
    ,postpone_days number(8,0) -- 顺延天数
    ,adjust_postpone_days number(8,0) -- 调整后顺延天数
    ,payment_days number(8,0) -- 计息天数
    ,previous_hand varchar2(300) -- 直接前手
    ,interest number(16,2) -- 利息
    ,adjust_interest number(16,2) -- 调整后利息
    ,inner_accept_flag varchar2(2) -- 是否我行承兑： 0 否 1 是
    ,same_city_flag varchar2(2) -- 是否同城： 0 否 1 是
    ,pay_amount number(16,2) -- 实付金额
    ,important_hand varchar2(300) -- 重要背书人
    ,payer_amount number(16,2) -- 买方付息金额
    ,txl_ctrct_nb varchar2(45) -- 交易合同编号
    ,invc_nb varchar2(45) -- 发票号码
    ,btch_nb varchar2(675) -- 批次号
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,buy_status varchar2(3) -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成
    ,account_status varchar2(3) -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
    ,accont_date date -- 记账日期
    ,credit_result varchar2(3) -- 额度分析结果： 00 无效 01 成功 02 失败 04 恢复
    ,credit_id varchar2(60) -- 额度分析ID
    ,query_check_id number(8,0) -- 查询查复ID
    ,draft_number varchar2(45) -- 票据(包)号
    ,remitter_name varchar2(300) -- 出票人全称
    ,remitter_account varchar2(150) -- 出票人账号
    ,remitter_bank_name varchar2(300) -- 出票人开户银行
    ,remitter_bank_no varchar2(18) -- 出票人开户银行行号
    ,payee_name varchar2(300) -- 收票人全称
    ,payee_account varchar2(150) -- 收票人账号
    ,payee_bank_name varchar2(300) -- 收票人开户银行
    ,payee_bank_no varchar2(18) -- 收票人开户银行行号
    ,acceptor_name varchar2(300) -- 承兑人全称
    ,acceptor_account varchar2(150) -- 承兑人账号
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行行号
    ,acceptor_bank_name varchar2(300) -- 承兑人开户行名称
    ,remit_date varchar2(12) -- 出票日期
    ,maturity_date varchar2(12) -- 汇票到期日
    ,draft_amount number(18,2) -- 票据(包)金额
    ,end_smt_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,endorse_times number(8,0) -- 背书次数
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,drawee_bank_name varchar2(300) -- 付款行全称
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_address varchar2(750) -- 付款行地址
    ,df_drwr_cdtratgsagcy varchar2(300) -- 出票人评级主体
    ,df_drwr_cdtratgduedt varchar2(12) -- 出票人评级到期日
    ,df_drwr_cdtratgs varchar2(15) -- 出票人信用等级
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人评级主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(15) -- 承兑人信用等级
    ,accept_date varchar2(12) -- 承兑日期
    ,draft_remark varchar2(150) -- 票面备注
    ,reason varchar2(150) -- 原因
    ,message_status varchar2(3) -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退
    ,top_branch_no varchar2(30) -- 总行机构号
    ,aoa_account varchar2(48) -- 入账账号
    ,aoa_bank_id varchar2(18) -- 入账机构参与者代码
    ,register_status varchar2(23) -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
    ,err_code varchar2(30) -- 错误码
    ,err_msg varchar2(384) -- 错误信息
    ,aoa_account_name varchar2(675) -- 入账账户名称
    ,flash_discnt_status varchar2(2) -- 秒贴状态（1-已完成，0-未完成。）
    ,flash_discnt_flag varchar2(2) -- 是否秒贴标识（1-是，0-否，空字段也是否。）
    ,run_code varchar2(60) -- 唯一标识号
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
grant select on ${iol_schema}.bdms_cpes_buy_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_buy_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_buy_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_buy_details is '买入明细表';
comment on column ${iol_schema}.bdms_cpes_buy_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.apply_id is '解析表ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_category is '票据来源： CS01 ECDS CS02 金融机构 CS03 供应链平台';
comment on column ${iol_schema}.bdms_cpes_buy_details.cd_range is '子票区间';
comment on column ${iol_schema}.bdms_cpes_buy_details.repurchase_interest is '赎回利息';
comment on column ${iol_schema}.bdms_cpes_buy_details.settle_type is '结算方式:ST01 票款对付(DVP);ST02 纯票过户(FOP)';
comment on column ${iol_schema}.bdms_cpes_buy_details.clear_type is '清算类型:CT01 全额清算;CT02 净额清算';
comment on column ${iol_schema}.bdms_cpes_buy_details.settle_date is '结算日期';
comment on column ${iol_schema}.bdms_cpes_buy_details.rate_type is '利率类型： 1 年息% 2 月息‰ 3 日息(万分率)';
comment on column ${iol_schema}.bdms_cpes_buy_details.rate is '利率';
comment on column ${iol_schema}.bdms_cpes_buy_details.prom_note_no is '借票号';
comment on column ${iol_schema}.bdms_cpes_buy_details.repurchase_rate_type is '赎回利率类型： 1 年息% 2 月息‰ 3 日息(万分率)';
comment on column ${iol_schema}.bdms_cpes_buy_details.repurchase_rate is '赎回利率';
comment on column ${iol_schema}.bdms_cpes_buy_details.repurchase_begin_date is '赎回开放日';
comment on column ${iol_schema}.bdms_cpes_buy_details.repurchase_end_date is '赎回截止日';
comment on column ${iol_schema}.bdms_cpes_buy_details.payment_date is '计息到期日';
comment on column ${iol_schema}.bdms_cpes_buy_details.postpone_days is '顺延天数';
comment on column ${iol_schema}.bdms_cpes_buy_details.adjust_postpone_days is '调整后顺延天数';
comment on column ${iol_schema}.bdms_cpes_buy_details.payment_days is '计息天数';
comment on column ${iol_schema}.bdms_cpes_buy_details.previous_hand is '直接前手';
comment on column ${iol_schema}.bdms_cpes_buy_details.interest is '利息';
comment on column ${iol_schema}.bdms_cpes_buy_details.adjust_interest is '调整后利息';
comment on column ${iol_schema}.bdms_cpes_buy_details.inner_accept_flag is '是否我行承兑： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_buy_details.same_city_flag is '是否同城： 0 否 1 是';
comment on column ${iol_schema}.bdms_cpes_buy_details.pay_amount is '实付金额';
comment on column ${iol_schema}.bdms_cpes_buy_details.important_hand is '重要背书人';
comment on column ${iol_schema}.bdms_cpes_buy_details.payer_amount is '买方付息金额';
comment on column ${iol_schema}.bdms_cpes_buy_details.txl_ctrct_nb is '交易合同编号';
comment on column ${iol_schema}.bdms_cpes_buy_details.invc_nb is '发票号码';
comment on column ${iol_schema}.bdms_cpes_buy_details.btch_nb is '批次号';
comment on column ${iol_schema}.bdms_cpes_buy_details.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_cpes_buy_details.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_cpes_buy_details.buy_status is '明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝 10 报文处理中 11 报文处理完成 20 到期处理中 21 到期处理完成';
comment on column ${iol_schema}.bdms_cpes_buy_details.account_status is '记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过';
comment on column ${iol_schema}.bdms_cpes_buy_details.accont_date is '记账日期';
comment on column ${iol_schema}.bdms_cpes_buy_details.credit_result is '额度分析结果： 00 无效 01 成功 02 失败 04 恢复';
comment on column ${iol_schema}.bdms_cpes_buy_details.credit_id is '额度分析ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.query_check_id is '查询查复ID';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_number is '票据(包)号';
comment on column ${iol_schema}.bdms_cpes_buy_details.remitter_name is '出票人全称';
comment on column ${iol_schema}.bdms_cpes_buy_details.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_cpes_buy_details.remitter_bank_name is '出票人开户银行';
comment on column ${iol_schema}.bdms_cpes_buy_details.remitter_bank_no is '出票人开户银行行号';
comment on column ${iol_schema}.bdms_cpes_buy_details.payee_name is '收票人全称';
comment on column ${iol_schema}.bdms_cpes_buy_details.payee_account is '收票人账号';
comment on column ${iol_schema}.bdms_cpes_buy_details.payee_bank_name is '收票人开户银行';
comment on column ${iol_schema}.bdms_cpes_buy_details.payee_bank_no is '收票人开户银行行号';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_name is '承兑人全称';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_cpes_buy_details.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_cpes_buy_details.maturity_date is '汇票到期日';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_amount is '票据(包)金额';
comment on column ${iol_schema}.bdms_cpes_buy_details.end_smt_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_cpes_buy_details.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_cpes_buy_details.drawee_bank_name is '付款行全称';
comment on column ${iol_schema}.bdms_cpes_buy_details.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_cpes_buy_details.drawee_address is '付款行地址';
comment on column ${iol_schema}.bdms_cpes_buy_details.df_drwr_cdtratgsagcy is '出票人评级主体';
comment on column ${iol_schema}.bdms_cpes_buy_details.df_drwr_cdtratgduedt is '出票人评级到期日';
comment on column ${iol_schema}.bdms_cpes_buy_details.df_drwr_cdtratgs is '出票人信用等级';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_ratg_agcy is '承兑人评级主体';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_cpes_buy_details.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_cpes_buy_details.accept_date is '承兑日期';
comment on column ${iol_schema}.bdms_cpes_buy_details.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_cpes_buy_details.reason is '原因';
comment on column ${iol_schema}.bdms_cpes_buy_details.message_status is '报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 13 收到人行确认,清算成功(申请、签收） 14 收到人行确认,清算失败(申请、签收） 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到线上清退';
comment on column ${iol_schema}.bdms_cpes_buy_details.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_cpes_buy_details.aoa_account is '入账账号';
comment on column ${iol_schema}.bdms_cpes_buy_details.aoa_bank_id is '入账机构参与者代码';
comment on column ${iol_schema}.bdms_cpes_buy_details.register_status is '登记状态： 00 初始 10 登记发送中 20 登记成功';
comment on column ${iol_schema}.bdms_cpes_buy_details.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_cpes_buy_details.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_cpes_buy_details.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_cpes_buy_details.err_code is '错误码';
comment on column ${iol_schema}.bdms_cpes_buy_details.err_msg is '错误信息';
comment on column ${iol_schema}.bdms_cpes_buy_details.aoa_account_name is '入账账户名称';
comment on column ${iol_schema}.bdms_cpes_buy_details.flash_discnt_status is '秒贴状态（1-已完成，0-未完成。）';
comment on column ${iol_schema}.bdms_cpes_buy_details.flash_discnt_flag is '是否秒贴标识（1-是，0-否，空字段也是否。）';
comment on column ${iol_schema}.bdms_cpes_buy_details.run_code is '唯一标识号';
comment on column ${iol_schema}.bdms_cpes_buy_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_buy_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_buy_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_buy_details.etl_timestamp is 'ETL处理时间戳';
