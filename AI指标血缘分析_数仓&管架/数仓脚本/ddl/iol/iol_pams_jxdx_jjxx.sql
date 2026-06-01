/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_jjxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_jjxx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_jjxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_jjxx(
    jxdxdh number(38,0) -- 考核对象代号
    ,khh varchar2(180) -- 客户号
    ,cpdm varchar2(300) -- 产品代码
    ,cpsx varchar2(30) -- 产品属性
    ,tadm varchar2(30) -- TA代码
    ,bzcpdm varchar2(180) -- 标准产品代码
    ,jyzh varchar2(180) -- 交易账户
    ,jgdh varchar2(180) -- 机构代号
    ,fhfs varchar2(30) -- 分红方式
    ,zhbs varchar2(6) -- 账户标识
    ,zhdhrq number(38,0) -- 最后动户日期
    ,tjrq number(38,0) -- 统计日期
    ,fe number(30,2) -- 份额
    ,jz number(18,8) -- 净值
    ,zhye number(30,8) -- 账户余额
    ,ztbz varchar2(3) -- 在途基金标识：1-在途，0-非在途
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
grant select on ${iol_schema}.pams_jxdx_jjxx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_jjxx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_jjxx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_jjxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_jjxx is '基金账户';
comment on column ${iol_schema}.pams_jxdx_jjxx.jxdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_jjxx.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_jjxx.cpdm is '产品代码';
comment on column ${iol_schema}.pams_jxdx_jjxx.cpsx is '产品属性';
comment on column ${iol_schema}.pams_jxdx_jjxx.tadm is 'TA代码';
comment on column ${iol_schema}.pams_jxdx_jjxx.bzcpdm is '标准产品代码';
comment on column ${iol_schema}.pams_jxdx_jjxx.jyzh is '交易账户';
comment on column ${iol_schema}.pams_jxdx_jjxx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_jjxx.fhfs is '分红方式';
comment on column ${iol_schema}.pams_jxdx_jjxx.zhbs is '账户标识';
comment on column ${iol_schema}.pams_jxdx_jjxx.zhdhrq is '最后动户日期';
comment on column ${iol_schema}.pams_jxdx_jjxx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_jjxx.fe is '份额';
comment on column ${iol_schema}.pams_jxdx_jjxx.jz is '净值';
comment on column ${iol_schema}.pams_jxdx_jjxx.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_jjxx.ztbz is '在途基金标识：1-在途，0-非在途';
comment on column ${iol_schema}.pams_jxdx_jjxx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_jjxx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_jjxx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_jjxx.etl_timestamp is 'ETL处理时间戳';
