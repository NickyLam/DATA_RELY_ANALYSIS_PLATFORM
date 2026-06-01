/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_pfp_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_pfp_conf
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_pfp_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_pfp_conf(
    stacid number(19) -- 账套
    ,brchcd varchar2(20) -- 处理对象
    ,orderi number -- 结转顺序
    ,tobrch varchar2(12) -- 对方机构编号
    ,totype varchar2(1) -- 0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划
    ,brchit varchar2(30) -- 被上划机构的中间科目编号（清算科目）
    ,clbrit varchar2(30) -- 上划机构的中间科目编号（清算科目）
    ,smrytx varchar2(50) -- 备注
    ,acctmd varchar2(4) -- 记账方式
    ,usditem varchar2(30) -- 套汇美元外汇买卖科目编号
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
grant select on ${iol_schema}.tgls_pfp_conf to ${iml_schema};
grant select on ${iol_schema}.tgls_pfp_conf to ${icl_schema};
grant select on ${iol_schema}.tgls_pfp_conf to ${idl_schema};
grant select on ${iol_schema}.tgls_pfp_conf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_pfp_conf is '损益结转配置';
comment on column ${iol_schema}.tgls_pfp_conf.stacid is '账套';
comment on column ${iol_schema}.tgls_pfp_conf.brchcd is '处理对象';
comment on column ${iol_schema}.tgls_pfp_conf.orderi is '结转顺序';
comment on column ${iol_schema}.tgls_pfp_conf.tobrch is '对方机构编号';
comment on column ${iol_schema}.tgls_pfp_conf.totype is '0：损益上划1：损益结转2：本年利润转为未分配利润a：损益上划结转b：本年利润上划c：未分配利润上划';
comment on column ${iol_schema}.tgls_pfp_conf.brchit is '被上划机构的中间科目编号（清算科目）';
comment on column ${iol_schema}.tgls_pfp_conf.clbrit is '上划机构的中间科目编号（清算科目）';
comment on column ${iol_schema}.tgls_pfp_conf.smrytx is '备注';
comment on column ${iol_schema}.tgls_pfp_conf.acctmd is '记账方式';
comment on column ${iol_schema}.tgls_pfp_conf.usditem is '套汇美元外汇买卖科目编号';
comment on column ${iol_schema}.tgls_pfp_conf.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_pfp_conf.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_pfp_conf.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_pfp_conf.etl_timestamp is 'ETL处理时间戳';
