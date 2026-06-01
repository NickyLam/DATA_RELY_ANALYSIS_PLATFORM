/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uuss_uus_tellerno
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uuss_uus_tellerno
whenever sqlerror continue none;
drop table ${iol_schema}.uuss_uus_tellerno purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uuss_uus_tellerno(
    employeeid varchar2(24) -- 员工编号
    ,tellermanagerid varchar2(24) -- 柜员主管编号
    ,attachorgan varchar2(18) -- 柜员所属机构
    ,tellerno varchar2(9) -- 柜员号
    ,tellerlevel varchar2(3) -- 柜员级别
    ,organcode varchar2(383) -- 所在部门编号
    ,status varchar2(2) -- 柜员状态：0-正常，1-注销
    ,userna varchar2(24) -- 柜员名称
    ,ussatg varchar2(2) -- 平账状态
    ,lastlg varchar2(12) -- 最后登录日期
    ,lstrdt varchar2(12) -- 最后交易日期
    ,usertp varchar2(2) -- 柜员类型
    ,menugp varchar2(2) -- 超级柜员标志
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
grant select on ${iol_schema}.uuss_uus_tellerno to ${iml_schema};
grant select on ${iol_schema}.uuss_uus_tellerno to ${icl_schema};
grant select on ${iol_schema}.uuss_uus_tellerno to ${idl_schema};
grant select on ${iol_schema}.uuss_uus_tellerno to ${iel_schema};

-- comment
comment on table ${iol_schema}.uuss_uus_tellerno is '柜员信息表';
comment on column ${iol_schema}.uuss_uus_tellerno.employeeid is '员工编号';
comment on column ${iol_schema}.uuss_uus_tellerno.tellermanagerid is '柜员主管编号';
comment on column ${iol_schema}.uuss_uus_tellerno.attachorgan is '柜员所属机构';
comment on column ${iol_schema}.uuss_uus_tellerno.tellerno is '柜员号';
comment on column ${iol_schema}.uuss_uus_tellerno.tellerlevel is '柜员级别';
comment on column ${iol_schema}.uuss_uus_tellerno.organcode is '所在部门编号';
comment on column ${iol_schema}.uuss_uus_tellerno.status is '柜员状态：0-正常，1-注销';
comment on column ${iol_schema}.uuss_uus_tellerno.userna is '柜员名称';
comment on column ${iol_schema}.uuss_uus_tellerno.ussatg is '平账状态';
comment on column ${iol_schema}.uuss_uus_tellerno.lastlg is '最后登录日期';
comment on column ${iol_schema}.uuss_uus_tellerno.lstrdt is '最后交易日期';
comment on column ${iol_schema}.uuss_uus_tellerno.usertp is '柜员类型';
comment on column ${iol_schema}.uuss_uus_tellerno.menugp is '超级柜员标志';
comment on column ${iol_schema}.uuss_uus_tellerno.start_dt is '开始时间';
comment on column ${iol_schema}.uuss_uus_tellerno.end_dt is '结束时间';
comment on column ${iol_schema}.uuss_uus_tellerno.id_mark is '增删标志';
comment on column ${iol_schema}.uuss_uus_tellerno.etl_timestamp is 'ETL处理时间戳';
