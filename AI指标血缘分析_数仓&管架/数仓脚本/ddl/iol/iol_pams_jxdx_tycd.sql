/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_tycd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_tycd
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_tycd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_tycd(
    jxdxdh number(22,0) -- 绩效对象代号
    ,wbbh varchar2(90) -- 外部账号编号
    ,nbbh varchar2(90) -- 内部编号
    ,jrgjbh varchar2(150) -- 金融工具编号
    ,sclxbh varchar2(90) -- 市场类型编号
    ,ywbh varchar2(90) -- 业务编号
    ,cddm varchar2(45) -- 存单代码
    ,cdjc varchar2(150) -- 存单简称
    ,kmh varchar2(30) -- 科目号
    ,zhmc varchar2(750) -- 账户名称
    ,fxr number(22,0) -- 发行日
    ,qxr number(22,0) -- 起息日
    ,dqr number(22,0) -- 到期日期
    ,dfr number(22,0) -- 兑付日
    ,qx varchar2(15) -- 期限
    ,jxts number(22,0) -- 计息天数
    ,fxjg number(38,8) -- 发行机构
    ,nll number(25,4) -- 年利率
    ,fxl number(38,8) -- 发行量(元)
    ,fxje number(38,8) -- 发行金额(元)
    ,bqye number(25,4) -- 本期余额(元)
    ,sjtzrkhh varchar2(45) -- 实际投资人客户号
    ,sjtzrqc varchar2(150) -- 实际投资人全称
    ,sjtzrkhfl varchar2(45) -- 实际投资人客户分类
    ,sjtzrjglx varchar2(45) -- 实际投资人机构类型
    ,fxjgmc varchar2(150) -- 发行机构
    ,cdgsjgdh varchar2(15) -- 归属机构
    ,xsjgmc varchar2(150) -- 销售机构
    ,bz varchar2(45) -- 币种
    ,cdmz number(25,4) -- 存单面值(元)
    ,tzrtzmz number(25,4) -- 投资人投资面值(元)
    ,khdxdh number(22,0) -- 考核对象代号
    ,tjrq number(22,0) -- 统计日期
    ,gxhslx varchar2(2) -- 关系函数类型
    ,ftpll number(25,4) -- 准备金ftp利率
    ,xsjgmczh varchar2(4000) -- 销售机构名称组合
    ,xsjgmczb varchar2(4000) -- 销售机构占比说明
    ,gsjgmczh varchar2(4000) -- 归属机构名称组合
    ,gsjgmczb varchar2(4000) -- 归属机构占比说明
    ,cpdm varchar2(90) -- 产品代码
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
grant select on ${iol_schema}.pams_jxdx_tycd to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_tycd to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_tycd to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_tycd to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_tycd is '绩效对象_同业存单';
comment on column ${iol_schema}.pams_jxdx_tycd.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_tycd.wbbh is '外部账号编号';
comment on column ${iol_schema}.pams_jxdx_tycd.nbbh is '内部编号';
comment on column ${iol_schema}.pams_jxdx_tycd.jrgjbh is '金融工具编号';
comment on column ${iol_schema}.pams_jxdx_tycd.sclxbh is '市场类型编号';
comment on column ${iol_schema}.pams_jxdx_tycd.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxdx_tycd.cddm is '存单代码';
comment on column ${iol_schema}.pams_jxdx_tycd.cdjc is '存单简称';
comment on column ${iol_schema}.pams_jxdx_tycd.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_tycd.zhmc is '账户名称';
comment on column ${iol_schema}.pams_jxdx_tycd.fxr is '发行日';
comment on column ${iol_schema}.pams_jxdx_tycd.qxr is '起息日';
comment on column ${iol_schema}.pams_jxdx_tycd.dqr is '到期日期';
comment on column ${iol_schema}.pams_jxdx_tycd.dfr is '兑付日';
comment on column ${iol_schema}.pams_jxdx_tycd.qx is '期限';
comment on column ${iol_schema}.pams_jxdx_tycd.jxts is '计息天数';
comment on column ${iol_schema}.pams_jxdx_tycd.fxjg is '发行机构';
comment on column ${iol_schema}.pams_jxdx_tycd.nll is '年利率';
comment on column ${iol_schema}.pams_jxdx_tycd.fxl is '发行量(元)';
comment on column ${iol_schema}.pams_jxdx_tycd.fxje is '发行金额(元)';
comment on column ${iol_schema}.pams_jxdx_tycd.bqye is '本期余额(元)';
comment on column ${iol_schema}.pams_jxdx_tycd.sjtzrkhh is '实际投资人客户号';
comment on column ${iol_schema}.pams_jxdx_tycd.sjtzrqc is '实际投资人全称';
comment on column ${iol_schema}.pams_jxdx_tycd.sjtzrkhfl is '实际投资人客户分类';
comment on column ${iol_schema}.pams_jxdx_tycd.sjtzrjglx is '实际投资人机构类型';
comment on column ${iol_schema}.pams_jxdx_tycd.fxjgmc is '发行机构';
comment on column ${iol_schema}.pams_jxdx_tycd.cdgsjgdh is '归属机构';
comment on column ${iol_schema}.pams_jxdx_tycd.xsjgmc is '销售机构';
comment on column ${iol_schema}.pams_jxdx_tycd.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_tycd.cdmz is '存单面值(元)';
comment on column ${iol_schema}.pams_jxdx_tycd.tzrtzmz is '投资人投资面值(元)';
comment on column ${iol_schema}.pams_jxdx_tycd.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_tycd.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_tycd.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_tycd.ftpll is '准备金ftp利率';
comment on column ${iol_schema}.pams_jxdx_tycd.xsjgmczh is '销售机构名称组合';
comment on column ${iol_schema}.pams_jxdx_tycd.xsjgmczb is '销售机构占比说明';
comment on column ${iol_schema}.pams_jxdx_tycd.gsjgmczh is '归属机构名称组合';
comment on column ${iol_schema}.pams_jxdx_tycd.gsjgmczb is '归属机构占比说明';
comment on column ${iol_schema}.pams_jxdx_tycd.cpdm is '产品代码';
comment on column ${iol_schema}.pams_jxdx_tycd.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_tycd.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_tycd.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_tycd.etl_timestamp is 'ETL处理时间戳';
