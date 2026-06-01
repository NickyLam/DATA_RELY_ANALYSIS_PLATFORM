/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_coupon_cust_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_coupon_cust_txn
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_coupon_cust_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_coupon_cust_txn(
    pk_coupon_used number(20,0) -- 唯一标识,主键
    ,coupon_id varchar2(150) -- 卡券的唯一劵码
    ,deal_type varchar2(24) -- 交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整
    ,deal_status varchar2(3) -- 交易状态 1：成功 0：失败 2:未响应
    ,deal_num number(11,0) -- 交易数量（核销次数、转让次数）
    ,overdue_date varchar2(24) -- 过期时间
    ,used_time varchar2(60) -- 交易时间
    ,exchange_code varchar2(765) -- 卡券兑换码
    ,channel_no varchar2(96) -- 核销渠道
    ,check_id varchar2(300) -- 核销者
    ,txn_code varchar2(192) -- 出账流水号
    ,deal_explain varchar2(4000) -- 交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）
    ,cust_id varchar2(192) -- 客户号
    ,roll_int_cust_id varchar2(60) -- 转入客户号
    ,summary varchar2(4000) -- 摘要
    ,audit_status varchar2(3) -- 审批状态
    ,created_by varchar2(150) -- 创建人
    ,updated_by varchar2(150) -- 修改人
    ,create_time varchar2(60) -- 创建时间戳
    ,update_time varchar2(60) -- 更新时间戳
    ,del_flag number(11,0) -- 逻辑删除标记(0-正常，1-删除)
    ,batch_no varchar2(96) -- 批次号
    ,deal_dir varchar2(3) -- 交易方向(0=减少 1=增加 2=不变=不变)
    ,draw_src varchar2(60) -- 领取来源：HYZX-会员中心
    ,glob_seq varchar2(300) -- 全局流水号
    ,coop_order_seq varchar2(120) -- 第三方交易流水号
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
grant select on ${iol_schema}.pbms_tbl_coupon_cust_txn to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_coupon_cust_txn to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_coupon_cust_txn to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_coupon_cust_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_coupon_cust_txn is '卡券交易记录表';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.pk_coupon_used is '唯一标识,主键';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.coupon_id is '卡券的唯一劵码';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.deal_type is '交易类型 1：核销 2：作废 3：重置 4：赠送 5.转让 6.冲正 7：过期 8：调整';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.deal_status is '交易状态 1：成功 0：失败 2:未响应';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.deal_num is '交易数量（核销次数、转让次数）';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.overdue_date is '过期时间';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.used_time is '交易时间';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.exchange_code is '卡券兑换码';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.channel_no is '核销渠道';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.check_id is '核销者';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.txn_code is '出账流水号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.deal_explain is '交易说明（核销说明、作废原因、重置原因，赠送原因、转让原因）';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.roll_int_cust_id is '转入客户号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.summary is '摘要';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.audit_status is '审批状态';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.created_by is '创建人';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.updated_by is '修改人';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.create_time is '创建时间戳';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.update_time is '更新时间戳';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.del_flag is '逻辑删除标记(0-正常，1-删除)';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.batch_no is '批次号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.deal_dir is '交易方向(0=减少 1=增加 2=不变=不变)';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.draw_src is '领取来源：HYZX-会员中心';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.glob_seq is '全局流水号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.coop_order_seq is '第三方交易流水号';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_coupon_cust_txn.etl_timestamp is 'ETL处理时间戳';
