/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a71tfsbacct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a71tfsbacct
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a71tfsbacct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a71tfsbacct(
    jshacctno varchar2(45) -- 结算账号
    ,jshacctname varchar2(384) -- 结算户名
    ,bzjacctno varchar2(45) -- 保证金账户
    ,times varchar2(8) -- 子户个数
    ,ordernum varchar2(3) -- 同一结算户下保证金账户序号
    ,flag varchar2(2) -- 是否允许建立子户标志：0-不允许 1-允许
    ,bzjaccnum varchar2(3) -- 同一结算户下保证金账户个数
    ,dtitcd varchar2(30) -- 核算科目
    ,magebrn varchar2(12) -- 开户机构
    ,status varchar2(2) -- 状态 0失效 1生效
    ,instdttm varchar2(384) -- 入库时间
    ,prezzhacct varchar2(8) -- 随机子账户前缀
    ,projname varchar2(150) -- 项目名称
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
grant select on ${iol_schema}.mpcs_a71tfsbacct to ${iml_schema};
grant select on ${iol_schema}.mpcs_a71tfsbacct to ${icl_schema};
grant select on ${iol_schema}.mpcs_a71tfsbacct to ${idl_schema};
grant select on ${iol_schema}.mpcs_a71tfsbacct to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a71tfsbacct is 'fsbzj保证金账户配置表';
comment on column ${iol_schema}.mpcs_a71tfsbacct.jshacctno is '结算账号';
comment on column ${iol_schema}.mpcs_a71tfsbacct.jshacctname is '结算户名';
comment on column ${iol_schema}.mpcs_a71tfsbacct.bzjacctno is '保证金账户';
comment on column ${iol_schema}.mpcs_a71tfsbacct.times is '子户个数';
comment on column ${iol_schema}.mpcs_a71tfsbacct.ordernum is '同一结算户下保证金账户序号';
comment on column ${iol_schema}.mpcs_a71tfsbacct.flag is '是否允许建立子户标志：0-不允许 1-允许';
comment on column ${iol_schema}.mpcs_a71tfsbacct.bzjaccnum is '同一结算户下保证金账户个数';
comment on column ${iol_schema}.mpcs_a71tfsbacct.dtitcd is '核算科目';
comment on column ${iol_schema}.mpcs_a71tfsbacct.magebrn is '开户机构';
comment on column ${iol_schema}.mpcs_a71tfsbacct.status is '状态 0失效 1生效';
comment on column ${iol_schema}.mpcs_a71tfsbacct.instdttm is '入库时间';
comment on column ${iol_schema}.mpcs_a71tfsbacct.prezzhacct is '随机子账户前缀';
comment on column ${iol_schema}.mpcs_a71tfsbacct.projname is '项目名称';
comment on column ${iol_schema}.mpcs_a71tfsbacct.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a71tfsbacct.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a71tfsbacct.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a71tfsbacct.etl_timestamp is 'ETL处理时间戳';
