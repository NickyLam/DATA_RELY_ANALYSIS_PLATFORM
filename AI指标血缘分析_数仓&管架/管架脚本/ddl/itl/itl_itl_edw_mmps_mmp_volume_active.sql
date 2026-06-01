/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_mmps_mmp_volume_active
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_mmps_mmp_volume_active
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_mmps_mmp_volume_active purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_mmps_mmp_volume_active(
    etl_dt date -- 数据日期
    ,scanseqno varchar2(30) -- 扫描流水号
    ,acctno varchar2(28) -- 账号
    ,idtftp varchar2(1) -- 证件类型
    ,idtfno varchar2(20) -- 证件号码
    ,custna varchar2(40) -- 证件姓名
    ,idtaddress varchar2(100) -- 证件地址
    ,idtdt varchar2(8) -- 证件有效期
    ,nodeid varchar2(32) -- 节点号
    ,pswd varchar2(20) -- 交易密码
    ,mobile varchar2(20) -- 手机号
    ,bizcode varchar2(6) -- 业务编码
    ,idcheckresult varchar2(2) -- 联网核查结果
    ,transresult varchar2(1000) -- 交易结果
    ,uptime timestamp(6) -- 交易时间
    ,issetnewpwd varchar2(1) -- 是否修改密码
    ,newpwd varchar2(20) -- 新密码
    ,isfcfnoper varchar2(1) -- 是否操作非柜面非同名限额签约
    ,isfcfntype varchar2(1) -- 是否 非柜面非同名账户限额签约
    ,daylimit varchar2(16) -- 日累计限额
    ,txntimeslimit varchar2(16) -- 日笔数限额
    ,yearlimit varchar2(16) -- 年累计限额
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
grant select on ${itl_schema}.itl_edw_mmps_mmp_volume_active to ${iel_schema};

-- comment
comment on table ${itl_schema}.itl_edw_mmps_mmp_volume_active is 'PAD激活批量开的卡信息表';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.scanseqno is '扫描流水号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.acctno is '账号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.idtftp is '证件类型';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.idtfno is '证件号码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.custna is '证件姓名';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.idtaddress is '证件地址';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.idtdt is '证件有效期';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.nodeid is '节点号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.pswd is '交易密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.mobile is '手机号';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.bizcode is '业务编码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.idcheckresult is '联网核查结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.transresult is '交易结果';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.uptime is '交易时间';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.issetnewpwd is '是否修改密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.newpwd is '新密码';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.isfcfnoper is '是否操作非柜面非同名限额签约';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.isfcfntype is '是否 非柜面非同名账户限额签约';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.daylimit is '日累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.txntimeslimit is '日笔数限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.yearlimit is '年累计限额';
comment on column ${itl_schema}.itl_edw_mmps_mmp_volume_active.etl_timestamp is 'ETL处理时间戳';