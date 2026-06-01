/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_t_txn_limit_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_t_txn_limit_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_t_txn_limit_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_t_txn_limit_detail(
    id number(22) -- 自增主键
    ,limit_agreement_id varchar2(64) -- 限额协议号
    ,limit_object_id varchar2(60) -- 限额对像id
    ,limit_template_item varchar2(60) -- 限制模板选项
    ,item_value varchar2(60) -- 限制类型值
    ,remark varchar2(128) -- 备注信息
    ,create_time date -- 流水创建时间，格式：yyyy-mm-dd hh:mm:ss
    ,update_time date -- 流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss
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
grant select on ${iol_schema}.ppps_t_txn_limit_detail to ${iml_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_detail to ${icl_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_detail to ${idl_schema};
grant select on ${iol_schema}.ppps_t_txn_limit_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_t_txn_limit_detail is '客户限额配置明细表';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.id is '自增主键';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.limit_agreement_id is '限额协议号';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.limit_object_id is '限额对像id';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.limit_template_item is '限制模板选项';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.item_value is '限制类型值';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.remark is '备注信息';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.create_time is '流水创建时间，格式：yyyy-mm-dd hh:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.update_time is '流水最后更新时间，格式：yyyy-mm-dd hh:mm:ss';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_t_txn_limit_detail.etl_timestamp is 'ETL处理时间戳';
