/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_bonus_plan_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_bonus_plan_txn
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_bonus_plan_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan_txn(
    pk_bonus_plan_txn number(38,0) -- 主键
    ,ssn varchar2(75) -- 积分权益管理平台交易流水号
    ,ori_order_id varchar2(99) -- 原订单号（只有退货时才有）
    ,glob_seq varchar2(99) -- 全局流水号
    ,order_id varchar2(120) -- 订单号（业务流水号）
    ,txn_chn varchar2(30) -- 交易渠道，源发送通道号
    ,txn_date varchar2(24) -- 交易日期（yyyyMMdd）
    ,txn_time varchar2(24) -- 交易时间（HHmmss）
    ,posting_date varchar2(24) -- 入账日期（yyyyMMdd）
    ,posting_time varchar2(24) -- 入账时间（HHmmss）
    ,txn_type varchar2(6) -- 交易类型1：获赠2：消费3：到期 4：手工调整、5:退货
    ,biz_typ varchar2(30) -- 业务类型，如0001：网上商城，0002：刷卡
    ,summary varchar2(1200) -- 摘要，显示给用户
    ,memo_info varchar2(3000) -- 备注，仅显示在系统页面
    ,txn_code varchar2(96) -- 交易码
    ,txn_desc varchar2(2400) -- 交易描述
    ,cnsn_arti_id varchar2(60) -- 消费品编码
    ,usage_key varchar2(12) -- 权益用途key
    ,ext_coulmn3 varchar2(300) -- 预留字段3
    ,ext_coulmn2 varchar2(300) -- 预留字段2
    ,ext_coulmn1 varchar2(300) -- 预留字段1
    ,cust_id varchar2(90) -- 客户号
    ,bonus_plan_type varchar2(6) -- 积分来源，权益层级：x
    ,txn_bonus number(14,0) -- 交易积分
    ,bonus_cd_flag varchar2(3) -- 交易方向，1-增加 0-减少
    ,return_flag varchar2(3) -- 冲正标志，0-正常 1-待冲正
    ,batch_id varchar2(60) -- 批次号
    ,created_by varchar2(60) -- 创建人，系统创建写system
    ,create_time varchar2(60) -- 创建时间
    ,updated_by varchar2(60) -- 更新人，系统创建写system
    ,update_time varchar2(60) -- 更新时间
    ,del_flag number(22,0) -- 逻辑删除标志（0-正常，1-删除）
    ,card_no varchar2(60) -- 卡号
    ,rema_useb_bonus number(14,0) -- 交易后可用积分余额
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
grant select on ${iol_schema}.pbms_tbl_bonus_plan_txn to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_txn to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_txn to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_bonus_plan_txn is '客户总账交易明细表';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.pk_bonus_plan_txn is '主键';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.ssn is '积分权益管理平台交易流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.ori_order_id is '原订单号（只有退货时才有）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.glob_seq is '全局流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.order_id is '订单号（业务流水号）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_chn is '交易渠道，源发送通道号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_date is '交易日期（yyyyMMdd）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_time is '交易时间（HHmmss）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.posting_date is '入账日期（yyyyMMdd）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.posting_time is '入账时间（HHmmss）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_type is '交易类型1：获赠2：消费3：到期 4：手工调整、5:退货';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.biz_typ is '业务类型，如0001：网上商城，0002：刷卡';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.summary is '摘要，显示给用户';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.memo_info is '备注，仅显示在系统页面';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_code is '交易码';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_desc is '交易描述';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.cnsn_arti_id is '消费品编码';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.usage_key is '权益用途key';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.ext_coulmn3 is '预留字段3';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.ext_coulmn2 is '预留字段2';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.ext_coulmn1 is '预留字段1';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.bonus_plan_type is '积分来源，权益层级：x';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.txn_bonus is '交易积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.bonus_cd_flag is '交易方向，1-增加 0-减少';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.return_flag is '冲正标志，0-正常 1-待冲正';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.batch_id is '批次号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.created_by is '创建人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.updated_by is '更新人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.update_time is '更新时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.del_flag is '逻辑删除标志（0-正常，1-删除）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.card_no is '卡号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.rema_useb_bonus is '交易后可用积分余额';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.start_dt is '开始时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.end_dt is '结束时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.id_mark is '增删标志';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_txn.etl_timestamp is 'ETL处理时间戳';
