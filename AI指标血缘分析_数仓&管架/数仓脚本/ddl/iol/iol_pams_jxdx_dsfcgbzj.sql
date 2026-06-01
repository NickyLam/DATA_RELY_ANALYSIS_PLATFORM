/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_dsfcgbzj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_dsfcgbzj
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_dsfcgbzj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_dsfcgbzj(
    jxdxdh number(38,0) -- 绩效对象代号
    ,xybh varchar2(750) -- 协议编号
    ,frbh varchar2(180) -- 法人编号
    ,zjlx varchar2(90) -- 证件类型代码
    ,zjhm varchar2(180) -- 证件号码
    ,kh varchar2(300) -- 银行账户编号
    ,khrq number(38,0) -- 开户日期
    ,qsdm varchar2(90) -- 券商代码
    ,zqzjzhbh varchar2(300) -- 证券资金账户编号
    ,bz varchar2(30) -- 币种
    ,zhye number(25,4) -- 资产余额
    ,bzjzt varchar2(90) -- 保证金状态
    ,djrq number(38,0) -- 登记日期
    ,cpbh varchar2(300) -- 标准产品编号
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(600) -- 客户名称
    ,ksrq number(38,0) -- 开始日期
    ,tjrq number(38,0) -- 数据接入日期
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
grant select on ${iol_schema}.pams_jxdx_dsfcgbzj to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_dsfcgbzj to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_dsfcgbzj to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_dsfcgbzj to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_dsfcgbzj is '第三方存款账户';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.xybh is '协议编号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.frbh is '法人编号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.zjlx is '证件类型代码';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.zjhm is '证件号码';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.kh is '银行账户编号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.khrq is '开户日期';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.qsdm is '券商代码';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.zqzjzhbh is '证券资金账户编号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.zhye is '资产余额';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.bzjzt is '保证金状态';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.djrq is '登记日期';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.cpbh is '标准产品编号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.ksrq is '开始日期';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.tjrq is '数据接入日期';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_dsfcgbzj.etl_timestamp is 'ETL处理时间戳';
