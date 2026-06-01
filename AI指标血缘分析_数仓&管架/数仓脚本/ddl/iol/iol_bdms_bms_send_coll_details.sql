/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_bms_send_coll_details
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_bms_send_coll_details
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_bms_send_coll_details purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_bms_send_coll_details(
    id varchar2(60) -- ID
    ,contract_id varchar2(60) -- 协议ID
    ,draft_id varchar2(60) -- 票据ID
    ,send_state varchar2(2) -- 发托状态： 1 发托 2 款到 3 托收退票
    ,fee_mode varchar2(3) -- 手续费模式： 1 按票面金额 2 按票据张数 3 客户指定
    ,fee number(18,2) -- 费用
    ,adjust_fee number(18,2) -- 调整后费用
    ,valet_flag varchar2(2) -- 是否代客托收： 0 否 1 是
    ,sttlm_mk varchar2(6) -- 清算方式： SM00 线上清算 SM01 线下清算
    ,drft_hldr_no varchar2(30) -- （发托）提示付款人客户号
    ,drft_hldr_name varchar2(300) -- （发托）提示入款人全称
    ,drft_hldr_account varchar2(150) -- （发托）提示付款人入账帐号
    ,drft_hldr_bank_no varchar2(18) -- （发托）提示付款人开户行行号
    ,drft_hldr_bank_name varchar2(300) -- （发托）提示付款人开户行名称
    ,drft_hldr_address varchar2(750) -- （发托）提示付款人地址
    ,apply_date varchar2(12) -- 托收申请日
    ,receiver_name varchar2(300) -- 付款人全称
    ,receiver_account varchar2(150) -- 付款人账号
    ,receiver_bank_name varchar2(300) -- 付款人开户行
    ,receiver_address varchar2(750) -- 付款人地址
    ,send_print_name varchar2(300) -- 托收凭据名称
    ,send_content varchar2(300) -- 委托内容
    ,send_count number(22,0) -- 附寄单证张数
    ,contract_name_num varchar2(300) -- 合同名称号码
    ,send_situation varchar2(300) -- 商品运发情况
    ,mic varchar2(300) -- 备注
    ,ovrdue_rsn varchar2(384) -- 逾期原因说明
    ,apply_curcd varchar2(5) -- 提示付款币种： CNY 人民币
    ,drft_hldr_agcy_ubank varchar2(18) -- 提示付款人承接行行号
    ,req_remark varchar2(1152) -- 提示付款人备注
    ,req_prxy_prop_stn varchar2(6) -- 提示付款代理申请标识
    ,rcv_remark varchar2(1152) -- 承兑人备注
    ,rcv_prxy_sgntr varchar2(6) -- 承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章
    ,operator_no varchar2(45) -- 业务发起人编号
    ,txn_date varchar2(12) -- 记账日期
    ,last_operator_no varchar2(45) -- 最后操作员编号
    ,last_txn_date timestamp -- 最后操作日期
    ,send_coll_status varchar2(3) -- 明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝
    ,account_status varchar2(3) -- 记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过
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
    ,endorse_times number(22,0) -- 背书次数
    ,draft_attr varchar2(2) -- 票据属性： 1 纸票 2 电票
    ,draft_type varchar2(2) -- 票据类型： 1 银票 2 商票
    ,drawee_bank_name varchar2(300) -- 付款行全称
    ,drawee_bank_no varchar2(18) -- 付款行行号
    ,drawee_address varchar2(750) -- 付款行地址
    ,df_drwr_cdtratgsagcy varchar2(300) -- 出票人评级主体
    ,df_drwr_cdtratgduedt varchar2(12) -- 出票人评级到期日
    ,df_drwr_cdtratgs varchar2(15) -- 出票人信用等级
    ,reason varchar2(150) -- 原因
    ,draft_remark varchar2(150) -- 票面备注
    ,acceptor_ratg_agcy varchar2(300) -- 承兑人评级主体
    ,acceptor_ratg_duedt varchar2(12) -- 承兑人评级到期日
    ,acceptor_credit_ratgs varchar2(15) -- 承兑人信用等级
    ,accept_date varchar2(12) -- 承兑日期
    ,reserve1 varchar2(375) -- 备注1
    ,reserve2 varchar2(375) -- 备注2
    ,reserve3 varchar2(375) -- 备注3
    ,message_status varchar2(3) -- 报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退
    ,busi_branch_no varchar2(30) -- BUSI_BRANCH_NO
    ,if_over_flag varchar2(2) -- IF_OVER_FLAG
    ,top_branch_no varchar2(30) -- 总行机构号
    ,core_account varchar2(270) -- 核心记账账号
    ,paymsgsrc varchar2(75) -- 来账信息来源
    ,trandate varchar2(12) -- 来账日期
    ,trannumber varchar2(180) -- 来账查询流水号
    ,account_date varchar2(12) -- 
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
grant select on ${iol_schema}.bdms_bms_send_coll_details to ${iml_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_details to ${icl_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_details to ${idl_schema};
grant select on ${iol_schema}.bdms_bms_send_coll_details to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_bms_send_coll_details is '托收明细表';
comment on column ${iol_schema}.bdms_bms_send_coll_details.id is 'ID';
comment on column ${iol_schema}.bdms_bms_send_coll_details.contract_id is '协议ID';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_id is '票据ID';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_state is '发托状态： 1 发托 2 款到 3 托收退票';
comment on column ${iol_schema}.bdms_bms_send_coll_details.fee_mode is '手续费模式： 1 按票面金额 2 按票据张数 3 客户指定';
comment on column ${iol_schema}.bdms_bms_send_coll_details.fee is '费用';
comment on column ${iol_schema}.bdms_bms_send_coll_details.adjust_fee is '调整后费用';
comment on column ${iol_schema}.bdms_bms_send_coll_details.valet_flag is '是否代客托收： 0 否 1 是';
comment on column ${iol_schema}.bdms_bms_send_coll_details.sttlm_mk is '清算方式： SM00 线上清算 SM01 线下清算';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_no is '（发托）提示付款人客户号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_name is '（发托）提示入款人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_account is '（发托）提示付款人入账帐号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_bank_no is '（发托）提示付款人开户行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_bank_name is '（发托）提示付款人开户行名称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_address is '（发托）提示付款人地址';
comment on column ${iol_schema}.bdms_bms_send_coll_details.apply_date is '托收申请日';
comment on column ${iol_schema}.bdms_bms_send_coll_details.receiver_name is '付款人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.receiver_account is '付款人账号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.receiver_bank_name is '付款人开户行';
comment on column ${iol_schema}.bdms_bms_send_coll_details.receiver_address is '付款人地址';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_print_name is '托收凭据名称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_content is '委托内容';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_count is '附寄单证张数';
comment on column ${iol_schema}.bdms_bms_send_coll_details.contract_name_num is '合同名称号码';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_situation is '商品运发情况';
comment on column ${iol_schema}.bdms_bms_send_coll_details.mic is '备注';
comment on column ${iol_schema}.bdms_bms_send_coll_details.ovrdue_rsn is '逾期原因说明';
comment on column ${iol_schema}.bdms_bms_send_coll_details.apply_curcd is '提示付款币种： CNY 人民币';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drft_hldr_agcy_ubank is '提示付款人承接行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.req_remark is '提示付款人备注';
comment on column ${iol_schema}.bdms_bms_send_coll_details.req_prxy_prop_stn is '提示付款代理申请标识';
comment on column ${iol_schema}.bdms_bms_send_coll_details.rcv_remark is '承兑人备注';
comment on column ${iol_schema}.bdms_bms_send_coll_details.rcv_prxy_sgntr is '承兑人代理回复标识： PS00 开户机构代理回复签章 PS01 票据当事人自己签章';
comment on column ${iol_schema}.bdms_bms_send_coll_details.operator_no is '业务发起人编号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.txn_date is '记账日期';
comment on column ${iol_schema}.bdms_bms_send_coll_details.last_operator_no is '最后操作员编号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.last_txn_date is '最后操作日期';
comment on column ${iol_schema}.bdms_bms_send_coll_details.send_coll_status is '明细状态： 00 无效 01 未完成检查 02 检查完成待提交 03 已提交待审核 04 审核中 05 审核完成待（人行处理）记账 06 记账完成 07 审核退回 08 审核驳回 09 审核拒绝';
comment on column ${iol_schema}.bdms_bms_send_coll_details.account_status is '记账状态： 00 无效 01 未提交记账 02 记账中 03 记账完成 04 记账失败 05 记账异常 06 已抹账 10 计息复核通过 11 计息复核不通过';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_number is '票据号码';
comment on column ${iol_schema}.bdms_bms_send_coll_details.remitter_name is '出票人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.remitter_account is '出票人账号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.remitter_bank_name is '出票人开户银行';
comment on column ${iol_schema}.bdms_bms_send_coll_details.remitter_bank_no is '出票人开户银行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.payee_name is '收票人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.payee_account is '收票人账号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.payee_bank_name is '收票人开户银行';
comment on column ${iol_schema}.bdms_bms_send_coll_details.payee_bank_no is '收票人开户银行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_name is '承兑人全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_account is '承兑人账号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_bank_no is '承兑人开户行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_bank_name is '承兑人开户行名称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.remit_date is '出票日期';
comment on column ${iol_schema}.bdms_bms_send_coll_details.maturity_date is '汇票到期日';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_amount is '票据金额';
comment on column ${iol_schema}.bdms_bms_send_coll_details.end_smt_flag is '不得转让标记： EM00 可再转让 EM01 不得转让';
comment on column ${iol_schema}.bdms_bms_send_coll_details.endorse_times is '背书次数';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_attr is '票据属性： 1 纸票 2 电票';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_type is '票据类型： 1 银票 2 商票';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drawee_bank_name is '付款行全称';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drawee_bank_no is '付款行行号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.drawee_address is '付款行地址';
comment on column ${iol_schema}.bdms_bms_send_coll_details.df_drwr_cdtratgsagcy is '出票人评级主体';
comment on column ${iol_schema}.bdms_bms_send_coll_details.df_drwr_cdtratgduedt is '出票人评级到期日';
comment on column ${iol_schema}.bdms_bms_send_coll_details.df_drwr_cdtratgs is '出票人信用等级';
comment on column ${iol_schema}.bdms_bms_send_coll_details.reason is '原因';
comment on column ${iol_schema}.bdms_bms_send_coll_details.draft_remark is '票面备注';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_ratg_agcy is '承兑人评级主体';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_ratg_duedt is '承兑人评级到期日';
comment on column ${iol_schema}.bdms_bms_send_coll_details.acceptor_credit_ratgs is '承兑人信用等级';
comment on column ${iol_schema}.bdms_bms_send_coll_details.accept_date is '承兑日期';
comment on column ${iol_schema}.bdms_bms_send_coll_details.reserve1 is '备注1';
comment on column ${iol_schema}.bdms_bms_send_coll_details.reserve2 is '备注2';
comment on column ${iol_schema}.bdms_bms_send_coll_details.reserve3 is '备注3';
comment on column ${iol_schema}.bdms_bms_send_coll_details.message_status is '报文状态： 01 已发送申请报文 02 已发送申请报文，收到人行确认成功 03 已发送申请报文，收到人行确认，对方已签收 04 已发送申请报文，收到人行确认，对方拒绝签收 05 已发送申请报文，收到人行确认，已发撤回报文 06 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认成功 11 已发送签收报文 12 已发送签收报文，收到人行确认成功 21 已发送申请报文，收到人行确认失败 22 已发送申请报文，收到人行确认，已发撤回报文，收到人行确认失败 23 已发送签收报文，收到人行确认失败 24 对方已撤回 25 收到人行线上清退';
comment on column ${iol_schema}.bdms_bms_send_coll_details.busi_branch_no is 'BUSI_BRANCH_NO';
comment on column ${iol_schema}.bdms_bms_send_coll_details.if_over_flag is 'IF_OVER_FLAG';
comment on column ${iol_schema}.bdms_bms_send_coll_details.top_branch_no is '总行机构号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.core_account is '核心记账账号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.paymsgsrc is '来账信息来源';
comment on column ${iol_schema}.bdms_bms_send_coll_details.trandate is '来账日期';
comment on column ${iol_schema}.bdms_bms_send_coll_details.trannumber is '来账查询流水号';
comment on column ${iol_schema}.bdms_bms_send_coll_details.account_date is '';
comment on column ${iol_schema}.bdms_bms_send_coll_details.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_bms_send_coll_details.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_bms_send_coll_details.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_bms_send_coll_details.etl_timestamp is 'ETL处理时间戳';
