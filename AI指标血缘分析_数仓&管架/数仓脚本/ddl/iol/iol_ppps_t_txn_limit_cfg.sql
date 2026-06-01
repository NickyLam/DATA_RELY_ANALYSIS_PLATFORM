/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_txn_limit_cfg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_txn_limit_cfg
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_txn_limit_cfg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_limit_cfg(
    id number -- 自增主键
    ,mcht_no varchar2(30) -- 渠道编号
    ,limit_agreement_id varchar2(64) -- 限额协议号
    ,limit_template_id varchar2(60) -- 限额类型
    ,limit_object_type varchar2(30) -- 限额对象类型（customer：客户；account：账户）
    ,limit_object_id varchar2(60) -- 限额对像id
    ,agreement_id varchar2(60) -- 协议编号（第三方协议号）
    ,start_date varchar2(8) -- 限额生效日期
    ,end_date varchar2(8) -- 限额失效日期
    ,status varchar2(30) -- 生效状态（effect-已生效；expire-已失效）
    ,remark varchar2(128) -- 备注信息
    ,create_time date -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
    ,update_time date -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
    ,is_default varchar2(1) -- y:属于系统默认签约记录,n:属于客户主动签约记录
    ,industry varchar2(20) -- 客户所属行业,目前仅深圳大额限额类型客户记录和使用
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
grant select on ${iol_schema}.ppps_t_txn_limit_cfg to ${iml_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_cfg to ${icl_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_cfg to ${idl_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_cfg to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_txn_limit_cfg is '客户限额配置信息表';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.id is '自增主键';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.mcht_no is '渠道编号';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.limit_agreement_id is '限额协议号';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.limit_template_id is '限额类型';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.limit_object_type is '限额对象类型（customer：客户；account：账户）';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.limit_object_id is '限额对像id';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.agreement_id is '协议编号（第三方协议号）';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.start_date is '限额生效日期';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.end_date is '限额失效日期';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.status is '生效状态（effect-已生效；expire-已失效）';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.remark is '备注信息';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.create_time is '流水创建时间，格式：yyyy-mm-dd hh:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.update_time is '流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.is_default is 'y:属于系统默认签约记录,n:属于客户主动签约记录';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.industry is '客户所属行业,目前仅深圳大额限额类型客户记录和使用';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_t_txn_limit_cfg.etl_timestamp is 'ETL处理时间戳';
