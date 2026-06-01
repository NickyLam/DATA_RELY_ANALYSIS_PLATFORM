/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a51ttrncdmap
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a51ttrncdmap
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a51ttrncdmap purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a51ttrncdmap(
    msgtype varchar2(6) -- 消息类型
    ,fld003 varchar2(9) -- 交易处理码
    ,fld025 varchar2(3) -- 服务点条件码
    ,trncd varchar2(45) -- 内部交易代码
    ,cbstrncd varchar2(9) -- 核心处理码
    ,rsmsgtype varchar2(6) -- 返回消息类型
    ,macfld090 number(1,0) -- 原始数据元
    ,macfld102 number(1,0) -- 账户标识
    ,trnname varchar2(149) -- 交易名称
    ,macfields varchar2(383) -- 参与计算mac的域
    ,rsmacfields varchar2(383) -- 参与计算mac的域
    ,issndrsk varchar2(2) -- 是否送风控系统
    ,isfallbk varchar2(2) -- 是否禁止降级
    ,isstop varchar2(2) -- 是否禁用
    ,memocd varchar2(15) -- 默认摘要码
    ,memo varchar2(384) -- 摘要码名称
    ,dealtype varchar2(15) -- 自助渠道处理方式
    ,transtp varchar2(15) -- 核心交易类型
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
grant select on ${iol_schema}.mpcs_a51ttrncdmap to ${iml_schema};
grant select on ${iol_schema}.mpcs_a51ttrncdmap to ${icl_schema};
grant select on ${iol_schema}.mpcs_a51ttrncdmap to ${idl_schema};
grant select on ${iol_schema}.mpcs_a51ttrncdmap to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a51ttrncdmap is '银联交易代码表';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.msgtype is '消息类型';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.fld003 is '交易处理码';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.fld025 is '服务点条件码';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.trncd is '内部交易代码';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.cbstrncd is '核心处理码';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.rsmsgtype is '返回消息类型';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.macfld090 is '原始数据元';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.macfld102 is '账户标识';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.trnname is '交易名称';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.macfields is '参与计算mac的域';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.rsmacfields is '参与计算mac的域';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.issndrsk is '是否送风控系统';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.isfallbk is '是否禁止降级';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.isstop is '是否禁用';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.memocd is '默认摘要码';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.memo is '摘要码名称';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.dealtype is '自助渠道处理方式';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.transtp is '核心交易类型';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a51ttrncdmap.etl_timestamp is 'ETL处理时间戳';
