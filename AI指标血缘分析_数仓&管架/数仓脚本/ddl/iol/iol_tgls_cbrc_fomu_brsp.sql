/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_fomu_brsp
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_fomu_brsp
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_fomu_brsp purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_fomu_brsp(
    subsys number -- 子系统编号
    ,shetcd varchar2(16) -- 报表编码
    ,itemcd varchar2(32) -- 数据项编码
    ,cellid number -- 数据项id
    ,brchno varchar2(12) -- 报送机构编号
    ,varicd varchar2(2048) -- 变量代码
    ,excode varchar2(4000) -- 执行代码
    ,sourtp varchar2(12) -- 变量来源iner:表间item：指标体系modu：数据模型
    ,verson number -- 版本号
    ,stacid number(9) -- 帐套id
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
grant select on ${iol_schema}.tgls_cbrc_fomu_brsp to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_brsp to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_brsp to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_fomu_brsp to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_fomu_brsp is '报送机构报表公式拆分表';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.subsys is '子系统编号';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.shetcd is '报表编码';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.itemcd is '数据项编码';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.cellid is '数据项id';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.brchno is '报送机构编号';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.varicd is '变量代码';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.excode is '执行代码';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.sourtp is '变量来源iner:表间item：指标体系modu：数据模型';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.verson is '版本号';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.stacid is '帐套id';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_fomu_brsp.etl_timestamp is 'ETL处理时间戳';
