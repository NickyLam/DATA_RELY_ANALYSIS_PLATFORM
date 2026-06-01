/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl oass_uuss_uus_tellerno
CreateDate: 20221106
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.oass_uuss_uus_tellerno purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.oass_uuss_uus_tellerno(
etl_dt date --数据日期
,attachorgan varchar2(12) --柜员所属机构
,tellerno varchar2(6) --柜员号
,tellerlevel varchar2(2) --柜员级别
,organcode varchar2(255) --所在部门编号
,status varchar2(1) --柜员状态：0-正常，1-注销
,userna varchar2(16) --柜员名称
,ussatg varchar2(1) --平账状态
,lastlg varchar2(8) --最后登录日期
,lstrdt varchar2(8) --最后交易日期
,usertp varchar2(1) --柜员类型
,menugp varchar2(1) --超级柜员标志
,start_dt date --开始时间
,end_dt date --结束时间
,id_mark varchar2(10) --增删标志
,employeeid varchar2(16) --员工编号
,tellermanagerid varchar2(16) --柜员主管编号

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.oass_uuss_uus_tellerno to ${iel_schema};

-- comment
comment on table ${idl_schema}.oass_uuss_uus_tellerno is '柜员信息表';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.etl_dt is '数据日期';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.attachorgan is '柜员所属机构';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.tellerno is '柜员号';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.tellerlevel is '柜员级别';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.organcode is '所在部门编号';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.status is '柜员状态：0-正常，1-注销';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.userna is '柜员名称';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.ussatg is '平账状态';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.lastlg is '最后登录日期';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.lstrdt is '最后交易日期';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.usertp is '柜员类型';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.menugp is '超级柜员标志';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.start_dt is '开始时间';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.end_dt is '结束时间';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.id_mark is '增删标志';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.employeeid is '员工编号';
comment on column ${idl_schema}.oass_uuss_uus_tellerno.tellermanagerid is '柜员主管编号';

