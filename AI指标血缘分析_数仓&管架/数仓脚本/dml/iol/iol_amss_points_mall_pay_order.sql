/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_points_mall_pay_order
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
create table ${iol_schema}.amss_points_mall_pay_order_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_points_mall_pay_order
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_pay_order_op purge;
drop table ${iol_schema}.amss_points_mall_pay_order_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_pay_order_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_pay_order where 0=1;

create table ${iol_schema}.amss_points_mall_pay_order_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_pay_order where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_pay_order_cl(
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,ship_status -- 发货状态1：未发货 2：已发货
            ,cons_loc_prov_v -- 收货人所在省
            ,cons_loc_city_v -- 收货人所在市
            ,cons_loc_cuty_v -- 收货人所在县（区）
            ,cons_loc_town_v -- 收货人所在镇
            ,cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_pay_order_op(
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,ship_status -- 发货状态1：未发货 2：已发货
            ,cons_loc_prov_v -- 收货人所在省
            ,cons_loc_city_v -- 收货人所在市
            ,cons_loc_cuty_v -- 收货人所在县（区）
            ,cons_loc_town_v -- 收货人所在镇
            ,cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serial_num, o.serial_num) as serial_num -- 流水号
    ,nvl(n.txn_date, o.txn_date) as txn_date -- 交易日期
    ,nvl(n.txn_time, o.txn_time) as txn_time -- 交易时间
    ,nvl(n.order_num, o.order_num) as order_num -- 积分商城订单号
    ,nvl(n.pay_type, o.pay_type) as pay_type -- 1-支付 2-退款
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户号
    ,nvl(n.pty_rank, o.pty_rank) as pty_rank -- 客户等级
    ,nvl(n.pty_name, o.pty_name) as pty_name -- 客户名称
    ,nvl(n.iden_type_cd, o.iden_type_cd) as iden_type_cd -- 证件类型
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证件号码
    ,nvl(n.pty_open_org, o.pty_open_org) as pty_open_org -- 客户开户机构
    ,nvl(n.agents_id, o.agents_id) as agents_id -- 代理商编号
    ,nvl(n.mrchd_type, o.mrchd_type) as mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
    ,nvl(n.txn_code, o.txn_code) as txn_code -- 交易码
    ,nvl(n.gross_qtty_amt, o.gross_qtty_amt) as gross_qtty_amt -- 订单总金额
    ,nvl(n.gross_qtty_points, o.gross_qtty_points) as gross_qtty_points -- 订单总积分
    ,nvl(n.points_type, o.points_type) as points_type -- 订单积分类型
    ,nvl(n.entitlement_point, o.entitlement_point) as entitlement_point -- 订单权益积分
    ,nvl(n.rem_amt, o.rem_amt) as rem_amt -- 剩余可用金额
    ,nvl(n.rem_points, o.rem_points) as rem_points -- 剩余可用积分
    ,nvl(n.rem_entitlement_point, o.rem_entitlement_point) as rem_entitlement_point -- 剩余可用权益积分
    ,nvl(n.txn_status, o.txn_status) as txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
    ,nvl(n.payment_success_date, o.payment_success_date) as payment_success_date -- 付款成功日期
    ,nvl(n.pay_card_num, o.pay_card_num) as pay_card_num -- 支付卡号
    ,nvl(n.open_org_num, o.open_org_num) as open_org_num -- 支付卡开户机构
    ,nvl(n.acct_num_name, o.acct_num_name) as acct_num_name -- 支付卡名称
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.exch_brch_no, o.exch_brch_no) as exch_brch_no -- 联行号
    ,nvl(n.card_type, o.card_type) as card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
    ,nvl(n.wthr_check_bal, o.wthr_check_bal) as wthr_check_bal -- 是否检查余额 0否 1是 空否
    ,nvl(n.fret_amt, o.fret_amt) as fret_amt -- 运费金额
    ,nvl(n.cons_name, o.cons_name) as cons_name -- 收货人姓名
    ,nvl(n.cons_ceph_num, o.cons_ceph_num) as cons_ceph_num -- 收货人手机号
    ,nvl(n.cons_loc_prov, o.cons_loc_prov) as cons_loc_prov -- 收货人所在省
    ,nvl(n.cons_loc_city, o.cons_loc_city) as cons_loc_city -- 收货人所在市
    ,nvl(n.cons_loc_cuty, o.cons_loc_cuty) as cons_loc_cuty -- 收货人所在县（区）
    ,nvl(n.cons_loc_town, o.cons_loc_town) as cons_loc_town -- 收货人所在镇
    ,nvl(n.cons_dtl_loc, o.cons_dtl_loc) as cons_dtl_loc -- 收货人详细地址
    ,nvl(n.pick_goods_mode, o.pick_goods_mode) as pick_goods_mode -- 提货方式
    ,nvl(n.pty_mgr_num, o.pty_mgr_num) as pty_mgr_num -- 银行客户经理号
    ,nvl(n.txn_org_num, o.txn_org_num) as txn_org_num -- 交易机构号
    ,nvl(n.orig_order_num, o.orig_order_num) as orig_order_num -- 原交易订单号
    ,nvl(n.orig_trx_dt, o.orig_trx_dt) as orig_trx_dt -- 原订单交易日期
    ,nvl(n.srv_resp_code, o.srv_resp_code) as srv_resp_code -- 响应码
    ,nvl(n.srv_resp_info, o.srv_resp_info) as srv_resp_info -- 响应描述
    ,nvl(n.merch_num, o.merch_num) as merch_num -- 商户号
    ,nvl(n.channel_id, o.channel_id) as channel_id -- 所属机构
    ,nvl(n.cnsm_typ, o.cnsm_typ) as cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 物理标识 1-正常 2-删除
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 创建人
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 更新人
    ,nvl(n.pay_serial_num, o.pay_serial_num) as pay_serial_num -- 原交易平台流水号（退款用）
    ,nvl(n.pay_order_num, o.pay_order_num) as pay_order_num -- 原交易订单号（退款用）
    ,nvl(n.gross_fjl, o.gross_fjl) as gross_fjl -- 订单总福利金
    ,nvl(n.rem_flj, o.rem_flj) as rem_flj -- 剩余福利金
    ,nvl(n.return_flag, o.return_flag) as return_flag -- 组合支付回滚标志
    ,nvl(n.txn_num, o.txn_num) as txn_num -- 交易流水号
    ,nvl(n.notify_flag, o.notify_flag) as notify_flag -- 是否通知成功 (0-失败 1-成功)
    ,nvl(n.notify_count, o.notify_count) as notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
    ,nvl(n.ship_status, o.ship_status) as ship_status -- 发货状态1：未发货 2：已发货
    ,nvl(n.cons_loc_prov_v, o.cons_loc_prov_v) as cons_loc_prov_v -- 收货人所在省
    ,nvl(n.cons_loc_city_v, o.cons_loc_city_v) as cons_loc_city_v -- 收货人所在市
    ,nvl(n.cons_loc_cuty_v, o.cons_loc_cuty_v) as cons_loc_cuty_v -- 收货人所在县（区）
    ,nvl(n.cons_loc_town_v, o.cons_loc_town_v) as cons_loc_town_v -- 收货人所在镇
    ,nvl(n.cons_dtl_loc_v, o.cons_dtl_loc_v) as cons_dtl_loc_v -- 收货人详细地址
    ,case when
            n.serial_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serial_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serial_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_points_mall_pay_order_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_points_mall_pay_order where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serial_num = n.serial_num
