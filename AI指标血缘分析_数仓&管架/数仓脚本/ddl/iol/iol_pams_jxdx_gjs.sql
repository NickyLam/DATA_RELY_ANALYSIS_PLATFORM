/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_gjs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_gjs
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_gjs purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_gjs(
    jxdxdh number(38,0) -- 绩效对象代号
    ,tjrq number(38,0) -- 统计日期
    ,ddh varchar2(96) -- 行内订单号
    ,yhlsh varchar2(750) -- 银行流水号
    ,jyrq number(38,0) -- 交易日期
    ,ddrq number(38,0) -- 订单日期
    ,jgdh varchar2(90) -- 机构代号
    ,khh varchar2(96) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,cph varchar2(750) -- 产品号
    ,cpmc varchar2(2250) -- 产品名称
    ,cpcs varchar2(90) -- 产品成色
    ,hjl varchar2(90) -- 含金量
    ,hyl varchar2(90) -- 含银量
    ,gmsl varchar2(90) -- 购买数量
    ,gysmc varchar2(1500) -- 供应商名称
    ,xsqd varchar2(90) -- 销售渠道
    ,jydj number(22,6) -- 交易单价
    ,zhye number(22,6) -- 账户余额
    ,sxf number(22,4) -- 手续费
    ,hydh varchar2(300) -- 行员代号
    ,sjly varchar2(90) -- 数据来源
    ,khdxdh number(38,0) -- 考核对象代号
    ,gxhslx varchar2(6) -- 关系函数类型
    ,zhdh varchar2(96) -- 账户代号
    ,cpfldm varchar2(90) -- 产品分类代码
    ,tdrq number(38,0) -- 退单日期
    ,scddh varchar2(750) -- 商城订单号
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
grant select on ${iol_schema}.pams_jxdx_gjs to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_gjs to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_gjs to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_gjs to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_gjs is '贵金属订单';
comment on column ${iol_schema}.pams_jxdx_gjs.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_gjs.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_gjs.ddh is '行内订单号';
comment on column ${iol_schema}.pams_jxdx_gjs.yhlsh is '银行流水号';
comment on column ${iol_schema}.pams_jxdx_gjs.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxdx_gjs.ddrq is '订单日期';
comment on column ${iol_schema}.pams_jxdx_gjs.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxdx_gjs.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_gjs.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_gjs.cph is '产品号';
comment on column ${iol_schema}.pams_jxdx_gjs.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxdx_gjs.cpcs is '产品成色';
comment on column ${iol_schema}.pams_jxdx_gjs.hjl is '含金量';
comment on column ${iol_schema}.pams_jxdx_gjs.hyl is '含银量';
comment on column ${iol_schema}.pams_jxdx_gjs.gmsl is '购买数量';
comment on column ${iol_schema}.pams_jxdx_gjs.gysmc is '供应商名称';
comment on column ${iol_schema}.pams_jxdx_gjs.xsqd is '销售渠道';
comment on column ${iol_schema}.pams_jxdx_gjs.jydj is '交易单价';
comment on column ${iol_schema}.pams_jxdx_gjs.zhye is '账户余额';
comment on column ${iol_schema}.pams_jxdx_gjs.sxf is '手续费';
comment on column ${iol_schema}.pams_jxdx_gjs.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_gjs.sjly is '数据来源';
comment on column ${iol_schema}.pams_jxdx_gjs.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_gjs.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_gjs.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_gjs.cpfldm is '产品分类代码';
comment on column ${iol_schema}.pams_jxdx_gjs.tdrq is '退单日期';
comment on column ${iol_schema}.pams_jxdx_gjs.scddh is '商城订单号';
comment on column ${iol_schema}.pams_jxdx_gjs.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_gjs.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_gjs.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_gjs.etl_timestamp is 'ETL处理时间戳';
