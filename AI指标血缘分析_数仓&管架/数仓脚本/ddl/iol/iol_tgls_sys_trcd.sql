/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_trcd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_trcd
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_trcd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_trcd(
    trancd varchar2(20) -- 子交易类别代码
    ,tranna varchar2(50) -- 子交易类别名称
    ,enname varchar2(50) -- 英文名称（目前未使用）
    ,tramcd varchar2(9) -- 借贷/收付标志（目前未使用）
    ,intfcd varchar2(40) -- 输入输出接口代码（目前未使用）
    ,propif varchar2(40) -- 属性接口代码（目前未使用）
    ,relaif varchar2(40) -- 关系接口代码（目前未使用）
    ,desctx varchar2(255) -- 说明
    ,vermod number(19) -- 版本模式
    ,module varchar2(20) -- 业务类型
    ,projcd varchar2(10) -- 项目编号
    ,trprcd varchar2(10) -- 余额类型(核对时)（目前未使用）
    ,demodu varchar2(50) -- 从属模块
    ,condcd varchar2(20) -- 子交易执行条件
    ,demona varchar2(150) -- 从属模块名称
    ,stacid number(19) -- 账套
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
grant select on ${iol_schema}.tgls_sys_trcd to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_trcd to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_trcd to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_trcd to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_trcd is '系统子交易类别字段表';
comment on column ${iol_schema}.tgls_sys_trcd.trancd is '子交易类别代码';
comment on column ${iol_schema}.tgls_sys_trcd.tranna is '子交易类别名称';
comment on column ${iol_schema}.tgls_sys_trcd.enname is '英文名称（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.tramcd is '借贷/收付标志（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.intfcd is '输入输出接口代码（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.propif is '属性接口代码（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.relaif is '关系接口代码（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.desctx is '说明';
comment on column ${iol_schema}.tgls_sys_trcd.vermod is '版本模式';
comment on column ${iol_schema}.tgls_sys_trcd.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_trcd.projcd is '项目编号';
comment on column ${iol_schema}.tgls_sys_trcd.trprcd is '余额类型(核对时)（目前未使用）';
comment on column ${iol_schema}.tgls_sys_trcd.demodu is '从属模块';
comment on column ${iol_schema}.tgls_sys_trcd.condcd is '子交易执行条件';
comment on column ${iol_schema}.tgls_sys_trcd.demona is '从属模块名称';
comment on column ${iol_schema}.tgls_sys_trcd.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_trcd.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_trcd.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_trcd.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_trcd.etl_timestamp is 'ETL处理时间戳';