where (
        o.serial_num is null
    )
    or (
        n.serial_num is null
    )
    or (
        o.txn_date <> n.txn_date
        or o.txn_time <> n.txn_time
        or o.order_num <> n.order_num
        or o.pay_type <> n.pay_type
        or o.pty_id <> n.pty_id
        or o.pty_rank <> n.pty_rank
        or o.pty_name <> n.pty_name
        or o.iden_type_cd <> n.iden_type_cd
        or o.cert_num <> n.cert_num
        or o.pty_open_org <> n.pty_open_org
        or o.agents_id <> n.agents_id
        or o.mrchd_type <> n.mrchd_type
        or o.txn_code <> n.txn_code
        or o.gross_qtty_amt <> n.gross_qtty_amt
        or o.gross_qtty_points <> n.gross_qtty_points
        or o.points_type <> n.points_type
        or o.entitlement_point <> n.entitlement_point
        or o.rem_amt <> n.rem_amt
        or o.rem_points <> n.rem_points
        or o.rem_entitlement_point <> n.rem_entitlement_point
        or o.txn_status <> n.txn_status
        or o.payment_success_date <> n.payment_success_date
        or o.pay_card_num <> n.pay_card_num
        or o.open_org_num <> n.open_org_num
        or o.acct_num_name <> n.acct_num_name
        or o.bank_name <> n.bank_name
        or o.exch_brch_no <> n.exch_brch_no
        or o.card_type <> n.card_type
        or o.wthr_check_bal <> n.wthr_check_bal
        or o.fret_amt <> n.fret_amt
        or o.cons_name <> n.cons_name
        or o.cons_ceph_num <> n.cons_ceph_num
        or o.cons_loc_prov <> n.cons_loc_prov
        or o.cons_loc_city <> n.cons_loc_city
        or o.cons_loc_cuty <> n.cons_loc_cuty
        or o.cons_loc_town <> n.cons_loc_town
        or o.cons_dtl_loc <> n.cons_dtl_loc
        or o.pick_goods_mode <> n.pick_goods_mode
        or o.pty_mgr_num <> n.pty_mgr_num
        or o.txn_org_num <> n.txn_org_num
        or o.orig_order_num <> n.orig_order_num
        or o.orig_trx_dt <> n.orig_trx_dt
        or o.srv_resp_code <> n.srv_resp_code
        or o.srv_resp_info <> n.srv_resp_info
        or o.merch_num <> n.merch_num
        or o.channel_id <> n.channel_id
        or o.cnsm_typ <> n.cnsm_typ
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_emp <> n.create_emp
        or o.update_emp <> n.update_emp
        or o.pay_serial_num <> n.pay_serial_num
        or o.pay_order_num <> n.pay_order_num
        or o.gross_fjl <> n.gross_fjl
        or o.rem_flj <> n.rem_flj
        or o.return_flag <> n.return_flag
        or o.txn_num <> n.txn_num
        or o.notify_flag <> n.notify_flag
        or o.notify_count <> n.notify_count
        or o.ship_status <> n.ship_status
        or o.cons_loc_prov_v <> n.cons_loc_prov_v
        or o.cons_loc_city_v <> n.cons_loc_city_v
        or o.cons_loc_cuty_v <> n.cons_loc_cuty_v
        or o.cons_loc_town_v <> n.cons_loc_town_v
        or o.cons_dtl_loc_v <> n.cons_dtl_loc_v
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_pay_order_cl(
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,ship_status -- 发货状态1：未发货 2：已发货
            ,cons_loc_prov_v -- 收货人所在省
            ,cons_loc_city_v -- 收货人所在市
            ,cons_loc_cuty_v -- 收货人所在县（区）
            ,cons_loc_town_v -- 收货人所在镇
            ,cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_pay_order_op(
            serial_num -- 流水号
            ,txn_date -- 交易日期
            ,txn_time -- 交易时间
            ,order_num -- 积分商城订单号
            ,pay_type -- 1-支付 2-退款
            ,pty_id -- 客户号
            ,pty_rank -- 客户等级
            ,pty_name -- 客户名称
            ,iden_type_cd -- 证件类型
            ,cert_num -- 证件号码
            ,pty_open_org -- 客户开户机构
            ,agents_id -- 代理商编号
            ,mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
            ,txn_code -- 交易码
            ,gross_qtty_amt -- 订单总金额
            ,gross_qtty_points -- 订单总积分
            ,points_type -- 订单积分类型
            ,entitlement_point -- 订单权益积分
            ,rem_amt -- 剩余可用金额
            ,rem_points -- 剩余可用积分
            ,rem_entitlement_point -- 剩余可用权益积分
            ,txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
            ,payment_success_date -- 付款成功日期
            ,pay_card_num -- 支付卡号
            ,open_org_num -- 支付卡开户机构
            ,acct_num_name -- 支付卡名称
            ,bank_name -- 银行名称
            ,exch_brch_no -- 联行号
            ,card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
            ,wthr_check_bal -- 是否检查余额 0否 1是 空否
            ,fret_amt -- 运费金额
            ,cons_name -- 收货人姓名
            ,cons_ceph_num -- 收货人手机号
            ,cons_loc_prov -- 收货人所在省
            ,cons_loc_city -- 收货人所在市
            ,cons_loc_cuty -- 收货人所在县（区）
            ,cons_loc_town -- 收货人所在镇
            ,cons_dtl_loc -- 收货人详细地址
            ,pick_goods_mode -- 提货方式
            ,pty_mgr_num -- 银行客户经理号
            ,txn_org_num -- 交易机构号
            ,orig_order_num -- 原交易订单号
            ,orig_trx_dt -- 原订单交易日期
            ,srv_resp_code -- 响应码
            ,srv_resp_info -- 响应描述
            ,merch_num -- 商户号
            ,channel_id -- 所属机构
            ,cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
            ,physics_flag -- 物理标识 1-正常 2-删除
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,create_emp -- 创建人
            ,update_emp -- 更新人
            ,pay_serial_num -- 原交易平台流水号（退款用）
            ,pay_order_num -- 原交易订单号（退款用）
            ,gross_fjl -- 订单总福利金
            ,rem_flj -- 剩余福利金
            ,return_flag -- 组合支付回滚标志
            ,txn_num -- 交易流水号
            ,notify_flag -- 是否通知成功 (0-失败 1-成功)
            ,notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
            ,ship_status -- 发货状态1：未发货 2：已发货
            ,cons_loc_prov_v -- 收货人所在省
            ,cons_loc_city_v -- 收货人所在市
            ,cons_loc_cuty_v -- 收货人所在县（区）
            ,cons_loc_town_v -- 收货人所在镇
            ,cons_dtl_loc_v -- 收货人详细地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serial_num -- 流水号
    ,o.txn_date -- 交易日期
    ,o.txn_time -- 交易时间
    ,o.order_num -- 积分商城订单号
    ,o.pay_type -- 1-支付 2-退款
    ,o.pty_id -- 客户号
    ,o.pty_rank -- 客户等级
    ,o.pty_name -- 客户名称
    ,o.iden_type_cd -- 证件类型
    ,o.cert_num -- 证件号码
    ,o.pty_open_org -- 客户开户机构
    ,o.agents_id -- 代理商编号
    ,o.mrchd_type -- 商品类型 1-实体商品 2-虚拟商品 3-实物贵金属
    ,o.txn_code -- 交易码
    ,o.gross_qtty_amt -- 订单总金额
    ,o.gross_qtty_points -- 订单总积分
    ,o.points_type -- 订单积分类型
    ,o.entitlement_point -- 订单权益积分
    ,o.rem_amt -- 剩余可用金额
    ,o.rem_points -- 剩余可用积分
    ,o.rem_entitlement_point -- 剩余可用权益积分
    ,o.txn_status -- 交易状态 01-待支付、02-支付成（退款成功），03-支付失败（退款数币）、06-订单处理中
    ,o.payment_success_date -- 付款成功日期
    ,o.pay_card_num -- 支付卡号
    ,o.open_org_num -- 支付卡开户机构
    ,o.acct_num_name -- 支付卡名称
    ,o.bank_name -- 银行名称
    ,o.exch_brch_no -- 联行号
    ,o.card_type -- 卡类型 1-1类卡 2-2类卡 3-3类卡
    ,o.wthr_check_bal -- 是否检查余额 0否 1是 空否
    ,o.fret_amt -- 运费金额
    ,o.cons_name -- 收货人姓名
    ,o.cons_ceph_num -- 收货人手机号
    ,o.cons_loc_prov -- 收货人所在省
    ,o.cons_loc_city -- 收货人所在市
    ,o.cons_loc_cuty -- 收货人所在县（区）
    ,o.cons_loc_town -- 收货人所在镇
    ,o.cons_dtl_loc -- 收货人详细地址
    ,o.pick_goods_mode -- 提货方式
    ,o.pty_mgr_num -- 银行客户经理号
    ,o.txn_org_num -- 交易机构号
    ,o.orig_order_num -- 原交易订单号
    ,o.orig_trx_dt -- 原订单交易日期
    ,o.srv_resp_code -- 响应码
    ,o.srv_resp_info -- 响应描述
    ,o.merch_num -- 商户号
    ,o.channel_id -- 所属机构
    ,o.cnsm_typ -- 消费类型 1-积分支付、2-现金支付（本代本）、3-福利金支付、4- 权益积分、5-积分+现金、6-福利金+现金、7-权益积分+现金
    ,o.physics_flag -- 物理标识 1-正常 2-删除
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.create_emp -- 创建人
    ,o.update_emp -- 更新人
    ,o.pay_serial_num -- 原交易平台流水号（退款用）
    ,o.pay_order_num -- 原交易订单号（退款用）
    ,o.gross_fjl -- 订单总福利金
    ,o.rem_flj -- 剩余福利金
    ,o.return_flag -- 组合支付回滚标志
    ,o.txn_num -- 交易流水号
    ,o.notify_flag -- 是否通知成功 (0-失败 1-成功)
    ,o.notify_count -- 支付失败通知次数 (通知失败需补偿通知，最多补偿通知 6次，次数累加)
    ,o.ship_status -- 发货状态1：未发货 2：已发货
    ,o.cons_loc_prov_v -- 收货人所在省
    ,o.cons_loc_city_v -- 收货人所在市
    ,o.cons_loc_cuty_v -- 收货人所在县（区）
    ,o.cons_loc_town_v -- 收货人所在镇
    ,o.cons_dtl_loc_v -- 收货人详细地址
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
from ${iol_schema}.amss_points_mall_pay_order_bk o
    left join ${iol_schema}.amss_points_mall_pay_order_op n
        on
            o.serial_num = n.serial_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_points_mall_pay_order_cl d
        on
            o.serial_num = d.serial_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_points_mall_pay_order;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_points_mall_pay_order') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_points_mall_pay_order drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_points_mall_pay_order add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_points_mall_pay_order exchange partition p_${batch_date} with table ${iol_schema}.amss_points_mall_pay_order_cl;
alter table ${iol_schema}.amss_points_mall_pay_order exchange partition p_20991231 with table ${iol_schema}.amss_points_mall_pay_order_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_points_mall_pay_order to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_pay_order_op purge;
drop table ${iol_schema}.amss_points_mall_pay_order_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_points_mall_pay_order_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_points_mall_pay_order',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
