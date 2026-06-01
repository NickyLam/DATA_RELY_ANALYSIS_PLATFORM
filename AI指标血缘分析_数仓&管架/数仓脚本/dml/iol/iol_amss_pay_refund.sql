/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_pay_refund
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
create table ${iol_schema}.amss_pay_refund_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_pay_refund
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_pay_refund_op purge;
drop table ${iol_schema}.amss_pay_refund_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_pay_refund_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_pay_refund where 0=1;

create table ${iol_schema}.amss_pay_refund_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_pay_refund where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_pay_refund_cl(
            refund_no -- 退款单号
            ,order_no -- 订单号
            ,mch_id -- 商户ID
            ,total_fee -- 订单总额
            ,refund_fee -- 退款总额
            ,add_time -- 添加时间
            ,refund_state -- 退款状态
            ,order_state -- 订单状态
            ,trade_type -- 支付类型
            ,trade_name -- 支付名称
            ,refundid -- 第三方退款单号
            ,transaction_id -- 第三方订单号
            ,out_refund_no -- 商户退款单号
            ,out_trade_no -- 商户订单号
            ,refund_channel -- 退款渠道
            ,refund_user -- 退款用户
            ,update_version -- 版本号
            ,mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
            ,refund_time -- 退款时间
            ,refuse_reason -- 支付退款理由
            ,mch_refuse_reason -- 商户退款理由
            ,refund_source -- 退款来源
            ,mch_no -- 商户编号
            ,mch_name -- 商户名称
            ,fee_type -- 币种
            ,group_id -- 组织编号
            ,groupno -- 组织编号
            ,center_id -- 支付中心
            ,risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,risk_info -- 分控信息
            ,mch_audit_user -- 商户审核用户
            ,pt_audit_user -- 平台审核用户
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,deparno -- 门店部门编号
            ,termtype -- 终端类型.POS,SPAY,ADMIN
            ,termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,operno -- 操作员编号
            ,shopno -- 操作门店编号
            ,mch_review_time -- 商户审核时间
            ,pt_review_time -- 平台审核时间
            ,agentid -- 代理商编号
            ,group_no -- 
            ,client_ip -- 
            ,data_sign -- 
            ,modify_time -- 
            ,mdiscount -- 
            ,union_id -- 
            ,bank_type -- 
            ,openid -- 
            ,sub_openid -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,bs_discount -- 银联自定义优惠退款金额
            ,bs_discount_type -- 银联自定义优惠类型
            ,sign_agentno -- 授权机构号
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,fld_s6 -- 
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 
            ,acc_way_period -- 结算周期
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_pay_refund_op(
            refund_no -- 退款单号
            ,order_no -- 订单号
            ,mch_id -- 商户ID
            ,total_fee -- 订单总额
            ,refund_fee -- 退款总额
            ,add_time -- 添加时间
            ,refund_state -- 退款状态
            ,order_state -- 订单状态
            ,trade_type -- 支付类型
            ,trade_name -- 支付名称
            ,refundid -- 第三方退款单号
            ,transaction_id -- 第三方订单号
            ,out_refund_no -- 商户退款单号
            ,out_trade_no -- 商户订单号
            ,refund_channel -- 退款渠道
            ,refund_user -- 退款用户
            ,update_version -- 版本号
            ,mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
            ,refund_time -- 退款时间
            ,refuse_reason -- 支付退款理由
            ,mch_refuse_reason -- 商户退款理由
            ,refund_source -- 退款来源
            ,mch_no -- 商户编号
            ,mch_name -- 商户名称
            ,fee_type -- 币种
            ,group_id -- 组织编号
            ,groupno -- 组织编号
            ,center_id -- 支付中心
            ,risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,risk_info -- 分控信息
            ,mch_audit_user -- 商户审核用户
            ,pt_audit_user -- 平台审核用户
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,deparno -- 门店部门编号
            ,termtype -- 终端类型.POS,SPAY,ADMIN
            ,termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,operno -- 操作员编号
            ,shopno -- 操作门店编号
            ,mch_review_time -- 商户审核时间
            ,pt_review_time -- 平台审核时间
            ,agentid -- 代理商编号
            ,group_no -- 
            ,client_ip -- 
            ,data_sign -- 
            ,modify_time -- 
            ,mdiscount -- 
            ,union_id -- 
            ,bank_type -- 
            ,openid -- 
            ,sub_openid -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,bs_discount -- 银联自定义优惠退款金额
            ,bs_discount_type -- 银联自定义优惠类型
            ,sign_agentno -- 授权机构号
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,fld_s6 -- 
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 
            ,acc_way_period -- 结算周期
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.refund_no, o.refund_no) as refund_no -- 退款单号
    ,nvl(n.order_no, o.order_no) as order_no -- 订单号
    ,nvl(n.mch_id, o.mch_id) as mch_id -- 商户ID
    ,nvl(n.total_fee, o.total_fee) as total_fee -- 订单总额
    ,nvl(n.refund_fee, o.refund_fee) as refund_fee -- 退款总额
    ,nvl(n.add_time, o.add_time) as add_time -- 添加时间
    ,nvl(n.refund_state, o.refund_state) as refund_state -- 退款状态
    ,nvl(n.order_state, o.order_state) as order_state -- 订单状态
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 支付类型
    ,nvl(n.trade_name, o.trade_name) as trade_name -- 支付名称
    ,nvl(n.refundid, o.refundid) as refundid -- 第三方退款单号
    ,nvl(n.transaction_id, o.transaction_id) as transaction_id -- 第三方订单号
    ,nvl(n.out_refund_no, o.out_refund_no) as out_refund_no -- 商户退款单号
    ,nvl(n.out_trade_no, o.out_trade_no) as out_trade_no -- 商户订单号
    ,nvl(n.refund_channel, o.refund_channel) as refund_channel -- 退款渠道
    ,nvl(n.refund_user, o.refund_user) as refund_user -- 退款用户
    ,nvl(n.update_version, o.update_version) as update_version -- 版本号
    ,nvl(n.mch_audit, o.mch_audit) as mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
    ,nvl(n.daemon_audit, o.daemon_audit) as daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
    ,nvl(n.refund_time, o.refund_time) as refund_time -- 退款时间
    ,nvl(n.refuse_reason, o.refuse_reason) as refuse_reason -- 支付退款理由
    ,nvl(n.mch_refuse_reason, o.mch_refuse_reason) as mch_refuse_reason -- 商户退款理由
    ,nvl(n.refund_source, o.refund_source) as refund_source -- 退款来源
    ,nvl(n.mch_no, o.mch_no) as mch_no -- 商户编号
    ,nvl(n.mch_name, o.mch_name) as mch_name -- 商户名称
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 币种
    ,nvl(n.group_id, o.group_id) as group_id -- 组织编号
    ,nvl(n.groupno, o.groupno) as groupno -- 组织编号
    ,nvl(n.center_id, o.center_id) as center_id -- 支付中心
    ,nvl(n.risk_ctr, o.risk_ctr) as risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
    ,nvl(n.risk_info, o.risk_info) as risk_info -- 分控信息
    ,nvl(n.mch_audit_user, o.mch_audit_user) as mch_audit_user -- 商户审核用户
    ,nvl(n.pt_audit_user, o.pt_audit_user) as pt_audit_user -- 平台审核用户
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行编码
    ,nvl(n.agentno, o.agentno) as agentno -- 代理商编号
    ,nvl(n.deparno, o.deparno) as deparno -- 门店部门编号
    ,nvl(n.termtype, o.termtype) as termtype -- 终端类型.POS,SPAY,ADMIN
    ,nvl(n.termno, o.termno) as termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
    ,nvl(n.operno, o.operno) as operno -- 操作员编号
    ,nvl(n.shopno, o.shopno) as shopno -- 操作门店编号
    ,nvl(n.mch_review_time, o.mch_review_time) as mch_review_time -- 商户审核时间
    ,nvl(n.pt_review_time, o.pt_review_time) as pt_review_time -- 平台审核时间
    ,nvl(n.agentid, o.agentid) as agentid -- 代理商编号
    ,nvl(n.group_no, o.group_no) as group_no -- 
    ,nvl(n.client_ip, o.client_ip) as client_ip -- 
    ,nvl(n.data_sign, o.data_sign) as data_sign -- 
    ,nvl(n.modify_time, o.modify_time) as modify_time -- 
    ,nvl(n.mdiscount, o.mdiscount) as mdiscount -- 
    ,nvl(n.union_id, o.union_id) as union_id -- 
    ,nvl(n.bank_type, o.bank_type) as bank_type -- 
    ,nvl(n.openid, o.openid) as openid -- 
    ,nvl(n.sub_openid, o.sub_openid) as sub_openid -- 
    ,nvl(n.fld_s1, o.fld_s1) as fld_s1 -- 
    ,nvl(n.fld_s2, o.fld_s2) as fld_s2 -- 
    ,nvl(n.fld_s3, o.fld_s3) as fld_s3 -- 
    ,nvl(n.bs_discount, o.bs_discount) as bs_discount -- 银联自定义优惠退款金额
    ,nvl(n.bs_discount_type, o.bs_discount_type) as bs_discount_type -- 银联自定义优惠类型
    ,nvl(n.sign_agentno, o.sign_agentno) as sign_agentno -- 授权机构号
    ,nvl(n.fld_s4, o.fld_s4) as fld_s4 -- 
    ,nvl(n.fld_s5, o.fld_s5) as fld_s5 -- 
    ,nvl(n.fld_s6, o.fld_s6) as fld_s6 -- 
    ,nvl(n.fld_s7, o.fld_s7) as fld_s7 -- 
    ,nvl(n.fld_s8, o.fld_s8) as fld_s8 -- 
    ,nvl(n.mch_discount_amount, o.mch_discount_amount) as mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,nvl(n.plat_discount_amount, o.plat_discount_amount) as plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_rate_type, o.mch_rate_type) as mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,nvl(n.mch_rate, o.mch_rate) as mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,nvl(n.cost_rate, o.cost_rate) as cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,nvl(n.mch_theory_procedure_fee, o.mch_theory_procedure_fee) as mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_real_procedure_fee, o.mch_real_procedure_fee) as mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.mch_discount_fee, o.mch_discount_fee) as mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,nvl(n.debit_card_brokerage_limit, o.debit_card_brokerage_limit) as debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.ori_mch_theory_fee, o.ori_mch_theory_fee) as ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.ori_mch_real_fee, o.ori_mch_real_fee) as ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
    ,nvl(n.calc_state, o.calc_state) as calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
    ,nvl(n.api_provider, o.api_provider) as api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,nvl(n.pay_center_id, o.pay_center_id) as pay_center_id -- 支付通道ID，对应通道表主键
    ,nvl(n.quick_serial_no, o.quick_serial_no) as quick_serial_no -- 
    ,nvl(n.acc_way_period, o.acc_way_period) as acc_way_period -- 结算周期
    ,nvl(n.acct_dt, o.acct_dt) as acct_dt -- 会计日，格式20240808
    ,case when
            n.refund_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.refund_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.refund_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_pay_refund_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_pay_refund where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.refund_no = n.refund_no
