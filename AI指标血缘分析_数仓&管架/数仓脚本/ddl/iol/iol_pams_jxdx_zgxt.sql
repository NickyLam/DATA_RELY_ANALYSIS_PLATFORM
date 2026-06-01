/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_zgxt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_zgxt
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_zgxt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_zgxt(
    jxdxdh number(38,0) -- 绩效对象代号
    ,frbh varchar2(180) -- 法人编号
    ,tadm varchar2(30) -- TA代码
    ,cph varchar2(180) -- 产品号
    ,zhdh varchar2(180) -- 账户代号
    ,kh varchar2(300) -- 卡号
    ,khh varchar2(180) -- 客户号
    ,jgdh varchar2(180) -- 机构代号
    ,shje number(25,4) -- 赎回金额
    ,mrcb number(25,4) -- 买入成本
    ,zfe number(25,4) -- 总份额
    ,jz number(25,4) -- 净值
    ,zhye number(25,4) -- 账户余额
    ,tjrq number(38,0) -- 统计日期
    ,bzcpbh varchar2(180) -- 标准产品编号
    ,khlx varchar2(30) -- 客户类型代码
    ,mrjz number(25,4) -- 买入净值
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
grant select on ${iol_schema}.pams_jxdx_zgxt to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_zgxt to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_zgxt to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_zgxt to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_zgxt is '资管信托账户';
comment on column ${iol_schema}.pams_jxdx_zgxt.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_zgxt.frbh is '法人编号';
comment on column ${iol_schema}.pams_jxdx_zgxt.tadm is 'TA代码';
comment on column ${iol_schema}.pams_jxdx_zgxt.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_zgxt.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_zgxt.kh is '卡号';
comment on column ${iol_schema}.pams_jxdx_zgxt.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_zgxt.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_zgxt.shje is '赎回金额';
comment on column ${iol_schema}.pams_jxdx_zgxt.mrcb is '买入成本';
comment on column ${iol_schema}.pams_jxdx_zgxt.zfe is '总份额';
comment on column ${iol_schema}.pams_jxdx_zgxt.jz is '净值';
comment on column ${iol_schema}.pams_jxdx_zgxt.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_zgxt.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_zgxt.bzcpbh is '标准产品编号';
comment on column ${iol_schema}.pams_jxdx_zgxt.khlx is '客户类型代码';
comment on column ${iol_schema}.pams_jxdx_zgxt.mrjz is '买入净值';
comment on column ${iol_schema}.pams_jxdx_zgxt.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_zgxt.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_zgxt.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_zgxt.etl_timestamp is 'ETL处理时间戳';
