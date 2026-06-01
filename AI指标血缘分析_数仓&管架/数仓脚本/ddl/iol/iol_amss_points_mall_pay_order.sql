/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_points_mall_pay_order
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_points_mall_pay_order
whenever sqlerror continue none;
drop table ${iol_schema}.amss_points_mall_pay_order purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_pay_order(
    serial_num varchar2(48) -- 流水号
    ,txn_date timestamp -- 交易日期
    ,txn_time timestamp -- 交易时间
    ,order_num varchar2(192) -- 积分商城订单号
    ,pay_type number(1,0) -- 1-支付 2-退款
    ,pty_id varchar2(48) -- 客户号
    ,pty_rank varchar2(48) -- 客户等级
    ,pty_name varchar2(48) -- 客户名称
    ,iden_type_cd varchar2(48) -- 证件类型
    ,cert_num varchar2(48) -- 证件号码
    ,pty_open_org varchar2(48) -- 客户开户机构
    ,agents_id varchar2(48) -- 代理商编号
    ,mrchd_type number(1,0) -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
    ,txn_code varchar2(48) -- 交易码
    ,gross_qtty_amt number(10,2) -- 订单总金额
    ,gross_qtty_points number(10,2) -- 订单总积分
    ,points_type varchar2(48) -- 订单积分类型
    ,entitlement_point number(10,2) -- 订单权益积分
    ,rem_amt number(10,2) -- 剩余可用金额
    ,rem_points number(10,2) -- 剩余可用积分
    ,rem_entitlement_point number(10,2) -- 剩余可用权益积分
    ,txn_status varchar2(3) -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
    ,payment_success_date timestamp -- 付款成功日期
    ,pay_card_num varchar2(48) -- 支付卡号
    ,open_org_num varchar2(192) -- 支付卡开户机构
    ,acct_num_name varchar2(192) -- 支付卡名称
    ,bank_name varchar2(192) -- 银行名称
    ,exch_brch_no varchar2(48) -- 联行号
    ,card_type number(1,0) -- 卡类型 1-1类卡 2-2类卡 3-3类卡
    ,wthr_check_bal number(1,0) -- 是否检查余额 0否 1是 空否
    ,fret_amt number(10,2) -- 运费金额
    ,cons_name varchar2(48) -- 收货人姓名
    ,cons_ceph_num varchar2(48) -- 收货人手机号
    ,cons_loc_prov varchar2(48) -- 收货人所在省
    ,cons_loc_city varchar2(48) -- 收货人所在市
    ,cons_loc_cuty varchar2(48) -- 收货人所在县（区）
    ,cons_loc_town varchar2(48) -- 收货人所在镇
    ,cons_dtl_loc varchar2(192) -- 收货人详细地址
    ,pick_goods_mode varchar2(48) -- 提货方式
    ,pty_mgr_num varchar2(48) -- 银行客户经理号
    ,txn_org_num varchar2(48) -- 交易机构号
    ,orig_order_num varchar2(192) -- 原交易订单号
    ,orig_trx_dt varchar2(48) -- 原订单交易日期
    ,srv_resp_code varchar2(48) -- 响应码
    ,srv_resp_info varchar2(384) -- 响应描述
    ,merch_num varchar2(48) -- 商户号
    ,channel_id varchar2(48) -- 所属机构
    ,cnsm_typ number(1,0) -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
    ,physics_flag number(1,0) -- 物理标识 1-正常 2-删除
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,create_emp varchar2(48) -- 创建人
    ,update_emp varchar2(48) -- 更新人
    ,pay_serial_num varchar2(48) -- 原交易平台流水号（退款用）
    ,pay_order_num varchar2(48) -- 原交易订单号（退款用）
    ,gross_fjl number(10,2) -- 订单总福利金
    ,rem_flj number(10,2) -- 剩余福利金
    ,return_flag number(1,0) -- 组合支付回滚标志
    ,txn_num varchar2(180) -- 交易流水号
    ,notify_flag number(1,0) -- 是否通知成功 (0-失败 1-成功)
    ,notify_count number(2,0) -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
    ,ship_status varchar2(10) -- 发货状态1：未发货 2：已发货
    ,cons_loc_prov_v varchar2(120) -- 收货人所在省
    ,cons_loc_city_v varchar2(120) -- 收货人所在市
    ,cons_loc_cuty_v varchar2(120) -- 收货人所在县（区）
    ,cons_loc_town_v varchar2(120) -- 收货人所在镇
    ,cons_dtl_loc_v varchar2(512) -- 收货人详细地址
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
grant select on ${iol_schema}.amss_points_mall_pay_order to ${iml_schema};
grant select on ${iol_schema}.amss_points_mall_pay_order to ${icl_schema};
grant select on ${iol_schema}.amss_points_mall_pay_order to ${idl_schema};
grant select on ${iol_schema}.amss_points_mall_pay_order to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_points_mall_pay_order is '积分商城-订单表';
comment on column ${iol_schema}.amss_points_mall_pay_order.serial_num is '流水号';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_date is '交易日期';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_time is '交易时间';
comment on column ${iol_schema}.amss_points_mall_pay_order.order_num is '积分商城订单号';
comment on column ${iol_schema}.amss_points_mall_pay_order.pay_type is '1-支付 2-退款';
comment on column ${iol_schema}.amss_points_mall_pay_order.pty_id is '客户号';
comment on column ${iol_schema}.amss_points_mall_pay_order.pty_rank is '客户等级';
comment on column ${iol_schema}.amss_points_mall_pay_order.pty_name is '客户名称';
comment on column ${iol_schema}.amss_points_mall_pay_order.iden_type_cd is '证件类型';
comment on column ${iol_schema}.amss_points_mall_pay_order.cert_num is '证件号码';
comment on column ${iol_schema}.amss_points_mall_pay_order.pty_open_org is '客户开户机构';
comment on column ${iol_schema}.amss_points_mall_pay_order.agents_id is '代理商编号';
comment on column ${iol_schema}.amss_points_mall_pay_order.mrchd_type is '商品类型 1-实体商品 2-虚拟商品 3-实物贵金属';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_code is '交易码';
comment on column ${iol_schema}.amss_points_mall_pay_order.gross_qtty_amt is '订单总金额';
comment on column ${iol_schema}.amss_points_mall_pay_order.gross_qtty_points is '订单总积分';
comment on column ${iol_schema}.amss_points_mall_pay_order.points_type is '订单积分类型';
comment on column ${iol_schema}.amss_points_mall_pay_order.entitlement_point is '订单权益积分';
comment on column ${iol_schema}.amss_points_mall_pay_order.rem_amt is '剩余可用金额';
comment on column ${iol_schema}.amss_points_mall_pay_order.rem_points is '剩余可用积分';
comment on column ${iol_schema}.amss_points_mall_pay_order.rem_entitlement_point is '剩余可用权益积分';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_status is '交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中';
comment on column ${iol_schema}.amss_points_mall_pay_order.payment_success_date is '付款成功日期';
comment on column ${iol_schema}.amss_points_mall_pay_order.pay_card_num is '支付卡号';
comment on column ${iol_schema}.amss_points_mall_pay_order.open_org_num is '支付卡开户机构';
comment on column ${iol_schema}.amss_points_mall_pay_order.acct_num_name is '支付卡名称';
comment on column ${iol_schema}.amss_points_mall_pay_order.bank_name is '银行名称';
comment on column ${iol_schema}.amss_points_mall_pay_order.exch_brch_no is '联行号';
comment on column ${iol_schema}.amss_points_mall_pay_order.card_type is '卡类型 1-1类卡 2-2类卡 3-3类卡';
comment on column ${iol_schema}.amss_points_mall_pay_order.wthr_check_bal is '是否检查余额 0否 1是 空否';
comment on column ${iol_schema}.amss_points_mall_pay_order.fret_amt is '运费金额';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_name is '收货人姓名';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_ceph_num is '收货人手机号';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_prov is '收货人所在省';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_city is '收货人所在市';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_cuty is '收货人所在县（区）';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_town is '收货人所在镇';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_dtl_loc is '收货人详细地址';
comment on column ${iol_schema}.amss_points_mall_pay_order.pick_goods_mode is '提货方式';
comment on column ${iol_schema}.amss_points_mall_pay_order.pty_mgr_num is '银行客户经理号';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_org_num is '交易机构号';
comment on column ${iol_schema}.amss_points_mall_pay_order.orig_order_num is '原交易订单号';
comment on column ${iol_schema}.amss_points_mall_pay_order.orig_trx_dt is '原订单交易日期';
comment on column ${iol_schema}.amss_points_mall_pay_order.srv_resp_code is '响应码';
comment on column ${iol_schema}.amss_points_mall_pay_order.srv_resp_info is '响应描述';
comment on column ${iol_schema}.amss_points_mall_pay_order.merch_num is '商户号';
comment on column ${iol_schema}.amss_points_mall_pay_order.channel_id is '所属机构';
comment on column ${iol_schema}.amss_points_mall_pay_order.cnsm_typ is '消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金';
comment on column ${iol_schema}.amss_points_mall_pay_order.physics_flag is '物理标识 1-正常 2-删除';
comment on column ${iol_schema}.amss_points_mall_pay_order.create_time is '创建时间';
comment on column ${iol_schema}.amss_points_mall_pay_order.update_time is '更新时间';
comment on column ${iol_schema}.amss_points_mall_pay_order.create_emp is '创建人';
comment on column ${iol_schema}.amss_points_mall_pay_order.update_emp is '更新人';
comment on column ${iol_schema}.amss_points_mall_pay_order.pay_serial_num is '原交易平台流水号（退款用）';
comment on column ${iol_schema}.amss_points_mall_pay_order.pay_order_num is '原交易订单号（退款用）';
comment on column ${iol_schema}.amss_points_mall_pay_order.gross_fjl is '订单总福利金';
comment on column ${iol_schema}.amss_points_mall_pay_order.rem_flj is '剩余福利金';
comment on column ${iol_schema}.amss_points_mall_pay_order.return_flag is '组合支付回滚标志';
comment on column ${iol_schema}.amss_points_mall_pay_order.txn_num is '交易流水号';
comment on column ${iol_schema}.amss_points_mall_pay_order.notify_flag is '是否通知成功 (0-失败 1-成功)';
comment on column ${iol_schema}.amss_points_mall_pay_order.notify_count is '支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)';
comment on column ${iol_schema}.amss_points_mall_pay_order.ship_status is '发货状态1：未发货 2：已发货';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_prov_v is '收货人所在省';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_city_v is '收货人所在市';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_cuty_v is '收货人所在县（区）';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_loc_town_v is '收货人所在镇';
comment on column ${iol_schema}.amss_points_mall_pay_order.cons_dtl_loc_v is '收货人详细地址';
comment on column ${iol_schema}.amss_points_mall_pay_order.start_dt is '开始时间';
comment on column ${iol_schema}.amss_points_mall_pay_order.end_dt is '结束时间';
comment on column ${iol_schema}.amss_points_mall_pay_order.id_mark is '增删标志';
comment on column ${iol_schema}.amss_points_mall_pay_order.etl_timestamp is 'ETL处理时间戳';
