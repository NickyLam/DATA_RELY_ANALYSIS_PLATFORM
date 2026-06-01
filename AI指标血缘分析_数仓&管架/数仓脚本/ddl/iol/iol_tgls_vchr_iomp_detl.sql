/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_vchr_iomp_detl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_vchr_iomp_detl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_vchr_iomp_detl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_vchr_iomp_detl(
    module varchar2(20) -- 业务类型
    ,tovacd varchar2(120) -- 目标变量编码
    ,tovana varchar2(360) -- 目标变量名称
    ,ordeid number(3) -- 序号
    ,varitp varchar2(1) -- 目标类型（1固定区域2扩展区域）
    ,fmvacd varchar2(120) -- 来源变量编码
    ,fmvana varchar2(360) -- 来源变量名称
    ,desctx varchar2(255) -- 备注说明
    ,updati date -- 更新时间（目前未使用）
    ,updaid varchar2(20) -- 更新id（目前未使用）
    ,creati date -- 创建时间（目前未使用）
    ,creaid varchar2(20) -- 创建id（目前未使用）
    ,stacid number(19) -- 账套标记
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
grant select on ${iol_schema}.tgls_vchr_iomp_detl to ${iml_schema};
grant select on ${iol_schema}.tgls_vchr_iomp_detl to ${icl_schema};
grant select on ${iol_schema}.tgls_vchr_iomp_detl to ${idl_schema};
grant select on ${iol_schema}.tgls_vchr_iomp_detl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_vchr_iomp_detl is '分录规则映射从表';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.module is '业务类型';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.tovacd is '目标变量编码';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.tovana is '目标变量名称';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.ordeid is '序号';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.varitp is '目标类型（1固定区域2扩展区域）';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.fmvacd is '来源变量编码';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.fmvana is '来源变量名称';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.desctx is '备注说明';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.updati is '更新时间（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.updaid is '更新id（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.creati is '创建时间（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.creaid is '创建id（目前未使用）';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.stacid is '账套标记';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_vchr_iomp_detl.etl_timestamp is 'ETL处理时间戳';
