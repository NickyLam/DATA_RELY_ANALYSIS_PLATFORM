/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mrms_tbl_product_sub_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mrms_tbl_product_sub_info
whenever sqlerror continue none;
drop table ${iol_schema}.mrms_tbl_product_sub_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mrms_tbl_product_sub_info(
    id varchar2(48) -- id
    ,key_rsp varchar2(48) -- 关联流水号(积分商城登记流水表的主键)
    ,product_no varchar2(48) -- 商品编号
    ,product_nm varchar2(192) -- 商品名称
    ,product_num varchar2(24) -- 商品总数量
    ,trade_money varchar2(24) -- 对应商品总金额
    ,trade_type varchar2(2) -- 交易类型
    ,trade_point varchar2(24) -- 对应商品总积分
    ,undo_refund_flag varchar2(2) -- 退货专用字段 0：未退货    2：已退货
    ,create_time varchar2(21) -- 创建时间
    ,update_time varchar2(21) -- 更新时间
    ,adddata1 varchar2(300) -- 附加数据1
    ,adddata2 varchar2(300) -- 附加数据2
    ,product_desc varchar2(768) -- 商品描述信息
    ,order_no varchar2(150) -- 外部订单号(渠道方流水号)
    ,txn_sta varchar2(6) -- 订单状态
    ,equity_star varchar2(30) -- 权益星
    ,provi_name varchar2(300) -- 供应商名称
    ,form_mrchd_fee varchar2(15) -- 单个商品手续费
    ,product_type varchar2(15) -- 商品类型(1、实体商品2、虚拟商品3、实物贵金属)
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
grant select on ${iol_schema}.mrms_tbl_product_sub_info to ${iml_schema};
grant select on ${iol_schema}.mrms_tbl_product_sub_info to ${icl_schema};
grant select on ${iol_schema}.mrms_tbl_product_sub_info to ${idl_schema};
grant select on ${iol_schema}.mrms_tbl_product_sub_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.mrms_tbl_product_sub_info is '网上商城商品子订单表';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.id is 'id';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.key_rsp is '关联流水号(积分商城登记流水表的主键)';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.product_no is '商品编号';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.product_nm is '商品名称';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.product_num is '商品总数量';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.trade_money is '对应商品总金额';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.trade_type is '交易类型';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.trade_point is '对应商品总积分';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.undo_refund_flag is '退货专用字段 0：未退货    2：已退货';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.create_time is '创建时间';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.update_time is '更新时间';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.adddata1 is '附加数据1';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.adddata2 is '附加数据2';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.product_desc is '商品描述信息';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.order_no is '外部订单号(渠道方流水号)';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.txn_sta is '订单状态';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.equity_star is '权益星';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.provi_name is '供应商名称';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.form_mrchd_fee is '单个商品手续费';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.product_type is '商品类型(1、实体商品2、虚拟商品3、实物贵金属)';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.start_dt is '开始时间';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.end_dt is '结束时间';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.id_mark is '增删标志';
comment on column ${iol_schema}.mrms_tbl_product_sub_info.etl_timestamp is 'ETL处理时间戳';
