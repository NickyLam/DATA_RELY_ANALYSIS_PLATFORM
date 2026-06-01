/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mrms_tbl_jf_order_txn
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
create table ${iol_schema}.mrms_tbl_jf_order_txn_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mrms_tbl_jf_order_txn
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jf_order_txn_op purge;
drop table ${iol_schema}.mrms_tbl_jf_order_txn_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jf_order_txn_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jf_order_txn where 0=1;

create table ${iol_schema}.mrms_tbl_jf_order_txn_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mrms_tbl_jf_order_txn where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jf_order_txn_cl(
            key_rsp -- 唯一流水号(聚合支付系统生成)
            ,order_no -- 交易流水号(调用方上送的流水号)
            ,ogl_ord_id -- 退货原订单流水号
            ,ogl_ord_date -- 退货原订单交易日期
            ,inst_date -- 交易日期
            ,inst_time -- 交易时间
            ,txn_num -- 交易码:2301：消费,2302:退款
            ,txn_sta -- 交易状态
            ,successdate -- 付款成功日期
            ,successtime -- 付款成功时间
            ,res_code -- 响应码0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,card_no -- 支付卡号(不支持大于19位的存折)
            ,card_name -- 卡名称
            ,open_bk_num -- 银行联行号(默认本行)
            ,open_bk_name -- 银行名称
            ,card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
            ,brh_id -- 收单分行
            ,jf_ppp_key_ih -- 调用方全局流水号(23位)
            ,tran_seq_no_ih -- 调用方联机全局流水号(32位)
            ,ship_status -- 发货状态1：未发货2：已发货
            ,mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
            ,reveiver_name -- 收货人名称
            ,reveiver_phone -- 收货人手机号码
            ,reveiver_provice -- 收货人所在省
            ,reveiver_city -- 收货人所在市
            ,reveiver_county -- 收货人所在区(县)
            ,reveiver_town -- 收货人所在镇
            ,reveiver_addr -- 收货人详细地址
            ,total_money -- 订单总金额
            ,trade_type -- 订单积分类型P:积分,C:现金
            ,total_point -- 订单总积分
            ,freight_fee -- 运费金额
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,usable_money -- 剩余可用金额
            ,usable_point -- 剩余可用积分
            ,pty_rank -- 客户等级
            ,shop_order_id -- 积分商城订单号
            ,equity_star -- 权益星
            ,usable_equity_star -- 剩余可用权益星
            ,pty_open_org -- 客户开户机构
            ,cert_num -- 证件号码
            ,cert_type -- 证件类型
            ,pty_mgr_num -- 银行客户经理号
            ,gross_fee -- 总手续费收入
            ,agent_no -- 代理商编号
            ,open_org_num -- 支付卡开户机构
            ,txn_org_num -- 交易机构号
            ,mrchd_typ -- 商品类型
            ,pick_goods_mode -- 提货方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jf_order_txn_op(
            key_rsp -- 唯一流水号(聚合支付系统生成)
            ,order_no -- 交易流水号(调用方上送的流水号)
            ,ogl_ord_id -- 退货原订单流水号
            ,ogl_ord_date -- 退货原订单交易日期
            ,inst_date -- 交易日期
            ,inst_time -- 交易时间
            ,txn_num -- 交易码:2301：消费,2302:退款
            ,txn_sta -- 交易状态
            ,successdate -- 付款成功日期
            ,successtime -- 付款成功时间
            ,res_code -- 响应码0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,card_no -- 支付卡号(不支持大于19位的存折)
            ,card_name -- 卡名称
            ,open_bk_num -- 银行联行号(默认本行)
            ,open_bk_name -- 银行名称
            ,card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
            ,brh_id -- 收单分行
            ,jf_ppp_key_ih -- 调用方全局流水号(23位)
            ,tran_seq_no_ih -- 调用方联机全局流水号(32位)
            ,ship_status -- 发货状态1：未发货2：已发货
            ,mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
            ,reveiver_name -- 收货人名称
            ,reveiver_phone -- 收货人手机号码
            ,reveiver_provice -- 收货人所在省
            ,reveiver_city -- 收货人所在市
            ,reveiver_county -- 收货人所在区(县)
            ,reveiver_town -- 收货人所在镇
            ,reveiver_addr -- 收货人详细地址
            ,total_money -- 订单总金额
            ,trade_type -- 订单积分类型P:积分,C:现金
            ,total_point -- 订单总积分
            ,freight_fee -- 运费金额
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,usable_money -- 剩余可用金额
            ,usable_point -- 剩余可用积分
            ,pty_rank -- 客户等级
            ,shop_order_id -- 积分商城订单号
            ,equity_star -- 权益星
            ,usable_equity_star -- 剩余可用权益星
            ,pty_open_org -- 客户开户机构
            ,cert_num -- 证件号码
            ,cert_type -- 证件类型
            ,pty_mgr_num -- 银行客户经理号
            ,gross_fee -- 总手续费收入
            ,agent_no -- 代理商编号
            ,open_org_num -- 支付卡开户机构
            ,txn_org_num -- 交易机构号
            ,mrchd_typ -- 商品类型
            ,pick_goods_mode -- 提货方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.key_rsp, o.key_rsp) as key_rsp -- 唯一流水号(聚合支付系统生成)
    ,nvl(n.order_no, o.order_no) as order_no -- 交易流水号(调用方上送的流水号)
    ,nvl(n.ogl_ord_id, o.ogl_ord_id) as ogl_ord_id -- 退货原订单流水号
    ,nvl(n.ogl_ord_date, o.ogl_ord_date) as ogl_ord_date -- 退货原订单交易日期
    ,nvl(n.inst_date, o.inst_date) as inst_date -- 交易日期
    ,nvl(n.inst_time, o.inst_time) as inst_time -- 交易时间
    ,nvl(n.txn_num, o.txn_num) as txn_num -- 交易码:2301：消费,2302:退款
    ,nvl(n.txn_sta, o.txn_sta) as txn_sta -- 交易状态
    ,nvl(n.successdate, o.successdate) as successdate -- 付款成功日期
    ,nvl(n.successtime, o.successtime) as successtime -- 付款成功时间
    ,nvl(n.res_code, o.res_code) as res_code -- 响应码0000：交易成功0001：交易失败
    ,nvl(n.res_desc, o.res_desc) as res_desc -- 响应码描述
    ,nvl(n.card_no, o.card_no) as card_no -- 支付卡号(不支持大于19位的存折)
    ,nvl(n.card_name, o.card_name) as card_name -- 卡名称
    ,nvl(n.open_bk_num, o.open_bk_num) as open_bk_num -- 银行联行号(默认本行)
    ,nvl(n.open_bk_name, o.open_bk_name) as open_bk_name -- 银行名称
    ,nvl(n.card_type, o.card_type) as card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
    ,nvl(n.brh_id, o.brh_id) as brh_id -- 收单分行
    ,nvl(n.jf_ppp_key_ih, o.jf_ppp_key_ih) as jf_ppp_key_ih -- 调用方全局流水号(23位)
    ,nvl(n.tran_seq_no_ih, o.tran_seq_no_ih) as tran_seq_no_ih -- 调用方联机全局流水号(32位)
    ,nvl(n.ship_status, o.ship_status) as ship_status -- 发货状态1：未发货2：已发货
    ,nvl(n.mcht_no, o.mcht_no) as mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
    ,nvl(n.reveiver_name, o.reveiver_name) as reveiver_name -- 收货人名称
    ,nvl(n.reveiver_phone, o.reveiver_phone) as reveiver_phone -- 收货人手机号码
    ,nvl(n.reveiver_provice, o.reveiver_provice) as reveiver_provice -- 收货人所在省
    ,nvl(n.reveiver_city, o.reveiver_city) as reveiver_city -- 收货人所在市
    ,nvl(n.reveiver_county, o.reveiver_county) as reveiver_county -- 收货人所在区(县)
    ,nvl(n.reveiver_town, o.reveiver_town) as reveiver_town -- 收货人所在镇
    ,nvl(n.reveiver_addr, o.reveiver_addr) as reveiver_addr -- 收货人详细地址
    ,nvl(n.total_money, o.total_money) as total_money -- 订单总金额
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 订单积分类型P:积分,C:现金
    ,nvl(n.total_point, o.total_point) as total_point -- 订单总积分
    ,nvl(n.freight_fee, o.freight_fee) as freight_fee -- 运费金额
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.adddata1, o.adddata1) as adddata1 -- 附加数据1
    ,nvl(n.adddata2, o.adddata2) as adddata2 -- 附加数据2
    ,nvl(n.pty_id, o.pty_id) as pty_id -- 客户号
    ,nvl(n.pty_name, o.pty_name) as pty_name -- 客户名称
    ,nvl(n.usable_money, o.usable_money) as usable_money -- 剩余可用金额
    ,nvl(n.usable_point, o.usable_point) as usable_point -- 剩余可用积分
    ,nvl(n.pty_rank, o.pty_rank) as pty_rank -- 客户等级
    ,nvl(n.shop_order_id, o.shop_order_id) as shop_order_id -- 积分商城订单号
    ,nvl(n.equity_star, o.equity_star) as equity_star -- 权益星
    ,nvl(n.usable_equity_star, o.usable_equity_star) as usable_equity_star -- 剩余可用权益星
    ,nvl(n.pty_open_org, o.pty_open_org) as pty_open_org -- 客户开户机构
    ,nvl(n.cert_num, o.cert_num) as cert_num -- 证件号码
    ,nvl(n.cert_type, o.cert_type) as cert_type -- 证件类型
    ,nvl(n.pty_mgr_num, o.pty_mgr_num) as pty_mgr_num -- 银行客户经理号
    ,nvl(n.gross_fee, o.gross_fee) as gross_fee -- 总手续费收入
    ,nvl(n.agent_no, o.agent_no) as agent_no -- 代理商编号
    ,nvl(n.open_org_num, o.open_org_num) as open_org_num -- 支付卡开户机构
    ,nvl(n.txn_org_num, o.txn_org_num) as txn_org_num -- 交易机构号
    ,nvl(n.mrchd_typ, o.mrchd_typ) as mrchd_typ -- 商品类型
    ,nvl(n.pick_goods_mode, o.pick_goods_mode) as pick_goods_mode -- 提货方式
    ,case when
            n.key_rsp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.key_rsp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.key_rsp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mrms_tbl_jf_order_txn_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mrms_tbl_jf_order_txn where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.key_rsp = n.key_rsp
