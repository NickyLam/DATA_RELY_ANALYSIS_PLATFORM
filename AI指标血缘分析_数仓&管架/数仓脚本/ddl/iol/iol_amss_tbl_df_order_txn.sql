/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_tbl_df_order_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_tbl_df_order_txn
whenever sqlerror continue none;
drop table ${iol_schema}.amss_tbl_df_order_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_tbl_df_order_txn(
    key_rsp varchar2(32) -- 流水号
    ,tran_date varchar2(8) -- 交易日期
    ,tran_time varchar2(6) -- 交易时间
    ,tran_channel varchar2(32) -- 渠道号
    ,txn_num varchar2(32) -- 交易码:1001 单笔代付 1002 批量代付
    ,access_type varchar2(5) -- 接入类型
    ,txn_sta varchar2(2) -- 交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中
    ,trade_money number(15,2) -- 交易金额
    ,sum_count varchar2(5) -- 总笔数
    ,batch_no varchar2(6) -- 批次号
    ,file_name varchar2(50) -- 文件名
    ,up_file_name varchar2(50) -- 上传中台文件名
    ,succee_trade_money varchar2(16) -- 成功交易金额
    ,succee_count varchar2(5) -- 成功交易笔数
    ,fail_trade_money varchar2(16) -- 失败交易金额
    ,fail_count varchar2(5) -- 失败交易笔数
    ,out_order_no varchar2(32) -- 渠道订单号
    ,res_code varchar2(15) -- 响应码 0000：交易成功0001：交易失败
    ,res_desc varchar2(1024) -- 响应码描述
    ,mcht_no varchar2(100) -- 商户号
    ,accounttype varchar2(1) -- 支付账号类型 0:内部账号 1一类账号 2二类账号
    ,accountnumber varchar2(60) -- 支付账户
    ,accountname varchar2(60) -- 支付账户户名
    ,channel_acct_no varchar2(60) -- 内部户账号
    ,channel_acct_name varchar2(120) -- 内部户账号名称
    ,cny varchar2(10) -- 币种：默认值’人民币：156’
    ,bank_account_no varchar2(30) -- 银行账号（收款）
    ,bank_account_name varchar2(210) -- 账号名称（收款）
    ,bank_account_type varchar2(32) -- 账户类型（收款）
    ,bank_belong_type varchar2(1) -- 银行归属（收款）
    ,bank_account_lineno varchar2(20) -- 收款银行联行号（收款）
    ,bank_name varchar2(512) -- 收款银行名称（收款）
    ,cert_type_id varchar2(20) -- 证件类型
    ,cert_no varchar2(60) -- 证件号码
    ,cert_grantorg varchar2(20) -- 证件授权机构
    ,phone varchar2(18) -- 手机号
    ,public_note varchar2(512) -- 附言
    ,tran_seq_no_ih varchar2(64) -- 全局流水号
    ,host_key_ih varchar2(64) -- 核心流水号
    ,tran_seq_no_up varchar2(64) -- 银联商户订单号
    ,host_key_up varchar2(64) -- 银联核心流水号(保留)
    ,tran_seq_no_ihc varchar2(64) -- 业务全局流水号
    ,host_key_ihc varchar2(64) -- 冲正核心流水号(保留)
    ,checking_date varchar2(14) -- 检查时间
    ,trace_no varchar2(64) -- 银联交易流水号
    ,settle_date varchar2(8) -- 银联清算日期
    ,trace_time varchar2(14) -- 银联交易时间
    ,mercht_flag varchar2(10) -- 商户代付标识
    ,notice_thread_id varchar2(15) -- 服务器ip
    ,bak_req varchar2(512) -- 请求保留域
    ,bak_rsp varchar2(512) -- 返回保留域
    ,bacth_sta varchar2(2) -- 批次登记状态 00新建 01登记成功
    ,product_categories varchar2(1) -- 产品种类，0：智慧校园，1：全渠道代付，2：基金产品
    ,agent_no varchar2(32) -- 代理商号
    ,agree_unit_no varchar2(32) -- 协议单位编号
    ,agree_unit_name varchar2(512) -- 协议单位名称
    ,api_id varchar2(32) -- Api系统标识
    ,notify_url varchar2(125) -- 异步通知地址
    ,opr_id varchar2(32) -- 柜员编号
    ,current_sta varchar2(4) -- 当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算
    ,df_file_path varchar2(1024) -- 代扣文件上传路径
    ,settle_file_path varchar2(1024) -- PPP回盘文件
    ,settle_no varchar2(512) -- 结清批次编号
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
grant select on ${iol_schema}.amss_tbl_df_order_txn to ${iml_schema};
grant select on ${iol_schema}.amss_tbl_df_order_txn to ${icl_schema};
grant select on ${iol_schema}.amss_tbl_df_order_txn to ${idl_schema};
grant select on ${iol_schema}.amss_tbl_df_order_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_tbl_df_order_txn is '代付订单信息登记表';
comment on column ${iol_schema}.amss_tbl_df_order_txn.key_rsp is '流水号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_date is '交易日期';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_time is '交易时间';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_channel is '渠道号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.txn_num is '交易码:1001 单笔代付 1002 批量代付';
comment on column ${iol_schema}.amss_tbl_df_order_txn.access_type is '接入类型';
comment on column ${iol_schema}.amss_tbl_df_order_txn.txn_sta is '交易状态01：新建,02：支付成功,03：支付失败,04：交易超时,05：已冲正,00：订单已受理，正在处理中';
comment on column ${iol_schema}.amss_tbl_df_order_txn.trade_money is '交易金额';
comment on column ${iol_schema}.amss_tbl_df_order_txn.sum_count is '总笔数';
comment on column ${iol_schema}.amss_tbl_df_order_txn.batch_no is '批次号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.file_name is '文件名';
comment on column ${iol_schema}.amss_tbl_df_order_txn.up_file_name is '上传中台文件名';
comment on column ${iol_schema}.amss_tbl_df_order_txn.succee_trade_money is '成功交易金额';
comment on column ${iol_schema}.amss_tbl_df_order_txn.succee_count is '成功交易笔数';
comment on column ${iol_schema}.amss_tbl_df_order_txn.fail_trade_money is '失败交易金额';
comment on column ${iol_schema}.amss_tbl_df_order_txn.fail_count is '失败交易笔数';
comment on column ${iol_schema}.amss_tbl_df_order_txn.out_order_no is '渠道订单号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.res_code is '响应码 0000：交易成功0001：交易失败';
comment on column ${iol_schema}.amss_tbl_df_order_txn.res_desc is '响应码描述';
comment on column ${iol_schema}.amss_tbl_df_order_txn.mcht_no is '商户号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.accounttype is '支付账号类型 0:内部账号 1一类账号 2二类账号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.accountnumber is '支付账户';
comment on column ${iol_schema}.amss_tbl_df_order_txn.accountname is '支付账户户名';
comment on column ${iol_schema}.amss_tbl_df_order_txn.channel_acct_no is '内部户账号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.channel_acct_name is '内部户账号名称';
comment on column ${iol_schema}.amss_tbl_df_order_txn.cny is '币种：默认值’人民币：156’';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_account_no is '银行账号（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_account_name is '账号名称（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_account_type is '账户类型（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_belong_type is '银行归属（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_account_lineno is '收款银行联行号（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bank_name is '收款银行名称（收款）';
comment on column ${iol_schema}.amss_tbl_df_order_txn.cert_type_id is '证件类型';
comment on column ${iol_schema}.amss_tbl_df_order_txn.cert_no is '证件号码';
comment on column ${iol_schema}.amss_tbl_df_order_txn.cert_grantorg is '证件授权机构';
comment on column ${iol_schema}.amss_tbl_df_order_txn.phone is '手机号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.public_note is '附言';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_seq_no_ih is '全局流水号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.host_key_ih is '核心流水号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_seq_no_up is '银联商户订单号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.host_key_up is '银联核心流水号(保留)';
comment on column ${iol_schema}.amss_tbl_df_order_txn.tran_seq_no_ihc is '业务全局流水号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.host_key_ihc is '冲正核心流水号(保留)';
comment on column ${iol_schema}.amss_tbl_df_order_txn.checking_date is '检查时间';
comment on column ${iol_schema}.amss_tbl_df_order_txn.trace_no is '银联交易流水号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.settle_date is '银联清算日期';
comment on column ${iol_schema}.amss_tbl_df_order_txn.trace_time is '银联交易时间';
comment on column ${iol_schema}.amss_tbl_df_order_txn.mercht_flag is '商户代付标识';
comment on column ${iol_schema}.amss_tbl_df_order_txn.notice_thread_id is '服务器ip';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bak_req is '请求保留域';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bak_rsp is '返回保留域';
comment on column ${iol_schema}.amss_tbl_df_order_txn.bacth_sta is '批次登记状态 00新建 01登记成功';
comment on column ${iol_schema}.amss_tbl_df_order_txn.product_categories is '产品种类，0：智慧校园，1：全渠道代付，2：基金产品';
comment on column ${iol_schema}.amss_tbl_df_order_txn.agent_no is '代理商号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.agree_unit_no is '协议单位编号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.agree_unit_name is '协议单位名称';
comment on column ${iol_schema}.amss_tbl_df_order_txn.api_id is 'Api系统标识';
comment on column ${iol_schema}.amss_tbl_df_order_txn.notify_url is '异步通知地址';
comment on column ${iol_schema}.amss_tbl_df_order_txn.opr_id is '柜员编号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.current_sta is '当前状态：1-新建 2-代扣信息入库 3-发起代扣中 4-已发起代扣 5-回盘中 6-已回盘 7-已清算';
comment on column ${iol_schema}.amss_tbl_df_order_txn.df_file_path is '代扣文件上传路径';
comment on column ${iol_schema}.amss_tbl_df_order_txn.settle_file_path is 'PPP回盘文件';
comment on column ${iol_schema}.amss_tbl_df_order_txn.settle_no is '结清批次编号';
comment on column ${iol_schema}.amss_tbl_df_order_txn.start_dt is '开始时间';
comment on column ${iol_schema}.amss_tbl_df_order_txn.end_dt is '结束时间';
comment on column ${iol_schema}.amss_tbl_df_order_txn.id_mark is '增删标志';
comment on column ${iol_schema}.amss_tbl_df_order_txn.etl_timestamp is 'ETL处理时间戳';
