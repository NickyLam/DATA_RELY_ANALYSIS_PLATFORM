/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_bp_cis_out_tb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_bp_cis_out_tb
whenever sqlerror continue none;
drop table ${iol_schema}.scps_bp_cis_out_tb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_bp_cis_out_tb(
    task_id varchar2(50) -- 任务号
    ,trans_date date -- 交易日期（yyyyMMdd）
    ,trans_time varchar2(8) -- 交易时间
    ,trans_state varchar2(10) -- 交易最终状态 E 提出借记被人行拒绝,已删除 6已维护入客户账 V 已直接入客户账 G 已止付 H 已超期 R 被拒付 提入 E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期
    ,scene_code varchar2(20) -- 业务场景码
    ,charge_id varchar2(10) -- 授权柜员号
    ,br_code varchar2(9) -- 记账机构号
    ,change_channel varchar2(1) -- 交换渠道: 1-广州结算中心、2-深圳结算中心
    ,change_no varchar2(1) -- 提入行场次属性:1-只参加一场 2-可参加两场
    ,business_type varchar2(1) -- 1-正常业务、2-退票业务
    ,voucher_code varchar2(10) -- 凭证代码,780-支票
    ,voucher_no varchar2(48) -- 凭证号码
    ,bill_date varchar2(10) -- 出票日期 格式yyyyMMdd
    ,cust_no varchar2(12) -- 客户号(本行付款人时才有)
    ,cust_name varchar2(200) -- 客户名称
    ,curr_code varchar2(3) -- 币种
    ,pay_name varchar2(200) -- 付款人名称
    ,pay_acc_no varchar2(50) -- 交易对手账号
    ,pay_bank_no varchar2(30) -- 付款行名号
    ,pay_bank_name varchar2(100) -- 付款行名称
    ,pay_addr varchar2(500) -- 付款人地址
    ,inac_flag varchar2(1) -- 内部账户标识 0非内部标识 1内部标识
    ,payee_name varchar2(120) -- 收款人名称
    ,payee_acc_no varchar2(40) -- 收款人账号
    ,payee_bank_no varchar2(80) -- 收款行行号
    ,payee_bank_name varchar2(100) -- 收款行名称
    ,payee_addr varchar2(500) -- 收款人地址
    ,amount number(20,2) -- 交易金额 例如100.00
    ,trans_amount_ch varchar2(100) -- 交易金额(大写)
    ,purpose varchar2(500) -- 用途（附言）
    ,memoce varchar2(10) -- 摘要码
    ,tally_state varchar2(1) -- 记账状态 0 未记账 1 记账成功 2 退客户账成功
    ,submit_state varchar2(1) -- 业务提交状态 0-未提交，1-处理中 2-提交成功
    ,tally_send_seqno varchar2(35) -- 记账报文流水号
    ,tally_host_seqno varchar2(32) -- 记账核心交易流水
    ,tally_host_date date -- 记账核心交易日期
    ,pay_send_seqno varchar2(20) -- 支付报文流水号
    ,pay_send_date date -- 支付报文交易日期
    ,pay_host_seqno varchar2(32) -- 支付主机流水号
    ,pay_host_date date -- 支付主机交易日期
    ,pay_business_no varchar2(16) -- 支付业务序号
    ,drawee_info_send_result varchar2(1000) -- 收款人信息处理结果 处理结果描述
    ,drawee_info_send_time varchar2(20) -- 收款人信息处理时间  格式为yyyy-MM-dd
    ,drawee_info_send_flag varchar2(1) -- 收款人信息处理标志 0-未处理 1-处理中 2-处理成功
    ,ticket_count varchar2(10) -- 票据张数
    ,endorser_num varchar2(10) -- 背书人数
    ,endorsers varchar2(4000) -- 背书清单，背书人之间使用分号;分隔
    ,pay_date varchar2(8) -- 提示付款日期 格式yyyyMMdd
    ,pay_password varchar2(2000) -- 支付密码
    ,trade_date varchar2(20) -- 交换日期
    ,micr varchar2(10) -- 磁码交易码
    ,out_bk_no varchar2(30) -- 提出行行号
    ,out_bk_name varchar2(100) -- 提出行名称
    ,in_bk_no varchar2(30) -- 提入行行号
    ,in_bk_name varchar2(100) -- 提入行名称
    ,billnd varchar2(1) -- 票据标识 0-无纸质票据业务 1-纸质票据业务
    ,trade_round varchar2(2) -- 交换场次
    ,acct_do_type varchar2(1) -- 他行退票账务处理方式 1-退回客户账 2-退回挂账科目
    ,suspend_acctacctpno varchar2(32) -- 挂账受理号
    ,start_way varchar2(1) -- 提入业务发起方式[1-导入 2-扫描]
    ,return_reason_desc varchar2(1000) -- 退票理由描述
    ,tran_br_code varchar2(12) -- 交易机构编号
    ,if_sensitive_account varchar2(1) -- 账户是否敏感-1:敏感账户、0：非敏感账户
    ,trade_bank_code varchar2(10) -- 交换行号
    ,is_special_submit varchar2(1) -- 是否特殊提交 0、空-否  1-是
    ,inacct_flag varchar2(1) -- 入账标识 0-否  1-是
    ,return_limited varchar2(8) -- 包回执期限 单位为天(工作日)
    ,trans_id varchar2(16) -- 业务场景种类编号
    ,vouch_group varchar2(32) -- 业务场景凭证组合
    ,channel varchar2(10) -- 渠道
    ,txcd varchar2(16) -- 业务种类
    ,billin_order varchar2(8) -- 提入顺序号
    ,task_create_status varchar2(2) -- 任务状态 0：待处理；1：正在处理；2：处理完成
    ,doc_id varchar2(50) -- 影像批次号
    ,glob_seq_num varchar2(33) -- 全局流水号
    ,bank_no varchar2(50) -- 银行号
    ,system_no varchar2(50) -- 系统号
    ,user_id varchar2(30) -- 柜员号
    ,acct_branch_code varchar2(9) -- 账号开户机构
    ,model_code varchar2(10) -- 影像模型
    ,busi_start_date varchar2(16) -- 影像上传时间
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
grant select on ${iol_schema}.scps_bp_cis_out_tb to ${iml_schema};
grant select on ${iol_schema}.scps_bp_cis_out_tb to ${icl_schema};
grant select on ${iol_schema}.scps_bp_cis_out_tb to ${idl_schema};
grant select on ${iol_schema}.scps_bp_cis_out_tb to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_bp_cis_out_tb is '全国提出业务表';
comment on column ${iol_schema}.scps_bp_cis_out_tb.task_id is '任务号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trans_date is '交易日期（yyyyMMdd）';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trans_time is '交易时间';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trans_state is '交易最终状态 E 提出借记被人行拒绝,已删除 6已维护入客户账 V 已直接入客户账 G 已止付 H 已超期 R 被拒付 提入 E 借记回执被人行拒绝,已删除 R 已拒绝付款 V 已付款 P 已止付 H 已超期';
comment on column ${iol_schema}.scps_bp_cis_out_tb.scene_code is '业务场景码';
comment on column ${iol_schema}.scps_bp_cis_out_tb.charge_id is '授权柜员号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.br_code is '记账机构号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.change_channel is '交换渠道: 1-广州结算中心、2-深圳结算中心';
comment on column ${iol_schema}.scps_bp_cis_out_tb.change_no is '提入行场次属性:1-只参加一场 2-可参加两场';
comment on column ${iol_schema}.scps_bp_cis_out_tb.business_type is '1-正常业务、2-退票业务';
comment on column ${iol_schema}.scps_bp_cis_out_tb.voucher_code is '凭证代码,780-支票';
comment on column ${iol_schema}.scps_bp_cis_out_tb.voucher_no is '凭证号码';
comment on column ${iol_schema}.scps_bp_cis_out_tb.bill_date is '出票日期 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_cis_out_tb.cust_no is '客户号(本行付款人时才有)';
comment on column ${iol_schema}.scps_bp_cis_out_tb.cust_name is '客户名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.curr_code is '币种';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_name is '付款人名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_acc_no is '交易对手账号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_bank_no is '付款行名号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_bank_name is '付款行名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_addr is '付款人地址';
comment on column ${iol_schema}.scps_bp_cis_out_tb.inac_flag is '内部账户标识 0非内部标识 1内部标识';
comment on column ${iol_schema}.scps_bp_cis_out_tb.payee_name is '收款人名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.payee_acc_no is '收款人账号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.payee_bank_no is '收款行行号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.payee_bank_name is '收款行名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.payee_addr is '收款人地址';
comment on column ${iol_schema}.scps_bp_cis_out_tb.amount is '交易金额 例如100.00';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trans_amount_ch is '交易金额(大写)';
comment on column ${iol_schema}.scps_bp_cis_out_tb.purpose is '用途（附言）';
comment on column ${iol_schema}.scps_bp_cis_out_tb.memoce is '摘要码';
comment on column ${iol_schema}.scps_bp_cis_out_tb.tally_state is '记账状态 0 未记账 1 记账成功 2 退客户账成功';
comment on column ${iol_schema}.scps_bp_cis_out_tb.submit_state is '业务提交状态 0-未提交，1-处理中 2-提交成功';
comment on column ${iol_schema}.scps_bp_cis_out_tb.tally_send_seqno is '记账报文流水号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.tally_host_seqno is '记账核心交易流水';
comment on column ${iol_schema}.scps_bp_cis_out_tb.tally_host_date is '记账核心交易日期';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_send_seqno is '支付报文流水号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_send_date is '支付报文交易日期';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_host_seqno is '支付主机流水号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_host_date is '支付主机交易日期';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_business_no is '支付业务序号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.drawee_info_send_result is '收款人信息处理结果 处理结果描述';
comment on column ${iol_schema}.scps_bp_cis_out_tb.drawee_info_send_time is '收款人信息处理时间  格式为yyyy-MM-dd';
comment on column ${iol_schema}.scps_bp_cis_out_tb.drawee_info_send_flag is '收款人信息处理标志 0-未处理 1-处理中 2-处理成功';
comment on column ${iol_schema}.scps_bp_cis_out_tb.ticket_count is '票据张数';
comment on column ${iol_schema}.scps_bp_cis_out_tb.endorser_num is '背书人数';
comment on column ${iol_schema}.scps_bp_cis_out_tb.endorsers is '背书清单，背书人之间使用分号;分隔';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_date is '提示付款日期 格式yyyyMMdd';
comment on column ${iol_schema}.scps_bp_cis_out_tb.pay_password is '支付密码';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trade_date is '交换日期';
comment on column ${iol_schema}.scps_bp_cis_out_tb.micr is '磁码交易码';
comment on column ${iol_schema}.scps_bp_cis_out_tb.out_bk_no is '提出行行号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.out_bk_name is '提出行名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.in_bk_no is '提入行行号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.in_bk_name is '提入行名称';
comment on column ${iol_schema}.scps_bp_cis_out_tb.billnd is '票据标识 0-无纸质票据业务 1-纸质票据业务';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trade_round is '交换场次';
comment on column ${iol_schema}.scps_bp_cis_out_tb.acct_do_type is '他行退票账务处理方式 1-退回客户账 2-退回挂账科目';
comment on column ${iol_schema}.scps_bp_cis_out_tb.suspend_acctacctpno is '挂账受理号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.start_way is '提入业务发起方式[1-导入 2-扫描]';
comment on column ${iol_schema}.scps_bp_cis_out_tb.return_reason_desc is '退票理由描述';
comment on column ${iol_schema}.scps_bp_cis_out_tb.tran_br_code is '交易机构编号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.if_sensitive_account is '账户是否敏感-1:敏感账户、0：非敏感账户';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trade_bank_code is '交换行号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.is_special_submit is '是否特殊提交 0、空-否  1-是';
comment on column ${iol_schema}.scps_bp_cis_out_tb.inacct_flag is '入账标识 0-否  1-是';
comment on column ${iol_schema}.scps_bp_cis_out_tb.return_limited is '包回执期限 单位为天(工作日)';
comment on column ${iol_schema}.scps_bp_cis_out_tb.trans_id is '业务场景种类编号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.vouch_group is '业务场景凭证组合';
comment on column ${iol_schema}.scps_bp_cis_out_tb.channel is '渠道';
comment on column ${iol_schema}.scps_bp_cis_out_tb.txcd is '业务种类';
comment on column ${iol_schema}.scps_bp_cis_out_tb.billin_order is '提入顺序号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.task_create_status is '任务状态 0：待处理；1：正在处理；2：处理完成';
comment on column ${iol_schema}.scps_bp_cis_out_tb.doc_id is '影像批次号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.bank_no is '银行号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.system_no is '系统号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.user_id is '柜员号';
comment on column ${iol_schema}.scps_bp_cis_out_tb.acct_branch_code is '账号开户机构';
comment on column ${iol_schema}.scps_bp_cis_out_tb.model_code is '影像模型';
comment on column ${iol_schema}.scps_bp_cis_out_tb.busi_start_date is '影像上传时间';
comment on column ${iol_schema}.scps_bp_cis_out_tb.start_dt is '开始时间';
comment on column ${iol_schema}.scps_bp_cis_out_tb.end_dt is '结束时间';
comment on column ${iol_schema}.scps_bp_cis_out_tb.id_mark is '增删标志';
comment on column ${iol_schema}.scps_bp_cis_out_tb.etl_timestamp is 'ETL处理时间戳';
