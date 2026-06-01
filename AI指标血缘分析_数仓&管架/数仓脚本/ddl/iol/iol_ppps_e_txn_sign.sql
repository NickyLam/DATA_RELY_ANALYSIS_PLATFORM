/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_e_txn_sign
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_e_txn_sign
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_e_txn_sign purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_e_txn_sign(
    id number(11) -- 自增主键
    ,trx_id varchar2(60) -- 交易流水号
    ,issr_id varchar2(14) -- 发起方所属机构编号
    ,trx_dt_tm varchar2(20) -- 交易ISO日期时间
    ,trx_ctgy varchar2(20) -- 交易类别
    ,txn_date varchar2(8) -- 平台交易日期
    ,txn_time varchar2(6) -- 平台交易时间
    ,status varchar2(2) -- 流水状态
    ,instg_id varchar2(120) -- 支付账户所属机构标识
    ,instg_acct_de varchar2(120) -- 签约人支付账户编号
    ,sgn_acct_issr_id varchar2(120) -- 签约人银行账户所属机构标识
    ,sgn_acct_tp varchar2(40) -- 签约人账户类型
    ,sgn_acct_id_de varchar2(120) -- 签约人银行账户号码
    ,sgn_acct_nm_de varchar2(240) -- 签约人银行账户名称
    ,id_tp varchar2(20) -- 签约人证件类型
    ,id_no_de varchar2(60) -- 签约人证件号码
    ,mob_no_de varchar2(24) -- 签约人预留手机号
    ,sgn_acct_lvl varchar2(1) -- 签约人银行账户等级
    ,sms_seq_no varchar2(60) -- 验证序列号
    ,sms_index varchar2(20) -- 验证码索引
    ,cust_no varchar2(20) -- 客户号
    ,biz_sts_cd varchar2(20) -- 业务返回码
    ,biz_sts_desc varchar2(385) -- 业务返回说明
    ,sys_rtn_cd varchar2(10) -- 系统返回码
    ,sys_rtn_desc varchar2(240) -- 系统返回说明
    ,sys_rtn_tm varchar2(20) -- 系统返回时间
    ,insert_time date -- 创建时间
    ,update_time date -- 最后更新时间
    ,remark varchar2(200) -- 备注信息
    ,global_no varchar2(64) -- 全局流水号
    ,mcht_no varchar2(6) -- 渠道编号
    ,lgn_id varchar2(64) -- 受理机构登录账号
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
grant select on ${iol_schema}.ppps_e_txn_sign to ${iml_schema};
grant select on ${iol_schema}.ppps_e_txn_sign to ${icl_schema};
grant select on ${iol_schema}.ppps_e_txn_sign to ${idl_schema};
grant select on ${iol_schema}.ppps_e_txn_sign to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_e_txn_sign is 'EPCC认证签约流水表';
comment on column ${iol_schema}.ppps_e_txn_sign.id is '自增主键';
comment on column ${iol_schema}.ppps_e_txn_sign.trx_id is '交易流水号';
comment on column ${iol_schema}.ppps_e_txn_sign.issr_id is '发起方所属机构编号';
comment on column ${iol_schema}.ppps_e_txn_sign.trx_dt_tm is '交易ISO日期时间';
comment on column ${iol_schema}.ppps_e_txn_sign.trx_ctgy is '交易类别';
comment on column ${iol_schema}.ppps_e_txn_sign.txn_date is '平台交易日期';
comment on column ${iol_schema}.ppps_e_txn_sign.txn_time is '平台交易时间';
comment on column ${iol_schema}.ppps_e_txn_sign.status is '流水状态';
comment on column ${iol_schema}.ppps_e_txn_sign.instg_id is '支付账户所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_sign.instg_acct_de is '签约人支付账户编号';
comment on column ${iol_schema}.ppps_e_txn_sign.sgn_acct_issr_id is '签约人银行账户所属机构标识';
comment on column ${iol_schema}.ppps_e_txn_sign.sgn_acct_tp is '签约人账户类型';
comment on column ${iol_schema}.ppps_e_txn_sign.sgn_acct_id_de is '签约人银行账户号码';
comment on column ${iol_schema}.ppps_e_txn_sign.sgn_acct_nm_de is '签约人银行账户名称';
comment on column ${iol_schema}.ppps_e_txn_sign.id_tp is '签约人证件类型';
comment on column ${iol_schema}.ppps_e_txn_sign.id_no_de is '签约人证件号码';
comment on column ${iol_schema}.ppps_e_txn_sign.mob_no_de is '签约人预留手机号';
comment on column ${iol_schema}.ppps_e_txn_sign.sgn_acct_lvl is '签约人银行账户等级';
comment on column ${iol_schema}.ppps_e_txn_sign.sms_seq_no is '验证序列号';
comment on column ${iol_schema}.ppps_e_txn_sign.sms_index is '验证码索引';
comment on column ${iol_schema}.ppps_e_txn_sign.cust_no is '客户号';
comment on column ${iol_schema}.ppps_e_txn_sign.biz_sts_cd is '业务返回码';
comment on column ${iol_schema}.ppps_e_txn_sign.biz_sts_desc is '业务返回说明';
comment on column ${iol_schema}.ppps_e_txn_sign.sys_rtn_cd is '系统返回码';
comment on column ${iol_schema}.ppps_e_txn_sign.sys_rtn_desc is '系统返回说明';
comment on column ${iol_schema}.ppps_e_txn_sign.sys_rtn_tm is '系统返回时间';
comment on column ${iol_schema}.ppps_e_txn_sign.insert_time is '创建时间';
comment on column ${iol_schema}.ppps_e_txn_sign.update_time is '最后更新时间';
comment on column ${iol_schema}.ppps_e_txn_sign.remark is '备注信息';
comment on column ${iol_schema}.ppps_e_txn_sign.global_no is '全局流水号';
comment on column ${iol_schema}.ppps_e_txn_sign.mcht_no is '渠道编号';
comment on column ${iol_schema}.ppps_e_txn_sign.lgn_id is '受理机构登录账号';
comment on column ${iol_schema}.ppps_e_txn_sign.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_e_txn_sign.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_e_txn_sign.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_e_txn_sign.etl_timestamp is 'ETL处理时间戳';
