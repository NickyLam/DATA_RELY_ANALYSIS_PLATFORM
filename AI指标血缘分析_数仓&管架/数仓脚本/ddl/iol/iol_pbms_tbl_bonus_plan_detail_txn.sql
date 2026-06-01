/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pbms_tbl_bonus_plan_detail_txn
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn
whenever sqlerror continue none;
drop table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn(
    pk_bonus_plan_detail_txn number(38,0) -- 主键
    ,ssn varchar2(75) -- 积分权益管理平台交易流水号
    ,ori_order_id varchar2(120) -- 原订单号（只有退货时才有）
    ,glob_seq varchar2(300) -- 全局流水号
    ,order_id varchar2(120) -- 订单号（业务流水号）
    ,txn_chn varchar2(30) -- 交易渠道，源发送通道号
    ,txn_date varchar2(24) -- 交易日期（yyyyMMdd）
    ,txn_time varchar2(24) -- 交易时间（HHmmss）
    ,posting_date varchar2(24) -- 入账日期（yyyyMMdd）
    ,posting_time varchar2(24) -- 入账时间（HHmmss）
    ,txn_type varchar2(6) -- 1：获赠2：消费3：到期 4：手工调整、5:退货
    ,biz_typ varchar2(30) -- 业务类型，如0001：网上商城，0002：刷卡
    ,summary varchar2(1800) -- 摘要，显示给用户
    ,memo_info varchar2(4000) -- 备注，仅显示在系统页面
    ,txn_code varchar2(96) -- 交易码
    ,txn_desc varchar2(2400) -- 交易描述
    ,cnsn_arti_id varchar2(60) -- 消费者编码
    ,usage_key varchar2(12) -- 权益用途key
    ,ext_coulmn3 varchar2(300) -- 预留字段3
    ,ext_coulmn2 varchar2(300) -- 预留字段2
    ,ext_coulmn1 varchar2(300) -- 预留字段1
    ,cust_id varchar2(150) -- 客户号
    ,org_id varchar2(60) -- 机构
    ,bonus_sub_type varchar2(60) -- 积分二级分类
    ,valid_date varchar2(24) -- 有效期（yyyyMMdd）
    ,bonus_plan_type varchar2(6) -- 积分来源，权益层级：x
    ,txn_amount number(17,2) -- 交易金额
    ,txn_bonus number(14,0) -- 交易积分
    ,bonus_cd_flag varchar2(3) -- 交易方向，1-增加 0-减少
    ,return_flag varchar2(3) -- 冲正标志，0-正常 1-待冲正
    ,batch_id varchar2(60) -- 批次号
    ,rule_id varchar2(150) -- 赠送规则编号
    ,rule_name varchar2(150) -- 赠送规则名称
    ,created_by varchar2(60) -- 创建人，系统创建写system
    ,create_time varchar2(60) -- 创建时间
    ,updated_by varchar2(60) -- 更新人，系统创建写system
    ,update_time varchar2(60) -- 更新时间
    ,del_flag number(22,0) -- 逻辑删除标志（0-正常，1-删除）
    ,rema_usab_bonus number(14,2) -- 交易后可用积分余额
    ,jrnl_no varchar2(27) -- 卡系统流水号
    ,tran_seq_no_uuid varchar2(300) -- 聚合支付流水号
    ,card_no varchar2(60) -- 卡号
    ,txn_status varchar2(3) -- 交易状态
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_txn to ${iml_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_txn to ${icl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_txn to ${idl_schema};
grant select on ${iol_schema}.pbms_tbl_bonus_plan_detail_txn to ${iel_schema};

-- comment
comment on table ${iol_schema}.pbms_tbl_bonus_plan_detail_txn is '客户分账交易明细表';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.pk_bonus_plan_detail_txn is '主键';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.ssn is '积分权益管理平台交易流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.ori_order_id is '原订单号（只有退货时才有）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.glob_seq is '全局流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.order_id is '订单号（业务流水号）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_chn is '交易渠道，源发送通道号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_date is '交易日期（yyyyMMdd）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_time is '交易时间（HHmmss）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.posting_date is '入账日期（yyyyMMdd）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.posting_time is '入账时间（HHmmss）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_type is '1：获赠2：消费3：到期 4：手工调整、5:退货';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.biz_typ is '业务类型，如0001：网上商城，0002：刷卡';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.summary is '摘要，显示给用户';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.memo_info is '备注，仅显示在系统页面';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_code is '交易码';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_desc is '交易描述';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.cnsn_arti_id is '消费者编码';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.usage_key is '权益用途key';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.ext_coulmn3 is '预留字段3';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.ext_coulmn2 is '预留字段2';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.ext_coulmn1 is '预留字段1';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.cust_id is '客户号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.org_id is '机构';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.bonus_sub_type is '积分二级分类';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.valid_date is '有效期（yyyyMMdd）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.bonus_plan_type is '积分来源，权益层级：x';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_amount is '交易金额';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_bonus is '交易积分';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.bonus_cd_flag is '交易方向，1-增加 0-减少';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.return_flag is '冲正标志，0-正常 1-待冲正';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.batch_id is '批次号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.rule_id is '赠送规则编号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.rule_name is '赠送规则名称';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.created_by is '创建人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.create_time is '创建时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.updated_by is '更新人，系统创建写system';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.update_time is '更新时间';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.del_flag is '逻辑删除标志（0-正常，1-删除）';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.rema_usab_bonus is '交易后可用积分余额';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.jrnl_no is '卡系统流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.tran_seq_no_uuid is '聚合支付流水号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.card_no is '卡号';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.txn_status is '交易状态';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pbms_tbl_bonus_plan_detail_txn.etl_timestamp is 'ETL处理时间戳';
