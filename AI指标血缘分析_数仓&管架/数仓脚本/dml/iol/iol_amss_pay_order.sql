/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_pay_order
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.amss_pay_order_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_pay_order
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_pay_order_op purge;
drop table ${iol_schema}.amss_pay_order_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_pay_order_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_pay_order where 0=1;

create table ${iol_schema}.amss_pay_order_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_pay_order where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_pay_order_cl(
            order_no -- 订单号
            ,mch_id -- 商户ID.商户自增ID
            ,mch_no -- 商户编号.商户编号
            ,mch_name -- 商户名称
            ,out_trade_no -- 商户订单号
            ,money -- 交易金额
            ,refund_money -- 退款金额
            ,trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
            ,add_time -- 添加时间
            ,trade_time -- 交易时间
            ,total_fee -- 支付金额
            ,transaction_id -- 第三方订单号
            ,trade_type -- 支付类型
            ,trade_name -- 支付类型名称
            ,notify_state -- 通知状态
            ,notify_time -- 成功通知时间
            ,charset -- 消息编码
            ,sign_type -- 签名类型
            ,update_version -- 版本号
            ,center_id -- 支付中心id
            ,decrypt_key -- 旧版本通信key
            ,notify_url -- 通知url
            ,fee_type -- 收款币种
            ,cash_fee_type -- 现金支付币种
            ,cash_fee -- 现金支付金额
            ,termtype -- 终端类型
            ,termno -- 终端编号
            ,shopno -- 操作门店编号
            ,groupno -- 商户组编号
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,operno -- 操作员编号
            ,deparno -- 门店部门编号
            ,body -- 产品名称
            ,bank_type -- 付款银行
            ,attach -- 商户附加信息
            ,device_info -- 设备信息
            ,appid -- 受理商户APPID
            ,partner -- 支付接口商户号
            ,openid -- 受理商户OPENID
            ,is_subscribe -- 是否关注受理商户
            ,coupon_fee -- 优惠券金额
            ,mch_create_ip -- 商户服务器的IP
            ,pay_create_ip -- 支付服务器的IP
            ,return_url -- 回调URL
            ,sub_partner -- 子支付接口商户号
            ,sub_appid -- 子商户APPID
            ,sub_openid -- 子商户OPENID
            ,sub_is_subscribe -- 子商户是否关注
            ,agentid -- 渠道编号
            ,data_sign -- DATA_SIGN
            ,modify_time -- MODIFY_TIME
            ,fld_s1 -- FLD_S2
            ,fld_s2 -- 
            ,fld_n1 -- FLD_D1
            ,fld_n2 -- FLD_N2
            ,fld_d1 -- 
            ,client_type -- CLIENT_TYPE
            ,sign_agentno -- SIGN_AGENTNO
            ,client_ip -- CLIENT_IP
            ,used_groupno -- USED_GROUPNO
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,acc_way_period -- 结算周期
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 快捷支付流水号
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_pay_order_op(
            order_no -- 订单号
            ,mch_id -- 商户ID.商户自增ID
            ,mch_no -- 商户编号.商户编号
            ,mch_name -- 商户名称
            ,out_trade_no -- 商户订单号
            ,money -- 交易金额
            ,refund_money -- 退款金额
            ,trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
            ,add_time -- 添加时间
            ,trade_time -- 交易时间
            ,total_fee -- 支付金额
            ,transaction_id -- 第三方订单号
            ,trade_type -- 支付类型
            ,trade_name -- 支付类型名称
            ,notify_state -- 通知状态
            ,notify_time -- 成功通知时间
            ,charset -- 消息编码
            ,sign_type -- 签名类型
            ,update_version -- 版本号
            ,center_id -- 支付中心id
            ,decrypt_key -- 旧版本通信key
            ,notify_url -- 通知url
            ,fee_type -- 收款币种
            ,cash_fee_type -- 现金支付币种
            ,cash_fee -- 现金支付金额
            ,termtype -- 终端类型
            ,termno -- 终端编号
            ,shopno -- 操作门店编号
            ,groupno -- 商户组编号
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,operno -- 操作员编号
            ,deparno -- 门店部门编号
            ,body -- 产品名称
            ,bank_type -- 付款银行
            ,attach -- 商户附加信息
            ,device_info -- 设备信息
            ,appid -- 受理商户APPID
            ,partner -- 支付接口商户号
            ,openid -- 受理商户OPENID
            ,is_subscribe -- 是否关注受理商户
            ,coupon_fee -- 优惠券金额
            ,mch_create_ip -- 商户服务器的IP
            ,pay_create_ip -- 支付服务器的IP
            ,return_url -- 回调URL
            ,sub_partner -- 子支付接口商户号
            ,sub_appid -- 子商户APPID
            ,sub_openid -- 子商户OPENID
            ,sub_is_subscribe -- 子商户是否关注
            ,agentid -- 渠道编号
            ,data_sign -- DATA_SIGN
            ,modify_time -- MODIFY_TIME
            ,fld_s1 -- FLD_S2
            ,fld_s2 -- 
            ,fld_n1 -- FLD_D1
            ,fld_n2 -- FLD_N2
            ,fld_d1 -- 
            ,client_type -- CLIENT_TYPE
            ,sign_agentno -- SIGN_AGENTNO
            ,client_ip -- CLIENT_IP
            ,used_groupno -- USED_GROUPNO
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,acc_way_period -- 结算周期
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 快捷支付流水号
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.order_no, o.order_no) as order_no -- 订单号
    ,nvl(n.mch_id, o.mch_id) as mch_id -- 商户ID.商户自增ID
    ,nvl(n.mch_no, o.mch_no) as mch_no -- 商户编号.商户编号
    ,nvl(n.mch_name, o.mch_name) as mch_name -- 商户名称
    ,nvl(n.out_trade_no, o.out_trade_no) as out_trade_no -- 商户订单号
    ,nvl(n.money, o.money) as money -- 交易金额
    ,nvl(n.refund_money, o.refund_money) as refund_money -- 退款金额
    ,nvl(n.trade_state, o.trade_state) as trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
    ,nvl(n.add_time, o.add_time) as add_time -- 添加时间
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,nvl(n.total_fee, o.total_fee) as total_fee -- 支付金额
    ,nvl(n.transaction_id, o.transaction_id) as transaction_id -- 第三方订单号
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 支付类型
    ,nvl(n.trade_name, o.trade_name) as trade_name -- 支付类型名称
    ,nvl(n.notify_state, o.notify_state) as notify_state -- 通知状态
    ,nvl(n.notify_time, o.notify_time) as notify_time -- 成功通知时间
    ,nvl(n.charset, o.charset) as charset -- 消息编码
    ,nvl(n.sign_type, o.sign_type) as sign_type -- 签名类型
    ,nvl(n.update_version, o.update_version) as update_version -- 版本号
    ,nvl(n.center_id, o.center_id) as center_id -- 支付中心id
    ,nvl(n.decrypt_key, o.decrypt_key) as decrypt_key -- 旧版本通信key
    ,nvl(n.notify_url, o.notify_url) as notify_url -- 通知url
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 收款币种
    ,nvl(n.cash_fee_type, o.cash_fee_type) as cash_fee_type -- 现金支付币种
    ,nvl(n.cash_fee, o.cash_fee) as cash_fee -- 现金支付金额
    ,nvl(n.termtype, o.termtype) as termtype -- 终端类型
    ,nvl(n.termno, o.termno) as termno -- 终端编号
    ,nvl(n.shopno, o.shopno) as shopno -- 操作门店编号
    ,nvl(n.groupno, o.groupno) as groupno -- 商户组编号
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编码
    ,nvl(n.agentno, o.agentno) as agentno -- 代理商编号
    ,nvl(n.operno, o.operno) as operno -- 操作员编号
    ,nvl(n.deparno, o.deparno) as deparno -- 门店部门编号
    ,nvl(n.body, o.body) as body -- 产品名称
    ,nvl(n.bank_type, o.bank_type) as bank_type -- 付款银行
    ,nvl(n.attach, o.attach) as attach -- 商户附加信息
    ,nvl(n.device_info, o.device_info) as device_info -- 设备信息
    ,nvl(n.appid, o.appid) as appid -- 受理商户APPID
    ,nvl(n.partner, o.partner) as partner -- 支付接口商户号
    ,nvl(n.openid, o.openid) as openid -- 受理商户OPENID
    ,nvl(n.is_subscribe, o.is_subscribe) as is_subscribe -- 是否关注受理商户
    ,nvl(n.coupon_fee, o.coupon_fee) as coupon_fee -- 优惠券金额
    ,nvl(n.mch_create_ip, o.mch_create_ip) as mch_create_ip -- 商户服务器的IP
    ,nvl(n.pay_create_ip, o.pay_create_ip) as pay_create_ip -- 支付服务器的IP
    ,nvl(n.return_url, o.return_url) as return_url -- 回调URL
    ,nvl(n.sub_partner, o.sub_partner) as sub_partner -- 子支付接口商户号
    ,nvl(n.sub_appid, o.sub_appid) as sub_appid -- 子商户APPID
    ,nvl(n.sub_openid, o.sub_openid) as sub_openid -- 子商户OPENID
    ,nvl(n.sub_is_subscribe, o.sub_is_subscribe) as sub_is_subscribe -- 子商户是否关注
    ,nvl(n.agentid, o.agentid) as agentid -- 渠道编号
    ,nvl(n.data_sign, o.data_sign) as data_sign -- DATA_SIGN
    ,nvl(n.modify_time, o.modify_time) as modify_time -- MODIFY_TIME
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- FLD_S2
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 
    ,nvl(n.fld_n1, o.fld_n1) as fld_n1 -- FLD_D1
    ,nvl(n.fld_n2, o.fld_n2) as fld_n2 -- FLD_N2
    ,nvl(n.fld_d1, o.fld_d1) as fld_d1 -- 
    ,nvl(n.client_type, o.client_type) as client_type -- CLIENT_TYPE
    ,nvl(n.sign_agentno, o.sign_agentno) as sign_agentno -- SIGN_AGENTNO
    ,nvl(n.client_ip, o.client_ip) as client_ip -- CLIENT_IP
    ,nvl(n.used_groupno, o.used_groupno) as used_groupno -- USED_GROUPNO
    ,nvl(n.mch_discount_amount, o.mch_discount_amount) as mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,nvl(n.plat_discount_amount, o.plat_discount_amount) as plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_rate_type, o.mch_rate_type) as mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,nvl(n.mch_rate, o.mch_rate) as mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,nvl(n.cost_rate, o.cost_rate) as cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,nvl(n.mch_theory_procedure_fee, o.mch_theory_procedure_fee) as mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_real_procedure_fee, o.mch_real_procedure_fee) as mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_discount_fee, o.mch_discount_fee) as mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,nvl(n.debit_card_brokerage_limit, o.debit_card_brokerage_limit) as debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.calc_state, o.calc_state) as calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
    ,nvl(n.api_provider, o.api_provider) as api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,nvl(n.acc_way_period, o.acc_way_period) as acc_way_period -- 结算周期
    ,nvl(n.pay_center_id, o.pay_center_id) as pay_center_id -- 支付通道ID，对应通道表主键
    ,nvl(n.quick_serial_no, o.quick_serial_no) as quick_serial_no -- 快捷支付流水号
    ,nvl(n.acct_dt, o.acct_dt) as acct_dt -- 会计日，格式20240808
    ,case when
            n.order_no is null
            and n.trade_time is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.order_no is null
            and n.trade_time is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.order_no is null
            and n.trade_time is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_pay_order_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_pay_order where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.order_no = n.order_no
            and o.trade_time = n.trade_time
