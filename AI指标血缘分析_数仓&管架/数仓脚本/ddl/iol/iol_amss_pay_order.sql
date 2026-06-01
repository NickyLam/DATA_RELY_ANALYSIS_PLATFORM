/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_pay_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_pay_order
whenever sqlerror continue none;
drop table ${iol_schema}.amss_pay_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_pay_order(
    order_no varchar2(32) -- 订单号
    ,mch_id number(11,0) -- 商户ID.商户自增ID
    ,mch_no varchar2(16) -- 商户编号.商户编号
    ,mch_name varchar2(128) -- 商户名称
    ,out_trade_no varchar2(32) -- 商户订单号
    ,money number(11,0) -- 交易金额
    ,refund_money number(11,0) -- 退款金额
    ,trade_state number(11,0) -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
    ,add_time timestamp -- 添加时间
    ,trade_time timestamp -- 交易时间
    ,total_fee number(11,0) -- 支付金额
    ,transaction_id varchar2(64) -- 第三方订单号
    ,trade_type varchar2(32) -- 支付类型
    ,trade_name varchar2(64) -- 支付类型名称
    ,notify_state number(1,0) -- 通知状态
    ,notify_time timestamp -- 成功通知时间
    ,charset varchar2(6) -- 消息编码
    ,sign_type varchar2(16) -- 签名类型
    ,update_version number(11,0) -- 版本号
    ,center_id number(11,0) -- 支付中心id
    ,decrypt_key varchar2(16) -- 旧版本通信key
    ,notify_url varchar2(255) -- 通知url
    ,fee_type varchar2(10) -- 收款币种
    ,cash_fee_type varchar2(10) -- 现金支付币种
    ,cash_fee number(11,0) -- 现金支付金额
    ,termtype varchar2(32) -- 终端类型
    ,termno varchar2(32) -- 终端编号
    ,shopno varchar2(32) -- 操作门店编号
    ,groupno varchar2(32) -- 商户组编号
    ,bank_no varchar2(32) -- 银行编码
    ,agentno varchar2(32) -- 代理商编号
    ,operno varchar2(32) -- 操作员编号
    ,deparno varchar2(32) -- 门店部门编号
    ,body varchar2(128) -- 产品名称
    ,bank_type varchar2(32) -- 付款银行
    ,attach varchar2(255) -- 商户附加信息
    ,device_info varchar2(32) -- 设备信息
    ,appid varchar2(64) -- 受理商户APPID
    ,partner varchar2(32) -- 支付接口商户号
    ,openid varchar2(255) -- 受理商户OPENID
    ,is_subscribe varchar2(16) -- 是否关注受理商户
    ,coupon_fee number(11,0) -- 优惠券金额
    ,mch_create_ip varchar2(32) -- 商户服务器的IP
    ,pay_create_ip varchar2(32) -- 支付服务器的IP
    ,return_url varchar2(512) -- 回调URL
    ,sub_partner varchar2(32) -- 子支付接口商户号
    ,sub_appid varchar2(64) -- 子商户APPID
    ,sub_openid varchar2(255) -- 子商户OPENID
    ,sub_is_subscribe varchar2(16) -- 子商户是否关注
    ,agentid varchar2(32) -- 渠道编号
    ,data_sign varchar2(128) -- DATA_SIGN
    ,modify_time timestamp -- MODIFY_TIME
    ,fld_s1 varchar2(256) -- FLD_S2
    ,fld_s2 varchar2(256) -- 
    ,fld_n1 number(11,0) -- FLD_D1
    ,fld_n2 number(11,0) -- FLD_N2
    ,fld_d1 timestamp -- 
    ,client_type varchar2(32) -- CLIENT_TYPE
    ,sign_agentno varchar2(32) -- SIGN_AGENTNO
    ,client_ip varchar2(32) -- CLIENT_IP
    ,used_groupno varchar2(1) -- USED_GROUPNO
    ,mch_discount_amount number(15,2) -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,plat_discount_amount number(15,2) -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,mch_rate_type number(1,0) -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,mch_rate number(11,0) -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,cost_rate number(11,0) -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,mch_theory_procedure_fee number(15,2) -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,mch_real_procedure_fee number(15,2) -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,mch_discount_fee number(15,2) -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,debit_card_brokerage_limit number(15,2) -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,calc_state number(1,0) -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
    ,api_provider number(11,0) -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,acc_way_period number(5,0) -- 结算周期
    ,pay_center_id varchar2(32) -- 支付通道ID，对应通道表主键
    ,quick_serial_no varchar2(256) -- 快捷支付流水号
    ,acct_dt varchar2(32) -- 会计日，格式20240808
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
grant select on ${iol_schema}.amss_pay_order to ${iml_schema};
grant select on ${iol_schema}.amss_pay_order to ${icl_schema};
grant select on ${iol_schema}.amss_pay_order to ${idl_schema};
grant select on ${iol_schema}.amss_pay_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_pay_order is '订单表';
comment on column ${iol_schema}.amss_pay_order.order_no is '订单号';
comment on column ${iol_schema}.amss_pay_order.mch_id is '商户ID.商户自增ID';
comment on column ${iol_schema}.amss_pay_order.mch_no is '商户编号.商户编号';
comment on column ${iol_schema}.amss_pay_order.mch_name is '商户名称';
comment on column ${iol_schema}.amss_pay_order.out_trade_no is '商户订单号';
comment on column ${iol_schema}.amss_pay_order.money is '交易金额';
comment on column ${iol_schema}.amss_pay_order.refund_money is '退款金额';
comment on column ${iol_schema}.amss_pay_order.trade_state is '交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销';
comment on column ${iol_schema}.amss_pay_order.add_time is '添加时间';
comment on column ${iol_schema}.amss_pay_order.trade_time is '交易时间';
comment on column ${iol_schema}.amss_pay_order.total_fee is '支付金额';
comment on column ${iol_schema}.amss_pay_order.transaction_id is '第三方订单号';
comment on column ${iol_schema}.amss_pay_order.trade_type is '支付类型';
comment on column ${iol_schema}.amss_pay_order.trade_name is '支付类型名称';
comment on column ${iol_schema}.amss_pay_order.notify_state is '通知状态';
comment on column ${iol_schema}.amss_pay_order.notify_time is '成功通知时间';
comment on column ${iol_schema}.amss_pay_order.charset is '消息编码';
comment on column ${iol_schema}.amss_pay_order.sign_type is '签名类型';
comment on column ${iol_schema}.amss_pay_order.update_version is '版本号';
comment on column ${iol_schema}.amss_pay_order.center_id is '支付中心id';
comment on column ${iol_schema}.amss_pay_order.decrypt_key is '旧版本通信key';
comment on column ${iol_schema}.amss_pay_order.notify_url is '通知url';
comment on column ${iol_schema}.amss_pay_order.fee_type is '收款币种';
comment on column ${iol_schema}.amss_pay_order.cash_fee_type is '现金支付币种';
comment on column ${iol_schema}.amss_pay_order.cash_fee is '现金支付金额';
comment on column ${iol_schema}.amss_pay_order.termtype is '终端类型';
comment on column ${iol_schema}.amss_pay_order.termno is '终端编号';
comment on column ${iol_schema}.amss_pay_order.shopno is '操作门店编号';
comment on column ${iol_schema}.amss_pay_order.groupno is '商户组编号';
comment on column ${iol_schema}.amss_pay_order.bank_no is '银行编码';
comment on column ${iol_schema}.amss_pay_order.agentno is '代理商编号';
comment on column ${iol_schema}.amss_pay_order.operno is '操作员编号';
comment on column ${iol_schema}.amss_pay_order.deparno is '门店部门编号';
comment on column ${iol_schema}.amss_pay_order.body is '产品名称';
comment on column ${iol_schema}.amss_pay_order.bank_type is '付款银行';
comment on column ${iol_schema}.amss_pay_order.attach is '商户附加信息';
comment on column ${iol_schema}.amss_pay_order.device_info is '设备信息';
comment on column ${iol_schema}.amss_pay_order.appid is '受理商户APPID';
comment on column ${iol_schema}.amss_pay_order.partner is '支付接口商户号';
comment on column ${iol_schema}.amss_pay_order.openid is '受理商户OPENID';
comment on column ${iol_schema}.amss_pay_order.is_subscribe is '是否关注受理商户';
comment on column ${iol_schema}.amss_pay_order.coupon_fee is '优惠券金额';
comment on column ${iol_schema}.amss_pay_order.mch_create_ip is '商户服务器的IP';
comment on column ${iol_schema}.amss_pay_order.pay_create_ip is '支付服务器的IP';
comment on column ${iol_schema}.amss_pay_order.return_url is '回调URL';
comment on column ${iol_schema}.amss_pay_order.sub_partner is '子支付接口商户号';
comment on column ${iol_schema}.amss_pay_order.sub_appid is '子商户APPID';
comment on column ${iol_schema}.amss_pay_order.sub_openid is '子商户OPENID';
comment on column ${iol_schema}.amss_pay_order.sub_is_subscribe is '子商户是否关注';
comment on column ${iol_schema}.amss_pay_order.agentid is '渠道编号';
comment on column ${iol_schema}.amss_pay_order.data_sign is 'DATA_SIGN';
comment on column ${iol_schema}.amss_pay_order.modify_time is 'MODIFY_TIME';
comment on column ${iol_schema}.amss_pay_order.fld_s1 is 'FLD_S2';
comment on column ${iol_schema}.amss_pay_order.fld_s2 is '';
comment on column ${iol_schema}.amss_pay_order.fld_n1 is 'FLD_D1';
comment on column ${iol_schema}.amss_pay_order.fld_n2 is 'FLD_N2';
comment on column ${iol_schema}.amss_pay_order.fld_d1 is '';
comment on column ${iol_schema}.amss_pay_order.client_type is 'CLIENT_TYPE';
comment on column ${iol_schema}.amss_pay_order.sign_agentno is 'SIGN_AGENTNO';
comment on column ${iol_schema}.amss_pay_order.client_ip is 'CLIENT_IP';
comment on column ${iol_schema}.amss_pay_order.used_groupno is 'USED_GROUPNO';
comment on column ${iol_schema}.amss_pay_order.mch_discount_amount is '商家优惠金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.plat_discount_amount is '平台优惠金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.mch_rate_type is '费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.mch_rate is '商户费率，百万单位存储(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.cost_rate is '通道费率，百万单位存储(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.mch_theory_procedure_fee is '商户理论手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.mch_real_procedure_fee is '商户实际手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.mch_discount_fee is '商户手续费减免金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.debit_card_brokerage_limit is '商户封顶手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.calc_state is '手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_order.api_provider is '接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER';
comment on column ${iol_schema}.amss_pay_order.acc_way_period is '结算周期';
comment on column ${iol_schema}.amss_pay_order.pay_center_id is '支付通道ID，对应通道表主键';
comment on column ${iol_schema}.amss_pay_order.quick_serial_no is '快捷支付流水号';
comment on column ${iol_schema}.amss_pay_order.acct_dt is '会计日，格式20240808';
comment on column ${iol_schema}.amss_pay_order.start_dt is '开始时间';
comment on column ${iol_schema}.amss_pay_order.end_dt is '结束时间';
comment on column ${iol_schema}.amss_pay_order.id_mark is '增删标志';
comment on column ${iol_schema}.amss_pay_order.etl_timestamp is 'ETL处理时间戳';
