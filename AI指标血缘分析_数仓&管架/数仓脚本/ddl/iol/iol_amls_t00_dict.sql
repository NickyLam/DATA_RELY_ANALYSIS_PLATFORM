/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t00_dict
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t00_dict
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t00_dict purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t00_dict(
    disctype varchar2(23) -- 类别代码
    ,disctypename varchar2(192) -- 类别名称
    ,disckey varchar2(192) -- 字典代码
    ,discname varchar2(192) -- 字典描述
    ,des varchar2(384) -- 描述
    ,flag varchar2(2) -- 参见[字典:t10001]
    ,dispseq number(10,0) -- 显示序号
    ,applytype varchar2(2) -- 参见[字典:t10082]
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
grant select on ${iol_schema}.amls_t00_dict to ${iml_schema};
grant select on ${iol_schema}.amls_t00_dict to ${icl_schema};
grant select on ${iol_schema}.amls_t00_dict to ${idl_schema};
grant select on ${iol_schema}.amls_t00_dict to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t00_dict is '数据字典表';
comment on column ${iol_schema}.amls_t00_dict.disctype is '类别代码';
comment on column ${iol_schema}.amls_t00_dict.disctypename is '类别名称';
comment on column ${iol_schema}.amls_t00_dict.disckey is '字典代码';
comment on column ${iol_schema}.amls_t00_dict.discname is '字典描述';
comment on column ${iol_schema}.amls_t00_dict.des is '描述';
comment on column ${iol_schema}.amls_t00_dict.flag is '参见[字典:t10001]';
comment on column ${iol_schema}.amls_t00_dict.dispseq is '显示序号';
comment on column ${iol_schema}.amls_t00_dict.applytype is '参见[字典:t10082]';
comment on column ${iol_schema}.amls_t00_dict.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t00_dict.etl_timestamp is 'ETL处理时间戳';