where (
        o.order_no is null
        and o.trade_time is null
    )
    or (
        n.order_no is null
        and n.trade_time is null
    )
    or (
        o.mch_id <> n.mch_id
        or o.mch_no <> n.mch_no
        or o.mch_name <> n.mch_name
        or o.out_trade_no <> n.out_trade_no
        or o.money <> n.money
        or o.refund_money <> n.refund_money
        or o.trade_state <> n.trade_state
        or o.add_time <> n.add_time
        or o.total_fee <> n.total_fee
        or o.transaction_id <> n.transaction_id
        or o.trade_type <> n.trade_type
        or o.trade_name <> n.trade_name
        or o.notify_state <> n.notify_state
        or o.notify_time <> n.notify_time
        or o.charset <> n.charset
        or o.sign_type <> n.sign_type
        or o.update_version <> n.update_version
        or o.center_id <> n.center_id
        or o.decrypt_key <> n.decrypt_key
        or o.notify_url <> n.notify_url
        or o.fee_type <> n.fee_type
        or o.cash_fee_type <> n.cash_fee_type
        or o.cash_fee <> n.cash_fee
        or o.termtype <> n.termtype
        or o.termno <> n.termno
        or o.shopno <> n.shopno
        or o.groupno <> n.groupno
        or o.bank_no <> n.bank_no
        or o.agentno <> n.agentno
        or o.operno <> n.operno
        or o.deparno <> n.deparno
        or o.body <> n.body
        or o.bank_type <> n.bank_type
        or o.attach <> n.attach
        or o.device_info <> n.device_info
        or o.appid <> n.appid
        or o.partner <> n.partner
        or o.openid <> n.openid
        or o.is_subscribe <> n.is_subscribe
        or o.coupon_fee <> n.coupon_fee
        or o.mch_create_ip <> n.mch_create_ip
        or o.pay_create_ip <> n.pay_create_ip
        or o.return_url <> n.return_url
        or o.sub_partner <> n.sub_partner
        or o.sub_appid <> n.sub_appid
        or o.sub_openid <> n.sub_openid
        or o.sub_is_subscribe <> n.sub_is_subscribe
        or o.agentid <> n.agentid
        or o.data_sign <> n.data_sign
        or o.modify_time <> n.modify_time
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_n1 <> n.fld_n1
        or o.fld_n2 <> n.fld_n2
        or o.fld_d1 <> n.fld_d1
        or o.client_type <> n.client_type
        or o.sign_agentno <> n.sign_agentno
        or o.client_ip <> n.client_ip
        or o.used_groupno <> n.used_groupno
        or o.mch_discount_amount <> n.mch_discount_amount
        or o.plat_discount_amount <> n.plat_discount_amount
        or o.mch_rate_type <> n.mch_rate_type
        or o.mch_rate <> n.mch_rate
        or o.cost_rate <> n.cost_rate
        or o.mch_theory_procedure_fee <> n.mch_theory_procedure_fee
        or o.mch_real_procedure_fee <> n.mch_real_procedure_fee
        or o.mch_discount_fee <> n.mch_discount_fee
        or o.debit_card_brokerage_limit <> n.debit_card_brokerage_limit
        or o.calc_state <> n.calc_state
        or o.api_provider <> n.api_provider
        or o.acc_way_period <> n.acc_way_period
        or o.pay_center_id <> n.pay_center_id
        or o.quick_serial_no <> n.quick_serial_no
        or o.acct_dt <> n.acct_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_pay_order_cl(
            order_no -- 订单号
            ,mch_id -- 商户ID.商户自增ID
            ,mch_no -- 商户编号.商户编号
            ,mch_name -- 商户名称
            ,out_trade_no -- 商户订单号
            ,money -- 交易金额
            ,refund_money -- 退款金额
            ,trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
            ,add_time -- 添加时间
            ,trade_time -- 交易时间
            ,total_fee -- 支付金额
            ,transaction_id -- 第三方订单号
            ,trade_type -- 支付类型
            ,trade_name -- 支付类型名称
            ,notify_state -- 通知状态
            ,notify_time -- 成功通知时间
            ,charset -- 消息编码
            ,sign_type -- 签名类型
            ,update_version -- 版本号
            ,center_id -- 支付中心id
            ,decrypt_key -- 旧版本通信key
            ,notify_url -- 通知url
            ,fee_type -- 收款币种
            ,cash_fee_type -- 现金支付币种
            ,cash_fee -- 现金支付金额
            ,termtype -- 终端类型
            ,termno -- 终端编号
            ,shopno -- 操作门店编号
            ,groupno -- 商户组编号
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,operno -- 操作员编号
            ,deparno -- 门店部门编号
            ,body -- 产品名称
            ,bank_type -- 付款银行
            ,attach -- 商户附加信息
            ,device_info -- 设备信息
            ,appid -- 受理商户APPID
            ,partner -- 支付接口商户号
            ,openid -- 受理商户OPENID
            ,is_subscribe -- 是否关注受理商户
            ,coupon_fee -- 优惠券金额
            ,mch_create_ip -- 商户服务器的IP
            ,pay_create_ip -- 支付服务器的IP
            ,return_url -- 回调URL
            ,sub_partner -- 子支付接口商户号
            ,sub_appid -- 子商户APPID
            ,sub_openid -- 子商户OPENID
            ,sub_is_subscribe -- 子商户是否关注
            ,agentid -- 渠道编号
            ,data_sign -- DATA_SIGN
            ,modify_time -- MODIFY_TIME
            ,fld_s1 -- FLD_S2
            ,fld_s2 -- 
            ,fld_n1 -- FLD_D1
            ,fld_n2 -- FLD_N2
            ,fld_d1 -- 
            ,client_type -- CLIENT_TYPE
            ,sign_agentno -- SIGN_AGENTNO
            ,client_ip -- CLIENT_IP
            ,used_groupno -- USED_GROUPNO
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,acc_way_period -- 结算周期
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 快捷支付流水号
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_pay_order_op(
            order_no -- 订单号
            ,mch_id -- 商户ID.商户自增ID
            ,mch_no -- 商户编号.商户编号
            ,mch_name -- 商户名称
            ,out_trade_no -- 商户订单号
            ,money -- 交易金额
            ,refund_money -- 退款金额
            ,trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
            ,add_time -- 添加时间
            ,trade_time -- 交易时间
            ,total_fee -- 支付金额
            ,transaction_id -- 第三方订单号
            ,trade_type -- 支付类型
            ,trade_name -- 支付类型名称
            ,notify_state -- 通知状态
            ,notify_time -- 成功通知时间
            ,charset -- 消息编码
            ,sign_type -- 签名类型
            ,update_version -- 版本号
            ,center_id -- 支付中心id
            ,decrypt_key -- 旧版本通信key
            ,notify_url -- 通知url
            ,fee_type -- 收款币种
            ,cash_fee_type -- 现金支付币种
            ,cash_fee -- 现金支付金额
            ,termtype -- 终端类型
            ,termno -- 终端编号
            ,shopno -- 操作门店编号
            ,groupno -- 商户组编号
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,operno -- 操作员编号
            ,deparno -- 门店部门编号
            ,body -- 产品名称
            ,bank_type -- 付款银行
            ,attach -- 商户附加信息
            ,device_info -- 设备信息
            ,appid -- 受理商户APPID
            ,partner -- 支付接口商户号
            ,openid -- 受理商户OPENID
            ,is_subscribe -- 是否关注受理商户
            ,coupon_fee -- 优惠券金额
            ,mch_create_ip -- 商户服务器的IP
            ,pay_create_ip -- 支付服务器的IP
            ,return_url -- 回调URL
            ,sub_partner -- 子支付接口商户号
            ,sub_appid -- 子商户APPID
            ,sub_openid -- 子商户OPENID
            ,sub_is_subscribe -- 子商户是否关注
            ,agentid -- 渠道编号
            ,data_sign -- DATA_SIGN
            ,modify_time -- MODIFY_TIME
            ,fld_s1 -- FLD_S2
            ,fld_s2 -- 
            ,fld_n1 -- FLD_D1
            ,fld_n2 -- FLD_N2
            ,fld_d1 -- 
            ,client_type -- CLIENT_TYPE
            ,sign_agentno -- SIGN_AGENTNO
            ,client_ip -- CLIENT_IP
            ,used_groupno -- USED_GROUPNO
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,acc_way_period -- 结算周期
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 快捷支付流水号
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.order_no -- 订单号
    ,o.mch_id -- 商户ID.商户自增ID
    ,o.mch_no -- 商户编号.商户编号
    ,o.mch_name -- 商户名称
    ,o.out_trade_no -- 商户订单号
    ,o.money -- 交易金额
    ,o.refund_money -- 退款金额
    ,o.trade_state -- 交易状态.1：未支付，2：支付成功，3：已关闭，4：转入退款，8：已冲正，9：已撤销
    ,o.add_time -- 添加时间
    ,o.trade_time -- 交易时间
    ,o.total_fee -- 支付金额
    ,o.transaction_id -- 第三方订单号
    ,o.trade_type -- 支付类型
    ,o.trade_name -- 支付类型名称
    ,o.notify_state -- 通知状态
    ,o.notify_time -- 成功通知时间
    ,o.charset -- 消息编码
    ,o.sign_type -- 签名类型
    ,o.update_version -- 版本号
    ,o.center_id -- 支付中心id
    ,o.decrypt_key -- 旧版本通信key
    ,o.notify_url -- 通知url
    ,o.fee_type -- 收款币种
    ,o.cash_fee_type -- 现金支付币种
    ,o.cash_fee -- 现金支付金额
    ,o.termtype -- 终端类型
    ,o.termno -- 终端编号
    ,o.shopno -- 操作门店编号
    ,o.groupno -- 商户组编号
    ,o.bank_no -- 银行编码
    ,o.agentno -- 代理商编号
    ,o.operno -- 操作员编号
    ,o.deparno -- 门店部门编号
    ,o.body -- 产品名称
    ,o.bank_type -- 付款银行
    ,o.attach -- 商户附加信息
    ,o.device_info -- 设备信息
    ,o.appid -- 受理商户APPID
    ,o.partner -- 支付接口商户号
    ,o.openid -- 受理商户OPENID
    ,o.is_subscribe -- 是否关注受理商户
    ,o.coupon_fee -- 优惠券金额
    ,o.mch_create_ip -- 商户服务器的IP
    ,o.pay_create_ip -- 支付服务器的IP
    ,o.return_url -- 回调URL
    ,o.sub_partner -- 子支付接口商户号
    ,o.sub_appid -- 子商户APPID
    ,o.sub_openid -- 子商户OPENID
    ,o.sub_is_subscribe -- 子商户是否关注
    ,o.agentid -- 渠道编号
    ,o.data_sign -- DATA_SIGN
    ,o.modify_time -- MODIFY_TIME
    ,o.fld_s1 -- FLD_S2
    ,o.fld_s2 -- 
    ,o.fld_n1 -- FLD_D1
    ,o.fld_n2 -- FLD_N2
    ,o.fld_d1 -- 
    ,o.client_type -- CLIENT_TYPE
    ,o.sign_agentno -- SIGN_AGENTNO
    ,o.client_ip -- CLIENT_IP
    ,o.used_groupno -- USED_GROUPNO
    ,o.mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,o.plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,o.mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,o.mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,o.cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,o.mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,o.mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,o.mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,o.debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,o.calc_state -- 手续费计算状态，0:初始,1.计算成功,2.计算失败(计费字段，后续拆分)
    ,o.api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,o.acc_way_period -- 结算周期
    ,o.pay_center_id -- 支付通道ID，对应通道表主键
    ,o.quick_serial_no -- 快捷支付流水号
    ,o.acct_dt -- 会计日，格式20240808
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.amss_pay_order_bk o
    left join ${iol_schema}.amss_pay_order_op n
        on
            o.order_no = n.order_no
            and o.trade_time = n.trade_time
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_pay_order_cl d
        on
            o.order_no = d.order_no
            and o.trade_time = d.trade_time
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_pay_order;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_pay_order') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_pay_order drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_pay_order add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_pay_order exchange partition p_${batch_date} with table ${iol_schema}.amss_pay_order_cl;
alter table ${iol_schema}.amss_pay_order exchange partition p_20991231 with table ${iol_schema}.amss_pay_order_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_pay_order to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_pay_order_op purge;
drop table ${iol_schema}.amss_pay_order_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_pay_order_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_pay_order',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
