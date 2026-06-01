/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_accept_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_accept_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_accept_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_accept_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 承兑协议ID
    ,draft_id varchar2(60) -- 票据表ID
    ,charge number(18,2) -- 手续费
    ,expenses number(18,2) -- 工本费
    ,contractno varchar2(75) -- 交易合同编号
    ,invc_no varchar2(75) -- 发票号码
    ,btch_no varchar2(45) -- 人行承兑批次号
    ,remitter_remark varchar2(375) -- 出票人备注
    ,acceptor_remark varchar2(375) -- 承兑人备注
    ,credit_line_no varchar2(60) -- 额度占用记录
    ,credit_line number(18,2) -- 额度扣减金额
    ,credit_line_status varchar2(3) -- 额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复
    ,accept_status varchar2(3) -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,endst_date varchar2(12) -- 签收日期
    ,cancel_date varchar2(12) -- 撤销日期
    ,account_date varchar2(12) -- 记账日期
    ,account_flag varchar2(3) -- 记账状态： 0 未记账 1 记账中 2 记账完成
    ,print_status varchar2(3) -- 出票状态： 0 未打印 1 已打印
    ,deduct_status varchar2(3) -- 扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败
    ,payment_status varchar2(3) -- 付款状态（是否付款）： 0 否 1 是
    ,advance_status varchar2(3) -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,print_cnt number(8,0) -- 凭证打印次数
    ,print_flag varchar2(3) -- 补打标识： 0 有效 1 作废 2 补打中 3 补打完成
    ,reserve1 varchar2(150) -- 备注1
    ,reserve2 varchar2(150) -- 备注2
    ,reserve3 varchar2(150) -- 备注3
    ,draft_number varchar2(45) -- 票据号码
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
    ,draft_amount number(18,2) -- 票据金额
    ,end_smt_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,endorse_times number(8,0) -- 背书次数
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,drawee_bank_name varchar2(300) -- 付款行全称
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_address varchar2(750) -- 付款行地址
    ,remitter_ratg_agcy varchar2(300) -- 出票人评级主体
    ,remitter_ratg_duedt varchar2(12) -- 出票人评级到期日
    ,remitter_credit_ratgs varchar2(15) -- 出票人信用等级
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人评级主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(15) -- 承兑人信用等级
    ,accept_date varchar2(12) -- 承兑日期
    ,adjust_charge number(18,2) -- 调整后手续费
    ,guarantee_amount number(18,2) -- 保证金额
    ,adjust_guarantee_amount number(18,2) -- 调整后保证金额
    ,freece_flag varchar2(3) -- 保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,last_txn_date timestamp -- 最后修改时间
    ,last_operator_no varchar2(45) -- 最后修改操作员号
    ,register_status varchar2(23) -- 登记状态： 00 初始 10 登记发送中 20 登记成功
    ,settle_flag varchar2(30) -- 结清登记
    ,task_type varchar2(3) -- 任务类型
    ,seq_no varchar2(6) -- 序号
    ,ucondl_consgntmrk varchar2(6) -- 到期无条件支付委托只能填写CC00
    ,sig_mk varchar2(6) -- 签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串
    ,misc varchar2(150) -- 信息域
    ,ecds_prc_msg varchar2(1152) -- 人行应答消息
    ,rcv_prxy_sgntr varchar2(6) -- 承兑人代理回复标识-通用回复用PS01客户自己签章
    ,actlog_id number(22,0) -- 记账流水ID
    ,accptnc_agrmtnb varchar2(45) -- 承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码
    ,run_code varchar2(60) -- 记账唯一标识
    ,accp_detail_remark varchar2(270) -- 
    ,record_logno varchar2(21) -- 中间表对应的唯一标志
    ,billseq varchar2(59) -- 备款标志
    ,sign varchar2(2) -- 0签收状态没同步  1签收状态已同步
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
grant select on ${iol_schema}.bdms_bms_accept_details to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_accept_details to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_accept_details to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_accept_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_accept_details is '承兑明细表';
comment on column ${iol_schema}.bdms_bms_accept_details.id is 'ID';
comment on column ${iol_schema}.bdms_bms_accept_details.contract_id is '承兑协议ID';
comment on column ${iol_schema}.bdms_bms_accept_details.draft_id is '票据表ID';
comment on column ${iol_schema}.bdms_bms_accept_details.charge is '手续费';
comment on column ${iol_schema}.bdms_bms_accept_details.expenses is '工本费';
comment on column ${iol_schema}.bdms_bms_accept_details.contractno is '交易合同编号';
comment on column ${iol_schema}.bdms_bms_accept_details.invc_no is '发票号码';
comment on column ${iol_schema}.bdms_bms_accept_details.btch_no is '人行承兑批次号';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_remark is '出票人备注';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_remark is '承兑人备注';
comment on column ${iol_schema}.bdms_bms_accept_details.credit_line_no is '额度占用记录';
comment on column ${iol_schema}.bdms_bms_accept_details.credit_line is '额度扣减金额';
comment on column ${iol_schema}.bdms_bms_accept_details.credit_line_status is '额度占用状态： 0 未占用（默认） 1 已占用 2 已支用 3 已恢复';
comment on column ${iol_schema}.bdms_bms_accept_details.accept_status is '票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)';
comment on column ${iol_schema}.bdms_bms_accept_details.endst_date is '签收日期';
comment on column ${iol_schema}.bdms_bms_accept_details.cancel_date is '撤销日期';
comment on column ${iol_schema}.bdms_bms_accept_details.account_date is '记账日期';
comment on column ${iol_schema}.bdms_bms_accept_details.account_flag is '记账状态： 0 未记账 1 记账中 2 记账完成';
comment on column ${iol_schema}.bdms_bms_accept_details.print_status is '出票状态： 0 未打印 1 已打印';
comment on column ${iol_schema}.bdms_bms_accept_details.deduct_status is '扣款状态： 0 未扣款 1 扣款中 2 扣款成功 3 扣款失败';
comment on column ${iol_schema}.bdms_bms_accept_details.payment_status is '付款状态（是否付款）： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_accept_details.advance_status is '垫款状态： 0 未垫款 1 垫款申请 2 垫款成功';
comment on column ${iol_schema}.bdms_bms_accept_details.print_cnt is '凭证打印次数';
comment on column ${iol_schema}.bdms_bms_accept_details.print_flag is '补打标识： 0 有效 1 作废 2 补打中 3 补打完成';
comment on column ${iol_schema}.bdms_bms_accept_details.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_accept_details.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_accept_details.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_accept_details.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_name is '出票人全称';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_bank_name is '出票人开户银行';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_bank_no is '出票人开户银行行号';
comment on column ${iol_schema}.bdms_bms_accept_details.payee_name is '收票人全称';
comment on column ${iol_schema}.bdms_bms_accept_details.payee_account is '收票人账号';
comment on column ${iol_schema}.bdms_bms_accept_details.payee_bank_name is '收票人开户银行';
comment on column ${iol_schema}.bdms_bms_accept_details.payee_bank_no is '收票人开户银行行号';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_name is '承兑人全称';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_bms_accept_details.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_bms_accept_details.maturity_date is '汇票到期日';
comment on column ${iol_schema}.bdms_bms_accept_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_bms_accept_details.end_smt_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_accept_details.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_bms_accept_details.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_accept_details.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_accept_details.drawee_bank_name is '付款行全称';
comment on column ${iol_schema}.bdms_bms_accept_details.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_bms_accept_details.drawee_address is '付款行地址';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_ratg_agcy is '出票人评级主体';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_ratg_duedt is '出票人评级到期日';
comment on column ${iol_schema}.bdms_bms_accept_details.remitter_credit_ratgs is '出票人信用等级';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_ratg_agcy is '承兑人评级主体';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_bms_accept_details.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_bms_accept_details.accept_date is '承兑日期';
comment on column ${iol_schema}.bdms_bms_accept_details.adjust_charge is '调整后手续费';
comment on column ${iol_schema}.bdms_bms_accept_details.guarantee_amount is '保证金额';
comment on column ${iol_schema}.bdms_bms_accept_details.adjust_guarantee_amount is '调整后保证金额';
comment on column ${iol_schema}.bdms_bms_accept_details.freece_flag is '保证金冻结标志： 0 未处理 1 冻结 2 解冻 3 冻结失败';
comment on column ${iol_schema}.bdms_bms_accept_details.last_txn_date is '最后修改时间';
comment on column ${iol_schema}.bdms_bms_accept_details.last_operator_no is '最后修改操作员号';
comment on column ${iol_schema}.bdms_bms_accept_details.register_status is '登记状态： 00 初始 10 登记发送中 20 登记成功';
comment on column ${iol_schema}.bdms_bms_accept_details.settle_flag is '结清登记';
comment on column ${iol_schema}.bdms_bms_accept_details.task_type is '任务类型';
comment on column ${iol_schema}.bdms_bms_accept_details.seq_no is '序号';
comment on column ${iol_schema}.bdms_bms_accept_details.ucondl_consgntmrk is '到期无条件支付委托只能填写CC00';
comment on column ${iol_schema}.bdms_bms_accept_details.sig_mk is '签收意见SU00同意签收SU01拒绝签收电子票据用未发表意见时填空串';
comment on column ${iol_schema}.bdms_bms_accept_details.misc is '信息域';
comment on column ${iol_schema}.bdms_bms_accept_details.ecds_prc_msg is '人行应答消息';
comment on column ${iol_schema}.bdms_bms_accept_details.rcv_prxy_sgntr is '承兑人代理回复标识-通用回复用PS01客户自己签章';
comment on column ${iol_schema}.bdms_bms_accept_details.actlog_id is '记账流水ID';
comment on column ${iol_schema}.bdms_bms_accept_details.accptnc_agrmtnb is '承兑协议编号-通用回复用a-z,A-Z,0-9最短1位，最长30位的编码';
comment on column ${iol_schema}.bdms_bms_accept_details.run_code is '记账唯一标识';
comment on column ${iol_schema}.bdms_bms_accept_details.accp_detail_remark is '';
comment on column ${iol_schema}.bdms_bms_accept_details.record_logno is '中间表对应的唯一标志';
comment on column ${iol_schema}.bdms_bms_accept_details.billseq is '备款标志';
comment on column ${iol_schema}.bdms_bms_accept_details.sign is '0签收状态没同步  1签收状态已同步';
comment on column ${iol_schema}.bdms_bms_accept_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_accept_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_accept_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_accept_details.etl_timestamp is 'ETL处理时间戳';
