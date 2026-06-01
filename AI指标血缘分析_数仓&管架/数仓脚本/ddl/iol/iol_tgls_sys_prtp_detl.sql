/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_prtp_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_prtp_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_prtp_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_prtp_detl(
    prgptp varchar2(30) -- 属性组类型代码
    ,propcd varchar2(30) -- 属性代码
    ,nulflg varchar2(1) -- 允许非空标志（目前未使用）
    ,desctx varchar2(255) -- 属性名称
    ,vermod number(19) -- 版本模式
    ,module varchar2(20) -- 业务类型
    ,projcd varchar2(10) -- 项目编号
    ,smrytx varchar2(255) -- 属性说明
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
grant select on ${iol_schema}.tgls_sys_prtp_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_prtp_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_prtp_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_prtp_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_prtp_detl is '系统属性组类型明细定义表';
comment on column ${iol_schema}.tgls_sys_prtp_detl.prgptp is '属性组类型代码';
comment on column ${iol_schema}.tgls_sys_prtp_detl.propcd is '属性代码';
comment on column ${iol_schema}.tgls_sys_prtp_detl.nulflg is '允许非空标志（目前未使用）';
comment on column ${iol_schema}.tgls_sys_prtp_detl.desctx is '属性名称';
comment on column ${iol_schema}.tgls_sys_prtp_detl.vermod is '版本模式';
comment on column ${iol_schema}.tgls_sys_prtp_detl.module is '业务类型';
comment on column ${iol_schema}.tgls_sys_prtp_detl.projcd is '项目编号';
comment on column ${iol_schema}.tgls_sys_prtp_detl.smrytx is '属性说明';
comment on column ${iol_schema}.tgls_sys_prtp_detl.stacid is '账套';
comment on column ${iol_schema}.tgls_sys_prtp_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_sys_prtp_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_sys_prtp_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_sys_prtp_detl.etl_timestamp is 'ETL处理时间戳';
