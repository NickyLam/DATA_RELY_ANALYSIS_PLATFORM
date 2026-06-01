/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_individuallossrepeal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 扫描流水号
    ,bizcode varchar2(6) -- 业务编码
    ,acctno varchar2(28) -- 账号
    ,custna varchar2(40) -- 姓名
    ,idtaddress varchar2(100) -- 证件地址
    ,idtdt varchar2(8) -- 证件有效期
    ,idtftp varchar2(1) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,idcheckresult varchar2(2) -- 联网核查结果
    ,pswd varchar2(20) -- 交易密码
    ,rplsdt varchar2(8) -- 原挂失日期
    ,rplssq varchar2(20) -- 原挂失登记号
    ,payway varchar2(1) -- 支取方式
    ,mobile varchar2(20) -- 联系手机号码
    ,nodeid varchar2(32) -- 节点号
    ,transresult varchar2(1000) -- 交易结果
    ,uptime timestamp(6) -- 更新时间
    ,etl_timestamp timestamp -- ETL处理时间戳
   -- ,job_cd varchar2(10) -- 任务编码
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal is '个人账户挂失撤销';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.scanseqno is '扫描流水号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.bizcode is '业务编码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.acctno is '账号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.custna is '姓名';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.idtaddress is '证件地址';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.idtdt is '证件有效期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.idtftp is '证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.idtfno is '证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.idcheckresult is '联网核查结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.pswd is '交易密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.rplsdt is '原挂失日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.rplssq is '原挂失登记号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.payway is '支取方式';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.mobile is '联系手机号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.nodeid is '节点号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.transresult is '交易结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.uptime is '更新时间';
comment on column ${itl_schema}.itl_edw_mmps_mmp_individuallossrepeal.etl_timestamp is 'ETL处理时间戳';