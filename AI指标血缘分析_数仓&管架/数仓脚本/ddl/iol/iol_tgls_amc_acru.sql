/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_acru
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_acru
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_acru purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_acru(
    acruid number(9) -- 会计规则表主键
    ,stacid number(19) -- 账套标记
    ,busicd varchar2(20) -- 业务类型，取值参考数据字典业务类型
    ,prducd varchar2(12) -- 产品编号
    ,trancd varchar2(20) -- 子交易
    ,acelto varchar2(16) -- 目标要素
    ,sortno number -- 执行顺序
    ,status varchar2(1) -- 是否启用，是为y，否为n
    ,condit varchar2(1000) -- 限定条件
    ,formul varchar2(1000) -- 取数公式
    ,groutp varchar2(20) -- 多行分组
    ,measno varchar2(20) -- 计量规则标号
    ,condna varchar2(1000) -- 限定条件名称
    ,formna varchar2(1000) -- 取数公式名称
    ,remark varchar2(1000) -- 规则说明
    ,condsm varchar2(1000) -- 取数条件说明
    ,formsm varchar2(1000) -- 取数公式说明
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
grant select on ${iol_schema}.tgls_amc_acru to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_acru to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_acru to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_acru to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_acru is '会计规则表';
comment on column ${iol_schema}.tgls_amc_acru.acruid is '会计规则表主键';
comment on column ${iol_schema}.tgls_amc_acru.stacid is '账套标记';
comment on column ${iol_schema}.tgls_amc_acru.busicd is '业务类型，取值参考数据字典业务类型';
comment on column ${iol_schema}.tgls_amc_acru.prducd is '产品编号';
comment on column ${iol_schema}.tgls_amc_acru.trancd is '子交易';
comment on column ${iol_schema}.tgls_amc_acru.acelto is '目标要素';
comment on column ${iol_schema}.tgls_amc_acru.sortno is '执行顺序';
comment on column ${iol_schema}.tgls_amc_acru.status is '是否启用，是为y，否为n';
comment on column ${iol_schema}.tgls_amc_acru.condit is '限定条件';
comment on column ${iol_schema}.tgls_amc_acru.formul is '取数公式';
comment on column ${iol_schema}.tgls_amc_acru.groutp is '多行分组';
comment on column ${iol_schema}.tgls_amc_acru.measno is '计量规则标号';
comment on column ${iol_schema}.tgls_amc_acru.condna is '限定条件名称';
comment on column ${iol_schema}.tgls_amc_acru.formna is '取数公式名称';
comment on column ${iol_schema}.tgls_amc_acru.remark is '规则说明';
comment on column ${iol_schema}.tgls_amc_acru.condsm is '取数条件说明';
comment on column ${iol_schema}.tgls_amc_acru.formsm is '取数公式说明';
comment on column ${iol_schema}.tgls_amc_acru.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_acru.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_acru.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_acru.etl_timestamp is 'ETL处理时间戳';