where (
        o.refund_no is null
    )
    or (
        n.refund_no is null
    )
    or (
        o.order_no <> n.order_no
        or o.mch_id <> n.mch_id
        or o.total_fee <> n.total_fee
        or o.refund_fee <> n.refund_fee
        or o.add_time <> n.add_time
        or o.refund_state <> n.refund_state
        or o.order_state <> n.order_state
        or o.trade_type <> n.trade_type
        or o.trade_name <> n.trade_name
        or o.refundid <> n.refundid
        or o.transaction_id <> n.transaction_id
        or o.out_refund_no <> n.out_refund_no
        or o.out_trade_no <> n.out_trade_no
        or o.refund_channel <> n.refund_channel
        or o.refund_user <> n.refund_user
        or o.update_version <> n.update_version
        or o.mch_audit <> n.mch_audit
        or o.daemon_audit <> n.daemon_audit
        or o.refund_time <> n.refund_time
        or o.refuse_reason <> n.refuse_reason
        or o.mch_refuse_reason <> n.mch_refuse_reason
        or o.refund_source <> n.refund_source
        or o.mch_no <> n.mch_no
        or o.mch_name <> n.mch_name
        or o.fee_type <> n.fee_type
        or o.group_id <> n.group_id
        or o.groupno <> n.groupno
        or o.center_id <> n.center_id
        or o.risk_ctr <> n.risk_ctr
        or o.risk_info <> n.risk_info
        or o.mch_audit_user <> n.mch_audit_user
        or o.pt_audit_user <> n.pt_audit_user
        or o.bank_no <> n.bank_no
        or o.agentno <> n.agentno
        or o.deparno <> n.deparno
        or o.termtype <> n.termtype
        or o.termno <> n.termno
        or o.operno <> n.operno
        or o.shopno <> n.shopno
        or o.mch_review_time <> n.mch_review_time
        or o.pt_review_time <> n.pt_review_time
        or o.agentid <> n.agentid
        or o.group_no <> n.group_no
        or o.client_ip <> n.client_ip
        or o.data_sign <> n.data_sign
        or o.modify_time <> n.modify_time
        or o.mdiscount <> n.mdiscount
        or o.union_id <> n.union_id
        or o.bank_type <> n.bank_type
        or o.openid <> n.openid
        or o.sub_openid <> n.sub_openid
        or o.fld_s1 <> n.fld_s1
        or o.fld_s2 <> n.fld_s2
        or o.fld_s3 <> n.fld_s3
        or o.bs_discount <> n.bs_discount
        or o.bs_discount_type <> n.bs_discount_type
        or o.sign_agentno <> n.sign_agentno
        or o.fld_s4 <> n.fld_s4
        or o.fld_s5 <> n.fld_s5
        or o.fld_s6 <> n.fld_s6
        or o.fld_s7 <> n.fld_s7
        or o.fld_s8 <> n.fld_s8
        or o.mch_discount_amount <> n.mch_discount_amount
        or o.plat_discount_amount <> n.plat_discount_amount
        or o.mch_rate_type <> n.mch_rate_type
        or o.mch_rate <> n.mch_rate
        or o.cost_rate <> n.cost_rate
        or o.mch_theory_procedure_fee <> n.mch_theory_procedure_fee
        or o.mch_real_procedure_fee <> n.mch_real_procedure_fee
        or o.mch_discount_fee <> n.mch_discount_fee
        or o.debit_card_brokerage_limit <> n.debit_card_brokerage_limit
        or o.ori_mch_theory_fee <> n.ori_mch_theory_fee
        or o.ori_mch_real_fee <> n.ori_mch_real_fee
        or o.calc_state <> n.calc_state
        or o.api_provider <> n.api_provider
        or o.pay_center_id <> n.pay_center_id
        or o.quick_serial_no <> n.quick_serial_no
        or o.acc_way_period <> n.acc_way_period
        or o.acct_dt <> n.acct_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_pay_refund_cl(
            refund_no -- 退款单号
            ,order_no -- 订单号
            ,mch_id -- 商户ID
            ,total_fee -- 订单总额
            ,refund_fee -- 退款总额
            ,add_time -- 添加时间
            ,refund_state -- 退款状态
            ,order_state -- 订单状态
            ,trade_type -- 支付类型
            ,trade_name -- 支付名称
            ,refundid -- 第三方退款单号
            ,transaction_id -- 第三方订单号
            ,out_refund_no -- 商户退款单号
            ,out_trade_no -- 商户订单号
            ,refund_channel -- 退款渠道
            ,refund_user -- 退款用户
            ,update_version -- 版本号
            ,mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
            ,refund_time -- 退款时间
            ,refuse_reason -- 支付退款理由
            ,mch_refuse_reason -- 商户退款理由
            ,refund_source -- 退款来源
            ,mch_no -- 商户编号
            ,mch_name -- 商户名称
            ,fee_type -- 币种
            ,group_id -- 组织编号
            ,groupno -- 组织编号
            ,center_id -- 支付中心
            ,risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,risk_info -- 分控信息
            ,mch_audit_user -- 商户审核用户
            ,pt_audit_user -- 平台审核用户
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,deparno -- 门店部门编号
            ,termtype -- 终端类型.POS,SPAY,ADMIN
            ,termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,operno -- 操作员编号
            ,shopno -- 操作门店编号
            ,mch_review_time -- 商户审核时间
            ,pt_review_time -- 平台审核时间
            ,agentid -- 代理商编号
            ,group_no -- 
            ,client_ip -- 
            ,data_sign -- 
            ,modify_time -- 
            ,mdiscount -- 
            ,union_id -- 
            ,bank_type -- 
            ,openid -- 
            ,sub_openid -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,bs_discount -- 银联自定义优惠退款金额
            ,bs_discount_type -- 银联自定义优惠类型
            ,sign_agentno -- 授权机构号
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,fld_s6 -- 
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 
            ,acc_way_period -- 结算周期
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_pay_refund_op(
            refund_no -- 退款单号
            ,order_no -- 订单号
            ,mch_id -- 商户ID
            ,total_fee -- 订单总额
            ,refund_fee -- 退款总额
            ,add_time -- 添加时间
            ,refund_state -- 退款状态
            ,order_state -- 订单状态
            ,trade_type -- 支付类型
            ,trade_name -- 支付名称
            ,refundid -- 第三方退款单号
            ,transaction_id -- 第三方订单号
            ,out_refund_no -- 商户退款单号
            ,out_trade_no -- 商户订单号
            ,refund_channel -- 退款渠道
            ,refund_user -- 退款用户
            ,update_version -- 版本号
            ,mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
            ,daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
            ,refund_time -- 退款时间
            ,refuse_reason -- 支付退款理由
            ,mch_refuse_reason -- 商户退款理由
            ,refund_source -- 退款来源
            ,mch_no -- 商户编号
            ,mch_name -- 商户名称
            ,fee_type -- 币种
            ,group_id -- 组织编号
            ,groupno -- 组织编号
            ,center_id -- 支付中心
            ,risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
            ,risk_info -- 分控信息
            ,mch_audit_user -- 商户审核用户
            ,pt_audit_user -- 平台审核用户
            ,bank_no -- 银行编码
            ,agentno -- 代理商编号
            ,deparno -- 门店部门编号
            ,termtype -- 终端类型.POS,SPAY,ADMIN
            ,termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
            ,operno -- 操作员编号
            ,shopno -- 操作门店编号
            ,mch_review_time -- 商户审核时间
            ,pt_review_time -- 平台审核时间
            ,agentid -- 代理商编号
            ,group_no -- 
            ,client_ip -- 
            ,data_sign -- 
            ,modify_time -- 
            ,mdiscount -- 
            ,union_id -- 
            ,bank_type -- 
            ,openid -- 
            ,sub_openid -- 
            ,fld_s1 -- 
            ,fld_s2 -- 
            ,fld_s3 -- 
            ,bs_discount -- 银联自定义优惠退款金额
            ,bs_discount_type -- 银联自定义优惠类型
            ,sign_agentno -- 授权机构号
            ,fld_s4 -- 
            ,fld_s5 -- 
            ,fld_s6 -- 
            ,fld_s7 -- 
            ,fld_s8 -- 
            ,mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
            ,plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
            ,mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
            ,mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
            ,cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
            ,mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
            ,mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
            ,mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
            ,debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
            ,ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
            ,calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
            ,api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
            ,pay_center_id -- 支付通道ID，对应通道表主键
            ,quick_serial_no -- 
            ,acc_way_period -- 结算周期
            ,acct_dt -- 会计日，格式20240808
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.refund_no -- 退款单号
    ,o.order_no -- 订单号
    ,o.mch_id -- 商户ID
    ,o.total_fee -- 订单总额
    ,o.refund_fee -- 退款总额
    ,o.add_time -- 添加时间
    ,o.refund_state -- 退款状态
    ,o.order_state -- 订单状态
    ,o.trade_type -- 支付类型
    ,o.trade_name -- 支付名称
    ,o.refundid -- 第三方退款单号
    ,o.transaction_id -- 第三方订单号
    ,o.out_refund_no -- 商户退款单号
    ,o.out_trade_no -- 商户订单号
    ,o.refund_channel -- 退款渠道
    ,o.refund_user -- 退款用户
    ,o.update_version -- 版本号
    ,o.mch_audit -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
    ,o.daemon_audit -- 支付退款审核状态.0：初始，1：退回，2：审核通过
    ,o.refund_time -- 退款时间
    ,o.refuse_reason -- 支付退款理由
    ,o.mch_refuse_reason -- 商户退款理由
    ,o.refund_source -- 退款来源
    ,o.mch_no -- 商户编号
    ,o.mch_name -- 商户名称
    ,o.fee_type -- 币种
    ,o.group_id -- 组织编号
    ,o.groupno -- 组织编号
    ,o.center_id -- 支付中心
    ,o.risk_ctr -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
    ,o.risk_info -- 分控信息
    ,o.mch_audit_user -- 商户审核用户
    ,o.pt_audit_user -- 平台审核用户
    ,o.bank_no -- 银行编码
    ,o.agentno -- 代理商编号
    ,o.deparno -- 门店部门编号
    ,o.termtype -- 终端类型.POS,SPAY,ADMIN
    ,o.termno -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
    ,o.operno -- 操作员编号
    ,o.shopno -- 操作门店编号
    ,o.mch_review_time -- 商户审核时间
    ,o.pt_review_time -- 平台审核时间
    ,o.agentid -- 代理商编号
    ,o.group_no -- 
    ,o.client_ip -- 
    ,o.data_sign -- 
    ,o.modify_time -- 
    ,o.mdiscount -- 
    ,o.union_id -- 
    ,o.bank_type -- 
    ,o.openid -- 
    ,o.sub_openid -- 
    ,o.fld_s1 -- 
    ,o.fld_s2 -- 
    ,o.fld_s3 -- 
    ,o.bs_discount -- 银联自定义优惠退款金额
    ,o.bs_discount_type -- 银联自定义优惠类型
    ,o.sign_agentno -- 授权机构号
    ,o.fld_s4 -- 
    ,o.fld_s5 -- 
    ,o.fld_s6 -- 
    ,o.fld_s7 -- 
    ,o.fld_s8 -- 
    ,o.mch_discount_amount -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,o.plat_discount_amount -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,o.mch_rate_type -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,o.mch_rate -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,o.cost_rate -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,o.mch_theory_procedure_fee -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,o.mch_real_procedure_fee -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,o.mch_discount_fee -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,o.debit_card_brokerage_limit -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,o.ori_mch_theory_fee -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
    ,o.ori_mch_real_fee -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
    ,o.calc_state -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
    ,o.api_provider -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,o.pay_center_id -- 支付通道ID，对应通道表主键
    ,o.quick_serial_no -- 
    ,o.acc_way_period -- 结算周期
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
from ${iol_schema}.amss_pay_refund_bk o
    left join ${iol_schema}.amss_pay_refund_op n
        on
            o.refund_no = n.refund_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_pay_refund_cl d
        on
            o.refund_no = d.refund_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_pay_refund;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_pay_refund') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_pay_refund drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_pay_refund add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_pay_refund exchange partition p_${batch_date} with table ${iol_schema}.amss_pay_refund_cl;
alter table ${iol_schema}.amss_pay_refund exchange partition p_20991231 with table ${iol_schema}.amss_pay_refund_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_pay_refund to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_pay_refund_op purge;
drop table ${iol_schema}.amss_pay_refund_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_pay_refund_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_pay_refund',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
