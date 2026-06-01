/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_gskh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_gskh
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_gskh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_gskh(
    jxdxdh number(22,0) -- 考核对象代号
    ,khh varchar2(45) -- 客户号
    ,khlx varchar2(2) -- 客户类型
    ,jgdh varchar2(15) -- 机构代号
    ,khmc varchar2(750) -- 客户名称
    ,zjlb varchar2(12) -- 证件类别
    ,zjhm varchar2(75) -- 证件号码
    ,khjjxz varchar2(5) -- 客户经济性质
    ,khhylb varchar2(15) -- 客户行业类别
    ,qygm varchar2(2) -- 企业规模
    ,txdz varchar2(750) -- 通讯地址
    ,dwdh varchar2(75) -- 单位电话
    ,dzyj varchar2(75) -- 电子邮件
    ,lxdh varchar2(45) -- 联系电话
    ,khzt varchar2(15) -- 客户状态
    ,khrq number(22,0) -- 开户日期
    ,zczb number(25,4) -- 注册资本
    ,khlyxx varchar2(2) -- 客户来源信息
    ,gxhslx varchar2(2) -- 关系函数类型
    ,csrq number(22,0) -- 出生日期
    ,tjrq number(22,0) -- 统计日期
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
grant select on ${iol_schema}.pams_jxdx_gskh to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_gskh to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_gskh to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_gskh to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_gskh is '绩效对象-公司客户';
comment on column ${iol_schema}.pams_jxdx_gskh.jxdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_gskh.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_gskh.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxdx_gskh.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_gskh.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_gskh.zjlb is '证件类别';
comment on column ${iol_schema}.pams_jxdx_gskh.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_gskh.khjjxz is '客户经济性质';
comment on column ${iol_schema}.pams_jxdx_gskh.khhylb is '客户行业类别';
comment on column ${iol_schema}.pams_jxdx_gskh.qygm is '企业规模';
comment on column ${iol_schema}.pams_jxdx_gskh.txdz is '通讯地址';
comment on column ${iol_schema}.pams_jxdx_gskh.dwdh is '单位电话';
comment on column ${iol_schema}.pams_jxdx_gskh.dzyj is '电子邮件';
comment on column ${iol_schema}.pams_jxdx_gskh.lxdh is '联系电话';
comment on column ${iol_schema}.pams_jxdx_gskh.khzt is '客户状态';
comment on column ${iol_schema}.pams_jxdx_gskh.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_gskh.zczb is '注册资本';
comment on column ${iol_schema}.pams_jxdx_gskh.khlyxx is '客户来源信息';
comment on column ${iol_schema}.pams_jxdx_gskh.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_gskh.csrq is '出生日期';
comment on column ${iol_schema}.pams_jxdx_gskh.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_gskh.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxdx_gskh.etl_timestamp is 'ETL处理时间戳';
