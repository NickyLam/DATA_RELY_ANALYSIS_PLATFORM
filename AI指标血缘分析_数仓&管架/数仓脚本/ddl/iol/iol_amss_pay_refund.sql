/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_pay_refund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_pay_refund
whenever sqlerror continue none;
drop table ${iol_schema}.amss_pay_refund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_pay_refund(
    refund_no varchar2(32) -- 退款单号
    ,order_no varchar2(32) -- 订单号
    ,mch_id number(11,0) -- 商户ID
    ,total_fee number(11,0) -- 订单总额
    ,refund_fee number(11,0) -- 退款总额
    ,add_time timestamp -- 添加时间
    ,refund_state number(4,0) -- 退款状态
    ,order_state number(4,0) -- 订单状态
    ,trade_type varchar2(32) -- 支付类型
    ,trade_name varchar2(64) -- 支付名称
    ,refundid varchar2(64) -- 第三方退款单号
    ,transaction_id varchar2(64) -- 第三方订单号
    ,out_refund_no varchar2(32) -- 商户退款单号
    ,out_trade_no varchar2(32) -- 商户订单号
    ,refund_channel varchar2(32) -- 退款渠道
    ,refund_user varchar2(32) -- 退款用户
    ,update_version number(11,0) -- 版本号
    ,mch_audit number(11,0) -- 商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过
    ,daemon_audit number(11,0) -- 支付退款审核状态.0：初始，1：退回，2：审核通过
    ,refund_time timestamp -- 退款时间
    ,refuse_reason varchar2(256) -- 支付退款理由
    ,mch_refuse_reason varchar2(256) -- 商户退款理由
    ,refund_source number(1,0) -- 退款来源
    ,mch_no varchar2(32) -- 商户编号
    ,mch_name varchar2(64) -- 商户名称
    ,fee_type varchar2(6) -- 币种
    ,group_id number(11,0) -- 组织编号
    ,groupno varchar2(32) -- 组织编号
    ,center_id number(11,0) -- 支付中心
    ,risk_ctr number(4,0) -- 风控状态.0初始化、1风控正常，2没设分控,3:分控异常
    ,risk_info varchar2(64) -- 分控信息
    ,mch_audit_user varchar2(32) -- 商户审核用户
    ,pt_audit_user varchar2(32) -- 平台审核用户
    ,bank_no varchar2(32) -- 银行编码
    ,agentno varchar2(32) -- 代理商编号
    ,deparno varchar2(32) -- 门店部门编号
    ,termtype varchar2(32) -- 终端类型.POS,SPAY,ADMIN
    ,termno varchar2(32) -- 终端编号.如果是ADMIN退款终端编号填写用户操作IP
    ,operno varchar2(32) -- 操作员编号
    ,shopno varchar2(32) -- 操作门店编号
    ,mch_review_time timestamp -- 商户审核时间
    ,pt_review_time timestamp -- 平台审核时间
    ,agentid varchar2(32) -- 代理商编号
    ,group_no varchar2(32) -- 
    ,client_ip varchar2(32) -- 
    ,data_sign varchar2(128) -- 
    ,modify_time timestamp -- 
    ,mdiscount number(11,0) -- 
    ,union_id varchar2(32) -- 
    ,bank_type varchar2(32) -- 
    ,openid varchar2(255) -- 
    ,sub_openid varchar2(255) -- 
    ,fld_s1 varchar2(255) -- 
    ,fld_s2 varchar2(255) -- 
    ,fld_s3 varchar2(255) -- 
    ,bs_discount number(11,0) -- 银联自定义优惠退款金额
    ,bs_discount_type varchar2(16) -- 银联自定义优惠类型
    ,sign_agentno varchar2(32) -- 授权机构号
    ,fld_s4 varchar2(255) -- 
    ,fld_s5 varchar2(255) -- 
    ,fld_s6 varchar2(255) -- 
    ,fld_s7 varchar2(255) -- 
    ,fld_s8 varchar2(255) -- 
    ,mch_discount_amount number(13,2) -- 商家优惠金额，单位:分(计费字段，后续拆分)
    ,plat_discount_amount number(13,2) -- 平台优惠金额，单位:分(计费字段，后续拆分)
    ,mch_rate_type number(1,0) -- 费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)
    ,mch_rate number(11,0) -- 商户费率，百万单位存储(计费字段，后续拆分)
    ,cost_rate number(11,0) -- 通道费率，百万单位存储(计费字段，后续拆分)
    ,mch_theory_procedure_fee number(13,2) -- 商户理论手续费，单位:分(计费字段，后续拆分)
    ,mch_real_procedure_fee number(13,2) -- 商户实际手续费，单位:分(计费字段，后续拆分)
    ,mch_discount_fee number(13,2) -- 商户手续费减免金额，单位:分(计费字段，后续拆分)
    ,debit_card_brokerage_limit number(13,2) -- 商户封顶手续费，单位:分(计费字段，后续拆分)
    ,ori_mch_theory_fee number(13,2) -- 原交易订单商户理论手续费，单位:分(计费字段，后续拆分)
    ,ori_mch_real_fee number(13,2) -- 原交易订单商户实际手续费，单位:分(计费字段，后续拆分)
    ,calc_state number(1,0) -- 手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)
    ,api_provider number(11,0) -- 接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER
    ,pay_center_id varchar2(32) -- 支付通道ID，对应通道表主键
    ,quick_serial_no varchar2(256) -- 
    ,acc_way_period number(5,0) -- 结算周期
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
grant select on ${iol_schema}.amss_pay_refund to ${iml_schema};
grant select on ${iol_schema}.amss_pay_refund to ${icl_schema};
grant select on ${iol_schema}.amss_pay_refund to ${idl_schema};
grant select on ${iol_schema}.amss_pay_refund to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_pay_refund is '退款单表';
comment on column ${iol_schema}.amss_pay_refund.refund_no is '退款单号';
comment on column ${iol_schema}.amss_pay_refund.order_no is '订单号';
comment on column ${iol_schema}.amss_pay_refund.mch_id is '商户ID';
comment on column ${iol_schema}.amss_pay_refund.total_fee is '订单总额';
comment on column ${iol_schema}.amss_pay_refund.refund_fee is '退款总额';
comment on column ${iol_schema}.amss_pay_refund.add_time is '添加时间';
comment on column ${iol_schema}.amss_pay_refund.refund_state is '退款状态';
comment on column ${iol_schema}.amss_pay_refund.order_state is '订单状态';
comment on column ${iol_schema}.amss_pay_refund.trade_type is '支付类型';
comment on column ${iol_schema}.amss_pay_refund.trade_name is '支付名称';
comment on column ${iol_schema}.amss_pay_refund.refundid is '第三方退款单号';
comment on column ${iol_schema}.amss_pay_refund.transaction_id is '第三方订单号';
comment on column ${iol_schema}.amss_pay_refund.out_refund_no is '商户退款单号';
comment on column ${iol_schema}.amss_pay_refund.out_trade_no is '商户订单号';
comment on column ${iol_schema}.amss_pay_refund.refund_channel is '退款渠道';
comment on column ${iol_schema}.amss_pay_refund.refund_user is '退款用户';
comment on column ${iol_schema}.amss_pay_refund.update_version is '版本号';
comment on column ${iol_schema}.amss_pay_refund.mch_audit is '商户退款审核状态.0：初始，1：待审核，2：转入退款,3:审核不通过';
comment on column ${iol_schema}.amss_pay_refund.daemon_audit is '支付退款审核状态.0：初始，1：退回，2：审核通过';
comment on column ${iol_schema}.amss_pay_refund.refund_time is '退款时间';
comment on column ${iol_schema}.amss_pay_refund.refuse_reason is '支付退款理由';
comment on column ${iol_schema}.amss_pay_refund.mch_refuse_reason is '商户退款理由';
comment on column ${iol_schema}.amss_pay_refund.refund_source is '退款来源';
comment on column ${iol_schema}.amss_pay_refund.mch_no is '商户编号';
comment on column ${iol_schema}.amss_pay_refund.mch_name is '商户名称';
comment on column ${iol_schema}.amss_pay_refund.fee_type is '币种';
comment on column ${iol_schema}.amss_pay_refund.group_id is '组织编号';
comment on column ${iol_schema}.amss_pay_refund.groupno is '组织编号';
comment on column ${iol_schema}.amss_pay_refund.center_id is '支付中心';
comment on column ${iol_schema}.amss_pay_refund.risk_ctr is '风控状态.0初始化、1风控正常，2没设分控,3:分控异常';
comment on column ${iol_schema}.amss_pay_refund.risk_info is '分控信息';
comment on column ${iol_schema}.amss_pay_refund.mch_audit_user is '商户审核用户';
comment on column ${iol_schema}.amss_pay_refund.pt_audit_user is '平台审核用户';
comment on column ${iol_schema}.amss_pay_refund.bank_no is '银行编码';
comment on column ${iol_schema}.amss_pay_refund.agentno is '代理商编号';
comment on column ${iol_schema}.amss_pay_refund.deparno is '门店部门编号';
comment on column ${iol_schema}.amss_pay_refund.termtype is '终端类型.POS,SPAY,ADMIN';
comment on column ${iol_schema}.amss_pay_refund.termno is '终端编号.如果是ADMIN退款终端编号填写用户操作IP';
comment on column ${iol_schema}.amss_pay_refund.operno is '操作员编号';
comment on column ${iol_schema}.amss_pay_refund.shopno is '操作门店编号';
comment on column ${iol_schema}.amss_pay_refund.mch_review_time is '商户审核时间';
comment on column ${iol_schema}.amss_pay_refund.pt_review_time is '平台审核时间';
comment on column ${iol_schema}.amss_pay_refund.agentid is '代理商编号';
comment on column ${iol_schema}.amss_pay_refund.group_no is '';
comment on column ${iol_schema}.amss_pay_refund.client_ip is '';
comment on column ${iol_schema}.amss_pay_refund.data_sign is '';
comment on column ${iol_schema}.amss_pay_refund.modify_time is '';
comment on column ${iol_schema}.amss_pay_refund.mdiscount is '';
comment on column ${iol_schema}.amss_pay_refund.union_id is '';
comment on column ${iol_schema}.amss_pay_refund.bank_type is '';
comment on column ${iol_schema}.amss_pay_refund.openid is '';
comment on column ${iol_schema}.amss_pay_refund.sub_openid is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s1 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s2 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s3 is '';
comment on column ${iol_schema}.amss_pay_refund.bs_discount is '银联自定义优惠退款金额';
comment on column ${iol_schema}.amss_pay_refund.bs_discount_type is '银联自定义优惠类型';
comment on column ${iol_schema}.amss_pay_refund.sign_agentno is '授权机构号';
comment on column ${iol_schema}.amss_pay_refund.fld_s4 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s5 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s6 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s7 is '';
comment on column ${iol_schema}.amss_pay_refund.fld_s8 is '';
comment on column ${iol_schema}.amss_pay_refund.mch_discount_amount is '商家优惠金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.plat_discount_amount is '平台优惠金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.mch_rate_type is '费率类型，1.按比列;2.按阶梯(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.mch_rate is '商户费率，百万单位存储(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.cost_rate is '通道费率，百万单位存储(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.mch_theory_procedure_fee is '商户理论手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.mch_real_procedure_fee is '商户实际手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.mch_discount_fee is '商户手续费减免金额，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.debit_card_brokerage_limit is '商户封顶手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.ori_mch_theory_fee is '原交易订单商户理论手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.ori_mch_real_fee is '原交易订单商户实际手续费，单位:分(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.calc_state is '手续费计算状态，0:初始,1.计算中,2.计算成功,3.计算失败(计费字段，后续拆分)';
comment on column ${iol_schema}.amss_pay_refund.api_provider is '接口提供方，数据来源：cms_sys_type，type_class = API_PROVIDER';
comment on column ${iol_schema}.amss_pay_refund.pay_center_id is '支付通道ID，对应通道表主键';
comment on column ${iol_schema}.amss_pay_refund.quick_serial_no is '';
comment on column ${iol_schema}.amss_pay_refund.acc_way_period is '结算周期';
comment on column ${iol_schema}.amss_pay_refund.acct_dt is '会计日，格式20240808';
comment on column ${iol_schema}.amss_pay_refund.start_dt is '开始时间';
comment on column ${iol_schema}.amss_pay_refund.end_dt is '结束时间';
comment on column ${iol_schema}.amss_pay_refund.id_mark is '增删标志';
comment on column ${iol_schema}.amss_pay_refund.etl_timestamp is 'ETL处理时间戳';
