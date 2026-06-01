/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_points_mall_mrchd_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_points_mall_mrchd_detail
whenever sqlerror continue none;
drop table ${iol_schema}.amss_points_mall_mrchd_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_mrchd_detail(
    id varchar2(32) -- 主键
    ,serial_num varchar2(32) -- 订单主键
    ,mrchd_id varchar2(32) -- 商品信息ID
    ,mrchd_price number(10,2) -- 单个商品价值
    ,cnsm_typ varchar2(32) -- 消费类型 P-积分 C-现金 F-福利金 X-权益积分
    ,physics_flag number(1) -- 物理标识 1-正常 2-删除
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,create_emp varchar2(32) -- 创建人
    ,update_emp varchar2(32) -- 更新人
    ,undo_refund_flag varchar2(1) -- 退货专用字段 0：未退货    2：已退货
    ,order_no varchar2(120) -- 渠道方订单流水
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
grant select on ${iol_schema}.amss_points_mall_mrchd_detail to ${iml_schema};
grant select on ${iol_schema}.amss_points_mall_mrchd_detail to ${icl_schema};
grant select on ${iol_schema}.amss_points_mall_mrchd_detail to ${idl_schema};
grant select on ${iol_schema}.amss_points_mall_mrchd_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_points_mall_mrchd_detail is '积分商城-交易商品明细表';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.id is '主键';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.serial_num is '订单主键';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.mrchd_id is '商品信息ID';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.mrchd_price is '单个商品价值';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.cnsm_typ is '消费类型 P-积分 C-现金 F-福利金 X-权益积分';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.physics_flag is '物理标识 1-正常 2-删除';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.create_time is '创建时间';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.update_time is '更新时间';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.create_emp is '创建人';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.update_emp is '更新人';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.undo_refund_flag is '退货专用字段 0：未退货    2：已退货';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.order_no is '渠道方订单流水';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.start_dt is '开始时间';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.end_dt is '结束时间';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.id_mark is '增删标志';
comment on column ${iol_schema}.amss_points_mall_mrchd_detail.etl_timestamp is 'ETL处理时间戳';
