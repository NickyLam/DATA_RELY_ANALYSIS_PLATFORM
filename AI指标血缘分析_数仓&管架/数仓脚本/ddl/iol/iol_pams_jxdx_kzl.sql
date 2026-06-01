/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_kzl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_kzl
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_kzl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_kzl(
    jxdxdh number(22,0) -- 绩效对象代号
    ,kh varchar2(30) -- 卡号
    ,fhdh varchar2(15) -- 分行代号
    ,jgdh varchar2(15) -- 机构代号
    ,khh varchar2(45) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,zh varchar2(60) -- 账户
    ,zjlb varchar2(6) -- 证件类别
    ,zjhm varchar2(75) -- 证件号码
    ,kl varchar2(15) -- 卡类
    ,kjz varchar2(3) -- 卡介质
    ,kdj varchar2(5) -- 卡等级
    ,kztbz varchar2(8) -- 卡状态标志
    ,kyyzt varchar2(3) -- 卡应用状态
    ,fkrq number(22,0) -- 发卡日期
    ,kkrq number(22,0) -- 开卡日期
    ,jhrq number(22,0) -- 激活日期
    ,xkrq number(22,0) -- 销卡日期
    ,zfkbz varchar2(3) -- 主副卡标志
    ,hydh varchar2(18) -- 行员代号
    ,gxhslx varchar2(2) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,zhbs varchar2(2) -- 账户标识
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
grant select on ${iol_schema}.pams_jxdx_kzl to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_kzl to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_kzl to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_kzl to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_kzl is '绩效对象-存款账户';
comment on column ${iol_schema}.pams_jxdx_kzl.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_kzl.kh is '卡号';
comment on column ${iol_schema}.pams_jxdx_kzl.fhdh is '分行代号';
comment on column ${iol_schema}.pams_jxdx_kzl.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_kzl.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_kzl.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_kzl.zh is '账户';
comment on column ${iol_schema}.pams_jxdx_kzl.zjlb is '证件类别';
comment on column ${iol_schema}.pams_jxdx_kzl.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_kzl.kl is '卡类';
comment on column ${iol_schema}.pams_jxdx_kzl.kjz is '卡介质';
comment on column ${iol_schema}.pams_jxdx_kzl.kdj is '卡等级';
comment on column ${iol_schema}.pams_jxdx_kzl.kztbz is '卡状态标志';
comment on column ${iol_schema}.pams_jxdx_kzl.kyyzt is '卡应用状态';
comment on column ${iol_schema}.pams_jxdx_kzl.fkrq is '发卡日期';
comment on column ${iol_schema}.pams_jxdx_kzl.kkrq is '开卡日期';
comment on column ${iol_schema}.pams_jxdx_kzl.jhrq is '激活日期';
comment on column ${iol_schema}.pams_jxdx_kzl.xkrq is '销卡日期';
comment on column ${iol_schema}.pams_jxdx_kzl.zfkbz is '主副卡标志';
comment on column ${iol_schema}.pams_jxdx_kzl.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_kzl.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_kzl.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_kzl.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_kzl.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_kzl.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_kzl.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_kzl.etl_timestamp is 'ETL处理时间戳';