where (
        o.key_rsp is null
    )
    or (
        n.key_rsp is null
    )
    or (
        o.order_no <> n.order_no
        or o.ogl_ord_id <> n.ogl_ord_id
        or o.ogl_ord_date <> n.ogl_ord_date
        or o.inst_date <> n.inst_date
        or o.inst_time <> n.inst_time
        or o.txn_num <> n.txn_num
        or o.txn_sta <> n.txn_sta
        or o.successdate <> n.successdate
        or o.successtime <> n.successtime
        or o.res_code <> n.res_code
        or o.res_desc <> n.res_desc
        or o.card_no <> n.card_no
        or o.card_name <> n.card_name
        or o.open_bk_num <> n.open_bk_num
        or o.open_bk_name <> n.open_bk_name
        or o.card_type <> n.card_type
        or o.brh_id <> n.brh_id
        or o.jf_ppp_key_ih <> n.jf_ppp_key_ih
        or o.tran_seq_no_ih <> n.tran_seq_no_ih
        or o.ship_status <> n.ship_status
        or o.mcht_no <> n.mcht_no
        or o.reveiver_name <> n.reveiver_name
        or o.reveiver_phone <> n.reveiver_phone
        or o.reveiver_provice <> n.reveiver_provice
        or o.reveiver_city <> n.reveiver_city
        or o.reveiver_county <> n.reveiver_county
        or o.reveiver_town <> n.reveiver_town
        or o.reveiver_addr <> n.reveiver_addr
        or o.total_money <> n.total_money
        or o.trade_type <> n.trade_type
        or o.total_point <> n.total_point
        or o.freight_fee <> n.freight_fee
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.adddata1 <> n.adddata1
        or o.adddata2 <> n.adddata2
        or o.pty_id <> n.pty_id
        or o.pty_name <> n.pty_name
        or o.usable_money <> n.usable_money
        or o.usable_point <> n.usable_point
        or o.pty_rank <> n.pty_rank
        or o.shop_order_id <> n.shop_order_id
        or o.equity_star <> n.equity_star
        or o.usable_equity_star <> n.usable_equity_star
        or o.pty_open_org <> n.pty_open_org
        or o.cert_num <> n.cert_num
        or o.cert_type <> n.cert_type
        or o.pty_mgr_num <> n.pty_mgr_num
        or o.gross_fee <> n.gross_fee
        or o.agent_no <> n.agent_no
        or o.open_org_num <> n.open_org_num
        or o.txn_org_num <> n.txn_org_num
        or o.mrchd_typ <> n.mrchd_typ
        or o.pick_goods_mode <> n.pick_goods_mode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mrms_tbl_jf_order_txn_cl(
            key_rsp -- 唯一流水号(聚合支付系统生成)
            ,order_no -- 交易流水号(调用方上送的流水号)
            ,ogl_ord_id -- 退货原订单流水号
            ,ogl_ord_date -- 退货原订单交易日期
            ,inst_date -- 交易日期
            ,inst_time -- 交易时间
            ,txn_num -- 交易码:2301：消费,2302:退款
            ,txn_sta -- 交易状态
            ,successdate -- 付款成功日期
            ,successtime -- 付款成功时间
            ,res_code -- 响应码0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,card_no -- 支付卡号(不支持大于19位的存折)
            ,card_name -- 卡名称
            ,open_bk_num -- 银行联行号(默认本行)
            ,open_bk_name -- 银行名称
            ,card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
            ,brh_id -- 收单分行
            ,jf_ppp_key_ih -- 调用方全局流水号(23位)
            ,tran_seq_no_ih -- 调用方联机全局流水号(32位)
            ,ship_status -- 发货状态1：未发货2：已发货
            ,mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
            ,reveiver_name -- 收货人名称
            ,reveiver_phone -- 收货人手机号码
            ,reveiver_provice -- 收货人所在省
            ,reveiver_city -- 收货人所在市
            ,reveiver_county -- 收货人所在区(县)
            ,reveiver_town -- 收货人所在镇
            ,reveiver_addr -- 收货人详细地址
            ,total_money -- 订单总金额
            ,trade_type -- 订单积分类型P:积分,C:现金
            ,total_point -- 订单总积分
            ,freight_fee -- 运费金额
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,usable_money -- 剩余可用金额
            ,usable_point -- 剩余可用积分
            ,pty_rank -- 客户等级
            ,shop_order_id -- 积分商城订单号
            ,equity_star -- 权益星
            ,usable_equity_star -- 剩余可用权益星
            ,pty_open_org -- 客户开户机构
            ,cert_num -- 证件号码
            ,cert_type -- 证件类型
            ,pty_mgr_num -- 银行客户经理号
            ,gross_fee -- 总手续费收入
            ,agent_no -- 代理商编号
            ,open_org_num -- 支付卡开户机构
            ,txn_org_num -- 交易机构号
            ,mrchd_typ -- 商品类型
            ,pick_goods_mode -- 提货方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mrms_tbl_jf_order_txn_op(
            key_rsp -- 唯一流水号(聚合支付系统生成)
            ,order_no -- 交易流水号(调用方上送的流水号)
            ,ogl_ord_id -- 退货原订单流水号
            ,ogl_ord_date -- 退货原订单交易日期
            ,inst_date -- 交易日期
            ,inst_time -- 交易时间
            ,txn_num -- 交易码:2301：消费,2302:退款
            ,txn_sta -- 交易状态
            ,successdate -- 付款成功日期
            ,successtime -- 付款成功时间
            ,res_code -- 响应码0000：交易成功0001：交易失败
            ,res_desc -- 响应码描述
            ,card_no -- 支付卡号(不支持大于19位的存折)
            ,card_name -- 卡名称
            ,open_bk_num -- 银行联行号(默认本行)
            ,open_bk_name -- 银行名称
            ,card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
            ,brh_id -- 收单分行
            ,jf_ppp_key_ih -- 调用方全局流水号(23位)
            ,tran_seq_no_ih -- 调用方联机全局流水号(32位)
            ,ship_status -- 发货状态1：未发货2：已发货
            ,mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
            ,reveiver_name -- 收货人名称
            ,reveiver_phone -- 收货人手机号码
            ,reveiver_provice -- 收货人所在省
            ,reveiver_city -- 收货人所在市
            ,reveiver_county -- 收货人所在区(县)
            ,reveiver_town -- 收货人所在镇
            ,reveiver_addr -- 收货人详细地址
            ,total_money -- 订单总金额
            ,trade_type -- 订单积分类型P:积分,C:现金
            ,total_point -- 订单总积分
            ,freight_fee -- 运费金额
            ,create_time -- 创建时间
            ,update_time -- 更新时间
            ,adddata1 -- 附加数据1
            ,adddata2 -- 附加数据2
            ,pty_id -- 客户号
            ,pty_name -- 客户名称
            ,usable_money -- 剩余可用金额
            ,usable_point -- 剩余可用积分
            ,pty_rank -- 客户等级
            ,shop_order_id -- 积分商城订单号
            ,equity_star -- 权益星
            ,usable_equity_star -- 剩余可用权益星
            ,pty_open_org -- 客户开户机构
            ,cert_num -- 证件号码
            ,cert_type -- 证件类型
            ,pty_mgr_num -- 银行客户经理号
            ,gross_fee -- 总手续费收入
            ,agent_no -- 代理商编号
            ,open_org_num -- 支付卡开户机构
            ,txn_org_num -- 交易机构号
            ,mrchd_typ -- 商品类型
            ,pick_goods_mode -- 提货方式
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.key_rsp -- 唯一流水号(聚合支付系统生成)
    ,o.order_no -- 交易流水号(调用方上送的流水号)
    ,o.ogl_ord_id -- 退货原订单流水号
    ,o.ogl_ord_date -- 退货原订单交易日期
    ,o.inst_date -- 交易日期
    ,o.inst_time -- 交易时间
    ,o.txn_num -- 交易码:2301：消费,2302:退款
    ,o.txn_sta -- 交易状态
    ,o.successdate -- 付款成功日期
    ,o.successtime -- 付款成功时间
    ,o.res_code -- 响应码0000：交易成功0001：交易失败
    ,o.res_desc -- 响应码描述
    ,o.card_no -- 支付卡号(不支持大于19位的存折)
    ,o.card_name -- 卡名称
    ,o.open_bk_num -- 银行联行号(默认本行)
    ,o.open_bk_name -- 银行名称
    ,o.card_type -- 卡类型,信用卡：CREDIT 储蓄卡：DEBIT
    ,o.brh_id -- 收单分行
    ,o.jf_ppp_key_ih -- 调用方全局流水号(23位)
    ,o.tran_seq_no_ih -- 调用方联机全局流水号(32位)
    ,o.ship_status -- 发货状态1：未发货2：已发货
    ,o.mcht_no -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
    ,o.reveiver_name -- 收货人名称
    ,o.reveiver_phone -- 收货人手机号码
    ,o.reveiver_provice -- 收货人所在省
    ,o.reveiver_city -- 收货人所在市
    ,o.reveiver_county -- 收货人所在区(县)
    ,o.reveiver_town -- 收货人所在镇
    ,o.reveiver_addr -- 收货人详细地址
    ,o.total_money -- 订单总金额
    ,o.trade_type -- 订单积分类型P:积分,C:现金
    ,o.total_point -- 订单总积分
    ,o.freight_fee -- 运费金额
    ,o.create_time -- 创建时间
    ,o.update_time -- 更新时间
    ,o.adddata1 -- 附加数据1
    ,o.adddata2 -- 附加数据2
    ,o.pty_id -- 客户号
    ,o.pty_name -- 客户名称
    ,o.usable_money -- 剩余可用金额
    ,o.usable_point -- 剩余可用积分
    ,o.pty_rank -- 客户等级
    ,o.shop_order_id -- 积分商城订单号
    ,o.equity_star -- 权益星
    ,o.usable_equity_star -- 剩余可用权益星
    ,o.pty_open_org -- 客户开户机构
    ,o.cert_num -- 证件号码
    ,o.cert_type -- 证件类型
    ,o.pty_mgr_num -- 银行客户经理号
    ,o.gross_fee -- 总手续费收入
    ,o.agent_no -- 代理商编号
    ,o.open_org_num -- 支付卡开户机构
    ,o.txn_org_num -- 交易机构号
    ,o.mrchd_typ -- 商品类型
    ,o.pick_goods_mode -- 提货方式
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
from ${iol_schema}.mrms_tbl_jf_order_txn_bk o
    left join ${iol_schema}.mrms_tbl_jf_order_txn_op n
        on
            o.key_rsp = n.key_rsp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mrms_tbl_jf_order_txn_cl d
        on
            o.key_rsp = d.key_rsp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mrms_tbl_jf_order_txn;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mrms_tbl_jf_order_txn') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mrms_tbl_jf_order_txn drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mrms_tbl_jf_order_txn add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mrms_tbl_jf_order_txn exchange partition p_${batch_date} with table ${iol_schema}.mrms_tbl_jf_order_txn_cl;
alter table ${iol_schema}.mrms_tbl_jf_order_txn exchange partition p_20991231 with table ${iol_schema}.mrms_tbl_jf_order_txn_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mrms_tbl_jf_order_txn to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mrms_tbl_jf_order_txn_op purge;
drop table ${iol_schema}.mrms_tbl_jf_order_txn_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mrms_tbl_jf_order_txn_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mrms_tbl_jf_order_txn',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
