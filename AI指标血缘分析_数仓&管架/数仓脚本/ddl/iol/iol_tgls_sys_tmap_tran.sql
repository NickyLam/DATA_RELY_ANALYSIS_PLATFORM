/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_tmap_tran
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_tmap_tran
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_tmap_tran purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_tmap_tran(
    prcscd varchar2(20) -- 交易场景代码
    ,dttrcd varchar2(30) -- 子交易代码
    ,trtlno number -- 子交易序号
    ,sortno number -- 规则序号
    ,condcd varchar2(20) -- 子交易执行条件
    ,beanid varchar2(30) -- 处理规则
    ,profid varchar2(20) -- 目标变量
    ,fildcd varchar2(45) -- 来源变量
    ,mpcdin varchar2(100) -- 输入映射代码串（目前未使用）
    ,mpcdot varchar2(100) -- 输出映射代码串（目前未使用）
    ,nulflg varchar2(1) -- 非空标识（目前未使用）
    ,desctx varchar2(255) -- 描述
    ,vermod number(19) -- 版本号
    ,module varchar2(20) -- 业务类型
    ,projcd varchar2(10) -- 项目
    ,stacid number(9) -- 账套
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
grant select on ${iol_schema}.tgls_sys_tmap_tran to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_tmap_tran to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_tmap_tran to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_tmap_tran to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_tmap_tran is '引擎数据加工配置表';
comment on column ${iol_schema}.tgls_sys_tmap_tran.prcscd is '交易场景代码';
comment on column ${iol_schema}.tgls_sys_tmap_tran.dttrcd is '子交易代码';
comment on column ${iol_schema}.tgls_sys_tmap_tran.trtlno is '子交易序号';
comment on column ${iol_schema}.tgls_sys_tmap_tran.sortno is '规则序号';
comment on column ${iol_schema}.tgls_sys_tmap_tran.condcd is '子交易执行条件';
comment on column ${iol_schema}.tgls_sys_tmap_tran.beanid is '处理规则';
comment on column ${iol_schema}.tgls_sys_tmap_tran.profid is '目标变量';
comment on column ${iol_schema}.tgls_sys_tmap_tran.fildcd is '来源变量';
comment on column ${iol_schema}.tgls_sys_tmap_tran.mpcdin is '输入映射代码串（目前未使用）';
comment on column ${iol_schema}.tgls_sys_tmap_tran.mpcdot is '输出映射代码串（目前未使用）';
comment on column ${iol_schema}.tgls_sys_tmap_tran.nulflg is '非空标识（目前未使用）';
comment on column ${iol_schema}.tgls_sys_tmap_tran.desctx is '描述';
comment on column ${iol_schema}.tgls_sys_tmap_tran.vermod is '版本号';
comment on column ${iol_schema}.tgls_sys_tmap_tran.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_tmap_tran.projcd is '项目';
comment on column ${iol_schema}.tgls_sys_tmap_tran.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_tmap_tran.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_tmap_tran.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_tmap_tran.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_tmap_tran.etl_timestamp is 'ETL处理时间戳';
