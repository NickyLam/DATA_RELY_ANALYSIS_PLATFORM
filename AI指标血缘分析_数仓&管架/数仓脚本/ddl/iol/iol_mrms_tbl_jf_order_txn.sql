/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_jf_order_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_jf_order_txn
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_jf_order_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_jf_order_txn(
    key_rsp varchar2(48) -- 唯一流水号(聚合支付系统生成)
    ,order_no varchar2(150) -- 交易流水号(调用方上送的流水号)
    ,ogl_ord_id varchar2(48) -- 退货原订单流水号
    ,ogl_ord_date varchar2(12) -- 退货原订单交易日期
    ,inst_date varchar2(12) -- 交易日期
    ,inst_time varchar2(9) -- 交易时间
    ,txn_num varchar2(6) -- 交易码:2301：消费,2302:退款
    ,txn_sta varchar2(3) -- 交易状态
    ,successdate varchar2(12) -- 付款成功日期
    ,successtime varchar2(9) -- 付款成功时间
    ,res_code varchar2(24) -- 响应码0000：交易成功0001：交易失败
    ,res_desc varchar2(768) -- 响应码描述
    ,card_no varchar2(29) -- 支付卡号(不支持大于19位的存折)
    ,card_name varchar2(96) -- 卡名称
    ,open_bk_num varchar2(24) -- 银行联行号(默认本行)
    ,open_bk_name varchar2(192) -- 银行名称
    ,card_type varchar2(15) -- 卡类型,信用卡：credit 储蓄卡：debit
    ,brh_id varchar2(30) -- 收单分行
    ,jf_ppp_key_ih varchar2(48) -- 调用方全局流水号(23位)
    ,tran_seq_no_ih varchar2(48) -- 调用方联机全局流水号(32位)
    ,ship_status varchar2(2) -- 发货状态1：未发货2：已发货
    ,mcht_no varchar2(24) -- 商户号(聚合支付统一分配一个商户号到积分商城那边)
    ,reveiver_name varchar2(96) -- 收货人名称
    ,reveiver_phone varchar2(17) -- 收货人手机号码
    ,reveiver_provice varchar2(48) -- 收货人所在省
    ,reveiver_city varchar2(48) -- 收货人所在市
    ,reveiver_county varchar2(48) -- 收货人所在区(县)
    ,reveiver_town varchar2(48) -- 收货人所在镇
    ,reveiver_addr varchar2(384) -- 收货人详细地址
    ,total_money varchar2(24) -- 订单总金额
    ,trade_type varchar2(2) -- 订单积分类型p:积分,c:现金
    ,total_point varchar2(24) -- 订单总积分
    ,freight_fee varchar2(24) -- 运费金额
    ,create_time varchar2(21) -- 创建时间
    ,update_time varchar2(21) -- 更新时间
    ,adddata1 varchar2(300) -- 附加数据1
    ,adddata2 varchar2(300) -- 附加数据2
    ,pty_id varchar2(30) -- 客户号
    ,pty_name varchar2(300) -- 客户名称
    ,usable_money varchar2(24) -- 剩余可用金额
    ,usable_point varchar2(24) -- 剩余可用积分
    ,pty_rank varchar2(30) -- 客户等级
    ,shop_order_id varchar2(150) -- 积分商城订单号
    ,equity_star varchar2(30) -- 权益星
    ,usable_equity_star varchar2(30) -- 剩余可用权益星
    ,pty_open_org varchar2(48) -- 客户开户机构
    ,cert_num varchar2(48) -- 证件号码
    ,cert_type varchar2(15) -- 证件类型
    ,pty_mgr_num varchar2(48) -- 银行客户经理号
    ,gross_fee varchar2(15) -- 总手续费收入
    ,agent_no varchar2(45) -- 代理商编号
    ,open_org_num varchar2(384) -- 支付卡开户机构
    ,txn_org_num varchar2(96) -- 交易机构号
    ,mrchd_typ varchar2(2) -- 商品类型
    ,pick_goods_mode varchar2(2) -- 提货方式
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
grant select on ${iol_schema}.mrms_tbl_jf_order_txn to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_jf_order_txn to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_jf_order_txn to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_jf_order_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_jf_order_txn is '网上商城订单表';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.key_rsp is '唯一流水号(聚合支付系统生成)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.order_no is '交易流水号(调用方上送的流水号)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.ogl_ord_id is '退货原订单流水号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.ogl_ord_date is '退货原订单交易日期';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.inst_date is '交易日期';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.inst_time is '交易时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.txn_num is '交易码:2301：消费,2302:退款';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.txn_sta is '交易状态';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.successdate is '付款成功日期';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.successtime is '付款成功时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.res_code is '响应码0000：交易成功0001：交易失败';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.res_desc is '响应码描述';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.card_no is '支付卡号(不支持大于19位的存折)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.card_name is '卡名称';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.open_bk_num is '银行联行号(默认本行)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.open_bk_name is '银行名称';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.card_type is '卡类型,信用卡：credit 储蓄卡：debit';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.brh_id is '收单分行';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.jf_ppp_key_ih is '调用方全局流水号(23位)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.tran_seq_no_ih is '调用方联机全局流水号(32位)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.ship_status is '发货状态1：未发货2：已发货';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.mcht_no is '商户号(聚合支付统一分配一个商户号到积分商城那边)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_name is '收货人名称';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_phone is '收货人手机号码';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_provice is '收货人所在省';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_city is '收货人所在市';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_county is '收货人所在区(县)';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_town is '收货人所在镇';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.reveiver_addr is '收货人详细地址';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.total_money is '订单总金额';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.trade_type is '订单积分类型p:积分,c:现金';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.total_point is '订单总积分';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.freight_fee is '运费金额';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.create_time is '创建时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.update_time is '更新时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.adddata1 is '附加数据1';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.adddata2 is '附加数据2';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pty_id is '客户号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pty_name is '客户名称';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.usable_money is '剩余可用金额';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.usable_point is '剩余可用积分';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pty_rank is '客户等级';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.shop_order_id is '积分商城订单号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.equity_star is '权益星';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.usable_equity_star is '剩余可用权益星';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pty_open_org is '客户开户机构';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.cert_num is '证件号码';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.cert_type is '证件类型';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pty_mgr_num is '银行客户经理号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.gross_fee is '总手续费收入';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.agent_no is '代理商编号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.open_org_num is '支付卡开户机构';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.txn_org_num is '交易机构号';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.mrchd_typ is '商品类型';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.pick_goods_mode is '提货方式';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_jf_order_txn.etl_timestamp is 'ETL处理时间戳';
