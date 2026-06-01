/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol dsvp_seal_accmanaglog
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.dsvp_seal_accmanaglog
whenever sqlerror continue none;
drop table ${iol_schema}.dsvp_seal_accmanaglog purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.dsvp_seal_accmanaglog(
    dbserno number(38,0) -- 序列号
    ,workdate date -- 工作日期
    ,branchno varchar2(12) -- 机构编号
    ,siteid number(38,0) -- 节点号
    ,accountno varchar2(40) -- 账号
    ,opertype number(38,0) -- 操作类型
    ,oldprintno varchar2(20) -- 旧印鉴卡号
    ,newprintno varchar2(20) -- 新印鉴卡号
    ,createdate date -- 建模日期
    ,usedate date -- 启用日期
    ,operatorname varchar2(100) -- 操作员工中文名称
    ,accountproperty varchar2(12) -- 账户性质
    ,ownbranchno varchar2(12) -- 柜员所属机构编号
    ,ownbranchname varchar2(200) -- 机构中文全称
    ,belongflag number(38,0) -- 主从标志（0：非共用，1：主账户，2:从账户）
    ,quality number(38,0) -- 通兑标志（1：通存通兑，2：不通兑）
    ,monittype number(38,0) -- 监控标志
    ,rightoper varchar2(20) -- 授权员工编号
    ,rightopername varchar2(40) -- 授权员工中文名称
    ,opendate date -- 开户日期
    ,destroydate date -- 销户日期
    ,drawoutdate date -- 抽卡日期
    ,describes varchar2(300) -- 备注
    ,accountname varchar2(512) -- 账户名
    ,accounttype number(38,0) -- 账户类型
    ,operator varchar2(20) -- 员工编号
    ,deleteflag number(38,0) -- 删除标志
    ,opertypesum number(38,0) -- 操作类型统计
    ,systemtime timestamp -- 系统时间
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.dsvp_seal_accmanaglog to ${iml_schema};
grant select on ${iol_schema}.dsvp_seal_accmanaglog to ${icl_schema};
grant select on ${iol_schema}.dsvp_seal_accmanaglog to ${idl_schema};
grant select on ${iol_schema}.dsvp_seal_accmanaglog to ${iel_schema};

-- comment
comment on table ${iol_schema}.dsvp_seal_accmanaglog is '印鉴变动日志表';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.dbserno is '序列号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.workdate is '工作日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.branchno is '机构编号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.siteid is '节点号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.accountno is '账号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.opertype is '操作类型';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.oldprintno is '旧印鉴卡号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.newprintno is '新印鉴卡号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.createdate is '建模日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.usedate is '启用日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.operatorname is '操作员工中文名称';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.accountproperty is '账户性质';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.ownbranchno is '柜员所属机构编号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.ownbranchname is '机构中文全称';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.belongflag is '主从标志（0：非共用，1：主账户，2:从账户）';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.quality is '通兑标志（1：通存通兑，2：不通兑）';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.monittype is '监控标志';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.rightoper is '授权员工编号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.rightopername is '授权员工中文名称';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.opendate is '开户日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.destroydate is '销户日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.drawoutdate is '抽卡日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.describes is '备注';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.accountname is '账户名';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.accounttype is '账户类型';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.operator is '员工编号';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.deleteflag is '删除标志';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.opertypesum is '操作类型统计';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.systemtime is '系统时间';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.dsvp_seal_accmanaglog.etl_timestamp is 'ETL处理时间戳';
