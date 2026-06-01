/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_cpes_accept_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_cpes_accept_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_cpes_accept_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cpes_accept_details(
    id varchar2(60) -- ID
    ,draft_id varchar2(60) -- 登记中心ID
    ,contract_id varchar2(60) -- 承兑批次ID
    ,draft_attr varchar2(6) -- 票据介质： ME01 纸票 ME02 电票
    ,draft_number varchar2(45) -- 票据号码/票据包编号
    ,draft_bp_range varchar2(38) -- 票据包区间
    ,draft_amount number(18,2) -- 票据金额
    ,remit_date varchar2(12) -- 出票日
    ,maturity_date varchar2(12) -- 到期日
    ,acceptor_date varchar2(12) -- 承兑签收日期
    ,end_smt_flag varchar2(6) -- 不得转让标记： EM00 可再转让 EM01 不得转让
    ,deposit_amount number(18,2) -- 保证金金额
    ,deduct_amount number(18,2) -- 扣款金额
    ,advance_amount number(18,2) -- 垫款金额
    ,charge number(18,2) -- 手续费
    ,bp_num number(8,0) -- 票据数量
    ,std_amt number(18,2) -- 标准金额
    ,txl_ctrct_nb varchar2(135) -- 交易合同编号
    ,invc_nb varchar2(135) -- 发票号码
    ,btch_nb varchar2(675) -- 报文批次号
    ,remitter_name varchar2(270) -- 出票人名称
    ,remitter_account varchar2(48) -- 出票人账号
    ,remitter_bank_no varchar2(18) -- 出票人开户行行号
    ,remitter_bank_name varchar2(270) -- 出票人开户行名称
    ,remitter_cust_no varchar2(30) -- 出票人客户号
    ,remitter_soc_code varchar2(27) -- 出票人社会信用代码
    ,remitter_type varchar2(6) -- 出票人类型
    ,remitter_brh_no varchar2(14) -- 出票人开户机构代码
    ,payee_name varchar2(270) -- 收票人名称
    ,payee_account varchar2(48) -- 收票人账号
    ,payee_bank_no varchar2(18) -- 收票人开户行行号
    ,payee_bank_name varchar2(270) -- 收票人开户行名称
    ,payee_brh_no varchar2(14) -- 收票人开户机构代码
    ,payee_soc_code varchar2(27) -- 收票人社会信用代码
    ,payee_type varchar2(6) -- 收票人类型
    ,acceptor_name varchar2(270) -- 承兑人名称
    ,acceptor_account varchar2(18) -- 承兑人账号
    ,acceptor_bank_no varchar2(18) -- 承兑人开户行号
    ,acceptor_bank_name varchar2(270) -- 承兑人开户行名称
    ,acceptor_soc_code varchar2(27) -- 承兑人社会信用代码
    ,acceptor_type varchar2(6) -- 承兑人类型
    ,acceptor_brh_no varchar2(14) -- 承兑人机构代码
    ,remitter_ratg_agcy varchar2(300) -- 出票人评级主体
    ,remitter_ratg_duedt varchar2(12) -- 出票人评级到期日
    ,remitter_credit_ratgs varchar2(5) -- 出票人信用等级
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人信用主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(5) -- 承兑人信用等级
    ,message_status varchar2(3) -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,account_status varchar2(3) -- 记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败
    ,deduct_status varchar2(3) -- 扣款状态： 00 未扣款 01 扣款成功 02 扣款失败
    ,advance_status varchar2(2) -- 垫款状态： 0 未垫款 1 垫款申请 2 垫款成功
    ,freece_flag varchar2(2) -- 保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败
    ,req_remark varchar2(1152) -- 出票人备注
    ,rcv_remark varchar2(1152) -- 承兑人备注
    ,busi_branch_no varchar2(18) -- 交易机构编号
    ,top_branch_no varchar2(30) -- 总机构号
    ,create_operator varchar2(45) -- 创建操作员
    ,create_time varchar2(21) -- 创建时间
    ,last_operator varchar2(45) -- 最后修改操作员
    ,last_update_time varchar2(21) -- 最后修改时间
    ,reserve1 varchar2(384) -- 备用字段1
    ,reserve2 varchar2(384) -- 备用字段2
    ,reserve3 varchar2(384) -- 备用字段3
    ,adjust_charge number(18,2) -- 调整后费用
    ,adjust_deposit_amount number(18,2) -- 调整后保证金
    ,valid_flag varchar2(2) -- 有效标识
    ,apply_id varchar2(60) -- 解析表ID
    ,accept_status varchar2(3) -- 票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)
    ,payment_ubank_no number(22,0) -- 付款行联行编号
    ,misc varchar2(150) -- 信息域
    ,account_date varchar2(12) -- 记账日期
    ,run_code varchar2(60) -- 记账唯一标识
    ,record_logno varchar2(21) -- 中间表对应的唯一标志
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
grant select on ${iol_schema}.bdms_cpes_accept_details to ${iml_schema};
grant select on ${iol_schema}.bdms_cpes_accept_details to ${icl_schema};
grant select on ${iol_schema}.bdms_cpes_accept_details to ${idl_schema};
grant select on ${iol_schema}.bdms_cpes_accept_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_cpes_accept_details is '承兑明细表';
comment on column ${iol_schema}.bdms_cpes_accept_details.id is 'ID';
comment on column ${iol_schema}.bdms_cpes_accept_details.draft_id is '登记中心ID';
comment on column ${iol_schema}.bdms_cpes_accept_details.contract_id is '承兑批次ID';
comment on column ${iol_schema}.bdms_cpes_accept_details.draft_attr is '票据介质： ME01 纸票 ME02 电票';
comment on column ${iol_schema}.bdms_cpes_accept_details.draft_number is '票据号码/票据包编号';
comment on column ${iol_schema}.bdms_cpes_accept_details.draft_bp_range is '票据包区间';
comment on column ${iol_schema}.bdms_cpes_accept_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_cpes_accept_details.remit_date is '出票日';
comment on column ${iol_schema}.bdms_cpes_accept_details.maturity_date is '到期日';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_date is '承兑签收日期';
comment on column ${iol_schema}.bdms_cpes_accept_details.end_smt_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_cpes_accept_details.deposit_amount is '保证金金额';
comment on column ${iol_schema}.bdms_cpes_accept_details.deduct_amount is '扣款金额';
comment on column ${iol_schema}.bdms_cpes_accept_details.advance_amount is '垫款金额';
comment on column ${iol_schema}.bdms_cpes_accept_details.charge is '手续费';
comment on column ${iol_schema}.bdms_cpes_accept_details.bp_num is '票据数量';
comment on column ${iol_schema}.bdms_cpes_accept_details.std_amt is '标准金额';
comment on column ${iol_schema}.bdms_cpes_accept_details.txl_ctrct_nb is '交易合同编号';
comment on column ${iol_schema}.bdms_cpes_accept_details.invc_nb is '发票号码';
comment on column ${iol_schema}.bdms_cpes_accept_details.btch_nb is '报文批次号';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_name is '出票人名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_bank_no is '出票人开户行行号';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_bank_name is '出票人开户行名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_cust_no is '出票人客户号';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_soc_code is '出票人社会信用代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_type is '出票人类型';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_brh_no is '出票人开户机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_name is '收票人名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_account is '收票人账号';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_bank_no is '收票人开户行行号';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_bank_name is '收票人开户行名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_brh_no is '收票人开户机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_soc_code is '收票人社会信用代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.payee_type is '收票人类型';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_name is '承兑人名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_bank_no is '承兑人开户行号';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_soc_code is '承兑人社会信用代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_type is '承兑人类型';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_brh_no is '承兑人机构代码';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_ratg_agcy is '出票人评级主体';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_ratg_duedt is '出票人评级到期日';
comment on column ${iol_schema}.bdms_cpes_accept_details.remitter_credit_ratgs is '出票人信用等级';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_ratg_agcy is '承兑人信用主体';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_cpes_accept_details.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_cpes_accept_details.message_status is '报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退';
comment on column ${iol_schema}.bdms_cpes_accept_details.account_status is '记账状态： 00 未处理 01 记账中 02 记账成功 03 记账失败 04 抹账成功 05 抹账失败';
comment on column ${iol_schema}.bdms_cpes_accept_details.deduct_status is '扣款状态： 00 未扣款 01 扣款成功 02 扣款失败';
comment on column ${iol_schema}.bdms_cpes_accept_details.advance_status is '垫款状态： 0 未垫款 1 垫款申请 2 垫款成功';
comment on column ${iol_schema}.bdms_cpes_accept_details.freece_flag is '保证金冻结标识 0 未处理 1 冻结 2 解冻 3 冻结失败';
comment on column ${iol_schema}.bdms_cpes_accept_details.req_remark is '出票人备注';
comment on column ${iol_schema}.bdms_cpes_accept_details.rcv_remark is '承兑人备注';
comment on column ${iol_schema}.bdms_cpes_accept_details.busi_branch_no is '交易机构编号';
comment on column ${iol_schema}.bdms_cpes_accept_details.top_branch_no is '总机构号';
comment on column ${iol_schema}.bdms_cpes_accept_details.create_operator is '创建操作员';
comment on column ${iol_schema}.bdms_cpes_accept_details.create_time is '创建时间';
comment on column ${iol_schema}.bdms_cpes_accept_details.last_operator is '最后修改操作员';
comment on column ${iol_schema}.bdms_cpes_accept_details.last_update_time is '最后修改时间';
comment on column ${iol_schema}.bdms_cpes_accept_details.reserve1 is '备用字段1';
comment on column ${iol_schema}.bdms_cpes_accept_details.reserve2 is '备用字段2';
comment on column ${iol_schema}.bdms_cpes_accept_details.reserve3 is '备用字段3';
comment on column ${iol_schema}.bdms_cpes_accept_details.adjust_charge is '调整后费用';
comment on column ${iol_schema}.bdms_cpes_accept_details.adjust_deposit_amount is '调整后保证金';
comment on column ${iol_schema}.bdms_cpes_accept_details.valid_flag is '有效标识';
comment on column ${iol_schema}.bdms_cpes_accept_details.apply_id is '解析表ID';
comment on column ${iol_schema}.bdms_cpes_accept_details.accept_status is '票据承兑处理状态： 00 无效 01 已提交审批 02 已票号分配 03 提交票号分配 04 记账完成 05 发送中 06 承兑完成（签发） 07 流程回退 09 电票撤销 10 未用退回 11 审核拒绝(单张票退回)';
comment on column ${iol_schema}.bdms_cpes_accept_details.payment_ubank_no is '付款行联行编号';
comment on column ${iol_schema}.bdms_cpes_accept_details.misc is '信息域';
comment on column ${iol_schema}.bdms_cpes_accept_details.account_date is '记账日期';
comment on column ${iol_schema}.bdms_cpes_accept_details.run_code is '记账唯一标识';
comment on column ${iol_schema}.bdms_cpes_accept_details.record_logno is '中间表对应的唯一标志';
comment on column ${iol_schema}.bdms_cpes_accept_details.sign is '0签收状态没同步  1签收状态已同步';
comment on column ${iol_schema}.bdms_cpes_accept_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_cpes_accept_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_cpes_accept_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_cpes_accept_details.etl_timestamp is 'ETL处理时间戳';
