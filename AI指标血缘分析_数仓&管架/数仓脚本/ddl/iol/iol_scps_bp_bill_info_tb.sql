/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_bill_info_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_bill_info_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_bill_info_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_bill_info_tb(
    id varchar2(50) -- 唯一主键
    ,process_inst_id varchar2(50) -- 
    ,main_flow_id varchar2(50) -- 
    ,accept_no varchar2(50) -- 受理号
    ,root_accept_no varchar2(50) -- 根受理号
    ,scan_seq_no varchar2(50) -- 流水号
    ,tr_date date -- 交易日期（yyyy-MM-dd）
    ,accept_time varchar2(20) -- 受理时间(yyyy-MM-dd HH:mm:ss)
    ,user_id varchar2(8) -- 交易柜员编号
    ,charge_id varchar2(10) -- 授权柜员号
    ,br_code varchar2(9) -- 记账机构号
    ,biz_code varchar2(6) -- 业务编码(600009-同城提出借记 600010-同城提出贷记 609001-同城提入借记 609002-同城提入贷记 609021-深圳同城提入)
    ,change_channel varchar2(1) -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,change_no varchar2(1) -- 提入行场次属性:1-只参加一场 2-可参加两场（广州结算中心提出业务才有）
    ,biz_type varchar2(1) -- 1-正常业务、2-退票业务
    ,voucher_code varchar2(10) -- 凭证代码 773-银行汇票 780-支票 786-结算业务委托书 998-银行本票 999-其它
    ,voucher_no varchar2(48) -- 凭证号码
    ,bill_date varchar2(8) -- 出票日期 格式yyyyMMdd
    ,cust_no varchar2(16) -- 客户编号(本行付款人时才有)
    ,custname varchar2(128) -- 客户名称
    ,curr_code varchar2(3) -- 币种
    ,drawee_name varchar2(200) -- 交易对手名称
    ,drawee_acct_no varchar2(50) -- 交易对手账号
    ,drawee_bk_no varchar2(30) -- 付款行名号
    ,drawee_bk_name varchar2(100) -- 付款行名称
    ,drawee_addr varchar2(500) -- 付款人地址
    ,inac_flag varchar2(1) -- 内部账户标识 0非内部标识 1内部标识
    ,payee_name varchar2(200) -- 收款人名称
    ,payee_acct_no varchar2(50) -- 收款人账号
    ,payee_bk_no varchar2(30) -- 收款行行号
    ,payee_bk_name varchar2(100) -- 收款行名称
    ,payee_addr varchar2(500) -- 收款人地址
    ,trn_amt number(20,2) -- 交易金额 例如100.00
    ,purpose varchar2(500) -- 用途（附言）
    ,memocd varchar2(10) -- 摘要码
    ,tally_state varchar2(1) -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,tr_state varchar2(10) -- 交易状态 00-待复核 01-待确定 02-待清算 03-已扎差 04-已清算 05-已退票待清算 06-行内退票 07-已暂缓   08-已冲正 09-已入账 10-记账失败 11-复核通过 12-复核失败 13-发送人行失败 14-人行拒绝 15-他行退票 16-已退票   17-待重发 18-已重发 深圳同城提出票据：全票环节提交成功后，状态改为：01-待确定，后续接到推送状态转换为：     Z：初始登记  --> 11-复核通过     1：中台记账成功 --> 01-待确定     2：中台记账失败 -->  10-记账失败  （终态）     //推送以下状态     3：发送人行成功  待清算--> 02-待清算     4：发送人行失败--> 13-发送人行失败     5：人行拒绝--> 14-人行拒绝     O：已扎差--> 03-已扎差     T：已清算--> 04-已清算    （终态）     6：他行退票--> 15-他行退票     7：已冲正 （发送人行失败，人行拒绝，他行退票后已做冲账处理）-->08-已冲正 （终态） 深圳同城提回：30-扣款成功 31-扣款失败 32-退票成功 33-退票失败 34-退票发往人行成功(未收到人行确认)
    ,tr_state_msg varchar2(500) -- 交易状态消息
    ,submit_state varchar2(1) -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,tally_send_seqno varchar2(60) -- 记账报文流水号
    ,tally_host_seqno varchar2(33) -- 记账核心交易流水
    ,tally_host_date date -- 记账核心交易日期
    ,pay_send_seqno varchar2(20) -- 支付报文流水号
    ,pay_send_date date -- 支付报文交易日期
    ,pay_host_seqno varchar2(32) -- 支付主机流水号
    ,pay_host_date date -- 支付主机交易日期
    ,pay_businesstrace varchar2(16) -- 支付业务序号
    ,drawee_info_send_result varchar2(1000) -- 收款人信息处理结果 处理结果描述
    ,drawee_info_send_time varchar2(20) -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,drawee_info_send_flag varchar2(1) -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,batch_count varchar2(10) -- 批量笔数1-99
    ,batch_is_sync_ete varchar2(1) -- 批量处理是否同步受理中心0-否 1-是
    ,split_count varchar2(10) -- 拆分笔数
    ,trn_amt_ch varchar2(100) -- 交易金额(大写)
    ,ticket_count varchar2(10) -- 票据张数
    ,endorser_num varchar2(10) -- 背书人数
    ,endorsers varchar2(4000) -- 背书清单，背书人之间使用分号;分隔
    ,pay_date varchar2(8) -- 提示付款日期 格式yyyyMMdd
    ,pay_password varchar2(2000) -- 支付密码
    ,tax_bill_flag varchar2(1) -- 税票标记 0-否 1-是
    ,auto_seal_batch_no varchar2(32) -- 自动验印批次号
    ,ret_type varchar2(10) -- 退票类型 1-行内退票 2-我行退票
    ,confirm_batch_no varchar2(20) -- 提出确认批次号
    ,clear_date varchar2(8) -- 清算日期，格式为yyyyMMdd
    ,bill_seq_no varchar2(12) -- 同城提入主交易流水号
    ,acct_query_msg varchar2(1000) -- 主账户查询信息
    ,acct_br_code varchar2(9) -- 账号开户机构
    ,acct_stat varchar2(1) -- 账号状态 0-关闭 1-正常 2-账户挂失
    ,acct_amt_stat varchar2(1) -- 账号余额信息 0-余额充足 1-余额不足
    ,bill_flag varchar2(1) -- 借贷标志[D：借 C：贷]
    ,ret_scan_seq_no varchar2(50) -- 关联流水
    ,clear_change_no varchar2(1) -- 清算场次 1-9
    ,inacct_state varchar2(1) -- 收妥入账记账状态[0-未记账 1-记账成功 2 -退客户帐成功]
    ,inacct_submit_state varchar2(1) -- 收妥入账业务提交状态 0-未提交，1-处理中 2-提交成功
    ,inacct_send_seqno varchar2(33) -- 收妥入账记账报文流水号
    ,inacct_host_seqno varchar2(33) -- 收妥入账记账核心交易流水
    ,inacct_host_date date -- 收妥入账记账核心交易日期
    ,reversed_user_id varchar2(10) -- 冲正柜员号
    ,reversed_time varchar2(20) -- 冲正时间
    ,reversed_submit_state varchar2(1) -- 冲正提交状态 0-未提交，1-处理中 2-提交成功
    ,reversed_send_seqno varchar2(33) -- 冲正报文流水号
    ,reversed_host_seqno varchar2(33) -- 冲正核心交易流水
    ,reversed_host_date date -- 冲正核心交易日期
    ,reversed_reason varchar2(500) -- 冲正原因
    ,inacct_user_id varchar2(10) -- 收妥入账记账柜员
    ,out_confirm_userid varchar2(10) -- 提出确认操作柜员
    ,out_confirm_chargeid varchar2(10) -- 提出确认授权柜员
    ,out_confirm_time varchar2(20) -- 提出确认时间
    ,check_user_id varchar2(10) -- 复核柜员
    ,check_time varchar2(20) -- 复核时间(yyyy-MM-dd HH:mm:ss)
    ,reversed_charge_id varchar2(10) -- 冲正授权柜员号
    ,return_reason varchar2(4000) -- 退票理由
    ,proxy_drawee_bk_no varchar2(30) -- 代理付款行号
    ,inacct_charge_id varchar2(10) -- 收妥入账授权柜员号
    ,inacct_time varchar2(20) -- 收妥入账时间
    ,delay_inacct_user_id varchar2(10) -- 暂缓入账柜员
    ,delay_inacct_charge_id varchar2(10) -- 暂缓入账授权柜员号
    ,delay_inacct_time varchar2(20) -- 暂缓入账时间
    ,cancel_delay_user_id varchar2(10) -- 取消暂缓入账柜员
    ,cancel_delay_charge_id varchar2(10) -- 取消暂缓入账授权柜员号
    ,cancel_delay_time varchar2(20) -- 取消暂缓入账时间
    ,micr varchar2(10) -- 磁码交易码
    ,trade_date varchar2(20) -- 交换日期
    ,ref_batch_accept_no varchar2(32) -- 原批量受理号
    ,ref_batch_scan_seq_no varchar2(32) -- 原批量流水号
    ,in_bk_no varchar2(30) -- 提入行号
    ,in_bk_name varchar2(100) -- 提入行名称
    ,out_bk_no varchar2(30) -- 提出行行号
    ,out_bk_name varchar2(100) -- 提出行名称
    ,trade_round varchar2(2) -- 交换场次
    ,bill_in_order number(18,0) -- 提入顺序号
    ,txcd varchar2(10) -- 业务种类
    ,billnd varchar2(1) -- 票据标识 0 无纸质票据业务 1 纸质票据业务
    ,acct_do_type varchar2(1) -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,suspend_acct_acctpno varchar2(32) -- 挂账受理号
    ,start_way varchar2(1) -- 提入业务发起方式[1-导入 2-扫描]
    ,return_reason_desc varchar2(1000) -- 退票理由描述
    ,tran_br_code varchar2(9) -- 交易机构
    ,trade_bank_code varchar2(10) -- 交换行号
    ,if_sensitive_account varchar2(1) -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,odrtfg varchar2(1) -- 是否触发透支业务 0- 否1- 是
    ,odrtam varchar2(32) -- 透支金额
    ,is_special_submit varchar2(1) -- 是否特殊提交 0、空-否  1-是
    ,inacct_flag varchar2(1) -- 入账标识 0-否  1-是
    ,vouch_group varchar2(32) -- 业务场景凭证组合
    ,doc_id varchar2(50) -- 影像批次号
    ,model_code varchar2(10) -- 影像模型
    ,busi_start_date varchar2(16) -- 影像上传时间
    ,bank_no varchar2(50) -- 银行号
    ,system_no varchar2(50) -- 系统号
    ,trans_no varchar2(50) -- 服务码
    ,user_no varchar2(20) -- 用户号
    ,organ_no varchar2(20) -- 机构号
    ,channel varchar2(50) -- 渠道
    ,scene_code varchar2(50) -- 业务场景码
    ,trans_id varchar2(50) -- 业务场景种类编号
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,succ_total varchar2(5) -- 成功笔数
    ,total varchar2(5) -- 总笔数
    ,total_amt number(20,2) -- 总金额
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.scps_bp_bill_info_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_bill_info_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_bill_info_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_bill_info_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_bill_info_tb is '同城票交业务表';
comment on column ${iol_schema}.scps_bp_bill_info_tb.id is '唯一主键';
comment on column ${iol_schema}.scps_bp_bill_info_tb.process_inst_id is '';
comment on column ${iol_schema}.scps_bp_bill_info_tb.main_flow_id is '';
comment on column ${iol_schema}.scps_bp_bill_info_tb.accept_no is '受理号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.root_accept_no is '根受理号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.scan_seq_no is '流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tr_date is '交易日期（yyyy-MM-dd）';
comment on column ${iol_schema}.scps_bp_bill_info_tb.accept_time is '受理时间(yyyy-MM-dd HH:mm:ss)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.user_id is '交易柜员编号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.charge_id is '授权柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.br_code is '记账机构号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.biz_code is '业务编码(600009-同城提出借记 600010-同城提出贷记 609001-同城提入借记 609002-同城提入贷记 609021-深圳同城提入)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.change_channel is '交换渠道: 1-广州结算中心、2-深圳结算中心';
comment on column ${iol_schema}.scps_bp_bill_info_tb.change_no is '提入行场次属性:1-只参加一场 2-可参加两场（广州结算中心提出业务才有）';
comment on column ${iol_schema}.scps_bp_bill_info_tb.biz_type is '1-正常业务、2-退票业务';
comment on column ${iol_schema}.scps_bp_bill_info_tb.voucher_code is '凭证代码 773-银行汇票 780-支票 786-结算业务委托书 998-银行本票 999-其它';
comment on column ${iol_schema}.scps_bp_bill_info_tb.voucher_no is '凭证号码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.bill_date is '出票日期 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_bill_info_tb.cust_no is '客户编号(本行付款人时才有)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.custname is '客户名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.curr_code is '币种';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_name is '交易对手名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_acct_no is '交易对手账号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_bk_no is '付款行名号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_bk_name is '付款行名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_addr is '付款人地址';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inac_flag is '内部账户标识 0非内部标识 1内部标识';
comment on column ${iol_schema}.scps_bp_bill_info_tb.payee_name is '收款人名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.payee_acct_no is '收款人账号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.payee_bk_no is '收款行行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.payee_bk_name is '收款行名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.payee_addr is '收款人地址';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trn_amt is '交易金额 例如100.00';
comment on column ${iol_schema}.scps_bp_bill_info_tb.purpose is '用途（附言）';
comment on column ${iol_schema}.scps_bp_bill_info_tb.memocd is '摘要码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tally_state is '记账状态 0 未记账 1 记账成功 2 退客户账成功';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tr_state is '交易状态 00-待复核 01-待确定 02-待清算 03-已扎差 04-已清算 05-已退票待清算 06-行内退票 07-已暂缓   08-已冲正 09-已入账 10-记账失败 11-复核通过 12-复核失败 13-发送人行失败 14-人行拒绝 15-他行退票 16-已退票   17-待重发 18-已重发 深圳同城提出票据：全票环节提交成功后，状态改为：01-待确定，后续接到推送状态转换为：     Z：初始登记  --> 11-复核通过     1：中台记账成功 --> 01-待确定     2：中台记账失败 -->  10-记账失败  （终态）     //推送以下状态     3：发送人行成功  待清算--> 02-待清算     4：发送人行失败--> 13-发送人行失败     5：人行拒绝--> 14-人行拒绝     O：已扎差--> 03-已扎差     T：已清算--> 04-已清算    （终态）     6：他行退票--> 15-他行退票     7：已冲正 （发送人行失败，人行拒绝，他行退票后已做冲账处理）-->08-已冲正 （终态） 深圳同城提回：30-扣款成功 31-扣款失败 32-退票成功 33-退票失败 34-退票发往人行成功(未收到人行确认)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tr_state_msg is '交易状态消息';
comment on column ${iol_schema}.scps_bp_bill_info_tb.submit_state is '任务状态 0：待处理；1：正在处理；2：处理完成';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tally_send_seqno is '记账报文流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tally_host_seqno is '记账核心交易流水';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tally_host_date is '记账核心交易日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_send_seqno is '支付报文流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_send_date is '支付报文交易日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_host_seqno is '支付主机流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_host_date is '支付主机交易日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_businesstrace is '支付业务序号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_info_send_result is '收款人信息处理结果 处理结果描述';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_info_send_time is '收款人信息处理时间  格式为yyyy-MM-dd';
comment on column ${iol_schema}.scps_bp_bill_info_tb.drawee_info_send_flag is '收款人信息处理标志 0-未处理 1-处理中 2-处理成功';
comment on column ${iol_schema}.scps_bp_bill_info_tb.batch_count is '批量笔数1-99';
comment on column ${iol_schema}.scps_bp_bill_info_tb.batch_is_sync_ete is '批量处理是否同步受理中心0-否 1-是';
comment on column ${iol_schema}.scps_bp_bill_info_tb.split_count is '拆分笔数';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trn_amt_ch is '交易金额(大写)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.ticket_count is '票据张数';
comment on column ${iol_schema}.scps_bp_bill_info_tb.endorser_num is '背书人数';
comment on column ${iol_schema}.scps_bp_bill_info_tb.endorsers is '背书清单，背书人之间使用分号;分隔';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_date is '提示付款日期 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_bill_info_tb.pay_password is '支付密码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tax_bill_flag is '税票标记 0-否 1-是';
comment on column ${iol_schema}.scps_bp_bill_info_tb.auto_seal_batch_no is '自动验印批次号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.ret_type is '退票类型 1-行内退票 2-我行退票';
comment on column ${iol_schema}.scps_bp_bill_info_tb.confirm_batch_no is '提出确认批次号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.clear_date is '清算日期，格式为yyyyMMdd';
comment on column ${iol_schema}.scps_bp_bill_info_tb.bill_seq_no is '同城提入主交易流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.acct_query_msg is '主账户查询信息';
comment on column ${iol_schema}.scps_bp_bill_info_tb.acct_br_code is '账号开户机构';
comment on column ${iol_schema}.scps_bp_bill_info_tb.acct_stat is '账号状态 0-关闭 1-正常 2-账户挂失';
comment on column ${iol_schema}.scps_bp_bill_info_tb.acct_amt_stat is '账号余额信息 0-余额充足 1-余额不足';
comment on column ${iol_schema}.scps_bp_bill_info_tb.bill_flag is '借贷标志[D：借 C：贷]';
comment on column ${iol_schema}.scps_bp_bill_info_tb.ret_scan_seq_no is '关联流水';
comment on column ${iol_schema}.scps_bp_bill_info_tb.clear_change_no is '清算场次 1-9';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_state is '收妥入账记账状态[0-未记账 1-记账成功 2 -退客户帐成功]';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_submit_state is '收妥入账业务提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_send_seqno is '收妥入账记账报文流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_host_seqno is '收妥入账记账核心交易流水';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_host_date is '收妥入账记账核心交易日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_user_id is '冲正柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_time is '冲正时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_submit_state is '冲正提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_send_seqno is '冲正报文流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_host_seqno is '冲正核心交易流水';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_host_date is '冲正核心交易日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_reason is '冲正原因';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_user_id is '收妥入账记账柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.out_confirm_userid is '提出确认操作柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.out_confirm_chargeid is '提出确认授权柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.out_confirm_time is '提出确认时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.check_user_id is '复核柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.check_time is '复核时间(yyyy-MM-dd HH:mm:ss)';
comment on column ${iol_schema}.scps_bp_bill_info_tb.reversed_charge_id is '冲正授权柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.return_reason is '退票理由';
comment on column ${iol_schema}.scps_bp_bill_info_tb.proxy_drawee_bk_no is '代理付款行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_charge_id is '收妥入账授权柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_time is '收妥入账时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.delay_inacct_user_id is '暂缓入账柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.delay_inacct_charge_id is '暂缓入账授权柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.delay_inacct_time is '暂缓入账时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.cancel_delay_user_id is '取消暂缓入账柜员';
comment on column ${iol_schema}.scps_bp_bill_info_tb.cancel_delay_charge_id is '取消暂缓入账授权柜员号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.cancel_delay_time is '取消暂缓入账时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.micr is '磁码交易码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trade_date is '交换日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.ref_batch_accept_no is '原批量受理号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.ref_batch_scan_seq_no is '原批量流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.in_bk_no is '提入行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.in_bk_name is '提入行名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.out_bk_no is '提出行行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.out_bk_name is '提出行名称';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trade_round is '交换场次';
comment on column ${iol_schema}.scps_bp_bill_info_tb.bill_in_order is '提入顺序号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.txcd is '业务种类';
comment on column ${iol_schema}.scps_bp_bill_info_tb.billnd is '票据标识 0 无纸质票据业务 1 纸质票据业务';
comment on column ${iol_schema}.scps_bp_bill_info_tb.acct_do_type is '他行退票账务处理方式 1-退回客户账 2-退回挂账科目';
comment on column ${iol_schema}.scps_bp_bill_info_tb.suspend_acct_acctpno is '挂账受理号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.start_way is '提入业务发起方式[1-导入 2-扫描]';
comment on column ${iol_schema}.scps_bp_bill_info_tb.return_reason_desc is '退票理由描述';
comment on column ${iol_schema}.scps_bp_bill_info_tb.tran_br_code is '交易机构';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trade_bank_code is '交换行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.if_sensitive_account is '账户是否敏感-1:敏感账户、0：非敏感账户';
comment on column ${iol_schema}.scps_bp_bill_info_tb.odrtfg is '是否触发透支业务 0- 否1- 是';
comment on column ${iol_schema}.scps_bp_bill_info_tb.odrtam is '透支金额';
comment on column ${iol_schema}.scps_bp_bill_info_tb.is_special_submit is '是否特殊提交 0、空-否  1-是';
comment on column ${iol_schema}.scps_bp_bill_info_tb.inacct_flag is '入账标识 0-否  1-是';
comment on column ${iol_schema}.scps_bp_bill_info_tb.vouch_group is '业务场景凭证组合';
comment on column ${iol_schema}.scps_bp_bill_info_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.model_code is '影像模型';
comment on column ${iol_schema}.scps_bp_bill_info_tb.busi_start_date is '影像上传时间';
comment on column ${iol_schema}.scps_bp_bill_info_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trans_no is '服务码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.user_no is '用户号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.organ_no is '机构号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.channel is '渠道';
comment on column ${iol_schema}.scps_bp_bill_info_tb.scene_code is '业务场景码';
comment on column ${iol_schema}.scps_bp_bill_info_tb.trans_id is '业务场景种类编号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.scps_bp_bill_info_tb.succ_total is '成功笔数';
comment on column ${iol_schema}.scps_bp_bill_info_tb.total is '总笔数';
comment on column ${iol_schema}.scps_bp_bill_info_tb.total_amt is '总金额';
comment on column ${iol_schema}.scps_bp_bill_info_tb.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scps_bp_bill_info_tb.etl_timestamp is 'ETL处理时间戳';
