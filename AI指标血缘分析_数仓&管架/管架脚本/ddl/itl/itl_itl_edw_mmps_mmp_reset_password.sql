/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_reset_password
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_reset_password
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_reset_password purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_reset_password(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 扫描流水号
    ,acctno varchar2(28) -- 账号
    ,idtftp varchar2(1) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,custna varchar2(40) -- 证件姓名
    ,idtaddress varchar2(100) -- 证件地址
    ,idtdt varchar2(8) -- 证件有效期
    ,nodeid varchar2(32) -- 节点号
    ,newpwd varchar2(20) -- 新密码
    ,mobile varchar2(20) -- 手机号
    ,bizcode varchar2(6) -- 业务编码
    ,idcheckresult varchar2(2) -- 联网核查结果
    ,transresult varchar2(1000) -- 交易结果
    ,uptime timestamp(6) -- 交易时间
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
grant select on ${itl_schema}.itl_edw_mmps_mmp_reset_password to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_reset_password is '交易密码重置表';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.scanseqno is '扫描流水号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.acctno is '账号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.idtftp is '证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.idtfno is '证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.custna is '证件姓名';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.idtaddress is '证件地址';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.idtdt is '证件有效期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.nodeid is '节点号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.newpwd is '新密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.mobile is '手机号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.bizcode is '业务编码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.idcheckresult is '联网核查结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.transresult is '交易结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.uptime is '交易时间';
comment on column ${itl_schema}.itl_edw_mmps_mmp_reset_password.etl_timestamp is 'ETL处理时间戳';