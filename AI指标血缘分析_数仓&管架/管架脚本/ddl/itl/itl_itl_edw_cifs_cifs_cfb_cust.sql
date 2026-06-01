/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cifs_cifs_cfb_cust
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust(
    etl_dt date --数据日期
    ,custno varchar2(15) -- CIF客户号
    ,custcn varchar2(100) -- 客户中文名称
    ,custen varchar2(200) -- 英文名称
    ,custlc varchar2(100) -- 最近曾用中文名
    ,custle varchar2(100) -- 最近曾用英文名
    ,custtp varchar2(2) -- 客户类型
    ,custlv varchar2(2) -- 客户级别
    ,statlv varchar2(2) -- 当前评级状态
    ,jonttg varchar2(1) -- 联名客户标志
    ,isblak varchar2(1) -- 是否黑名单客户
    ,doubtp varchar2(2) -- 疑似客户类型
    ,tttrib number(14,2) -- 综合贡献度
    ,ttrema number(14,2) -- 客户总积分
    ,risklv varchar2(2) -- 风险等级
    ,custst varchar2(2) -- 客户状态
    ,opendt varchar2(8) -- 开户日期
    ,openbr varchar2(15) -- 开户机构
    ,openus varchar2(15) -- 开户柜员
    ,closdt varchar2(8) -- 销户日期
    ,closbr varchar2(15) -- 销户机构
    ,closus varchar2(15) -- 销户柜员
    ,datatp varchar2(1) -- 数据类型:   1增量客户 0存量客户
    ,crecdt date -- 创建日期
    ,roletp varchar2(4) -- 参与者类别
    ,isincu varchar2(1) -- 是否系统内客户
    ,iscred varchar2(1) -- 是否授信客户
    ,credid varchar2(10) -- 信用评级ID
    ,credln number(19,2) -- 授信额度
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_cifs_cifs_cfb_cust to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cifs_cifs_cfb_cust is '客户基本信息';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.etl_dt is '数据日期';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custno is 'CIF客户号';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custcn is '客户中文名称';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custen is '英文名称';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custlc is '最近曾用中文名';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custle is '最近曾用英文名';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custtp is '客户类型';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custlv is '客户级别';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.statlv is '当前评级状态';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.jonttg is '联名客户标志';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.isblak is '是否黑名单客户';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.doubtp is '疑似客户类型';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.tttrib is '综合贡献度';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.ttrema is '客户总积分';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.risklv is '风险等级';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.custst is '客户状态';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.opendt is '开户日期';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.openbr is '开户机构';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.openus is '开户柜员';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.closdt is '销户日期';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.closbr is '销户机构';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.closus is '销户柜员';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.datatp is '数据类型:   1增量客户 0存量客户';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.crecdt is '创建日期';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.roletp is '参与者类别';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.isincu is '是否系统内客户';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.iscred is '是否授信客户';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.credid is '信用评级ID';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.credln is '授信额度';
comment on column ${itl_schema}.itl_edw_cifs_cifs_cfb_cust.etl_timestamp is 'ETL处理时间戳';