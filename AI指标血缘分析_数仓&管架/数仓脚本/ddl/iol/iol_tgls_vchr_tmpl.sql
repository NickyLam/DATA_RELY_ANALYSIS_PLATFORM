/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_vchr_tmpl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_vchr_tmpl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_vchr_tmpl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_vchr_tmpl(
    varicd varchar2(120) -- 变量编码
    ,varitp varchar2(1) -- 变量类型(1固定区域2多维区域)
    ,ordeid number(3) -- 序号
    ,busina varchar2(360) -- 业务名称
    ,desctx varchar2(255) -- 字段说明
    ,updati date -- 更新时间（目前未使用）
    ,updaid varchar2(20) -- 分片代码（目前未使用）
    ,creati date -- 更新人代码（目前未使用）
    ,creaid varchar2(20) -- 创建人代码（目前未使用）
    ,stacid number(19) -- 账套标记
    ,detner varchar2(20) -- 弹性限定词
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
grant select on ${iol_schema}.tgls_vchr_tmpl to ${iml_schema};
grant select on ${iol_schema}.tgls_vchr_tmpl to ${icl_schema};
grant select on ${iol_schema}.tgls_vchr_tmpl to ${idl_schema};
grant select on ${iol_schema}.tgls_vchr_tmpl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_vchr_tmpl is '多维分录模板结构';
comment on column ${iol_schema}.tgls_vchr_tmpl.varicd is '变量编码';
comment on column ${iol_schema}.tgls_vchr_tmpl.varitp is '变量类型(1固定区域2多维区域)';
comment on column ${iol_schema}.tgls_vchr_tmpl.ordeid is '序号';
comment on column ${iol_schema}.tgls_vchr_tmpl.busina is '业务名称';
comment on column ${iol_schema}.tgls_vchr_tmpl.desctx is '字段说明';
comment on column ${iol_schema}.tgls_vchr_tmpl.updati is '更新时间（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_tmpl.updaid is '分片代码（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_tmpl.creati is '更新人代码（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_tmpl.creaid is '创建人代码（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_tmpl.stacid is '账套标记';
comment on column ${iol_schema}.tgls_vchr_tmpl.detner is '弹性限定词';
comment on column ${iol_schema}.tgls_vchr_tmpl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_vchr_tmpl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_vchr_tmpl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_vchr_tmpl.etl_timestamp is 'ETL处理时间戳';
