/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxdx_zsjyxx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxdx_zsjyxx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxdx_zsjyxx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxdx_zsjyxx(
    jxdxdh number(22,0) -- 绩效对象代号
    ,jyrq number(22,0) -- 交易日期
    ,jylsh varchar2(300) -- 交易流水号
    ,kmh varchar2(90) -- 科目号
    ,ywxzbz varchar2(15) -- 业务系统标识,
    ,ywbh varchar2(90) -- 业务编号
    ,jzjgdh varchar2(90) -- 记账机构编号
    ,zhdh varchar2(90) -- 账户代号
    ,zzh varchar2(90) -- 子账号
    ,bz varchar2(15) -- 币种
    ,sfdm varchar2(90) -- 收费代码,
    ,sfmc varchar2(300) -- 收费名称
    ,jyje number(30,2) -- 交易金额
    ,khh varchar2(90) -- 客户号
    ,hydh varchar2(90) -- 行员代号
    ,ywtxbh varchar2(45) -- 业务条线代码,
    ,bzcpbh varchar2(90) -- 标准产品编号
    ,gxhslx varchar2(15) -- 关系函数类型
    ,khdxdh number(22,0) -- 考核对象代号
    ,tjrq number(22,0) -- 统计日期
    ,khlx varchar2(15) -- 客户类型
    ,sfdjh varchar2(150) -- 收费单据号
    ,txlsh varchar2(90) -- 摊销流水号
    ,qjlsh varchar2(150) -- 全局流水号
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
grant select on ${iol_schema}.pams_jxdx_zsjyxx to ${iml_schema};
grant select on ${iol_schema}.pams_jxdx_zsjyxx to ${icl_schema};
grant select on ${iol_schema}.pams_jxdx_zsjyxx to ${idl_schema};
grant select on ${iol_schema}.pams_jxdx_zsjyxx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxdx_zsjyxx is '绩效对象_中间业务信息';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.jyrq is '交易日期';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.ywxzbz is '业务系统标识,';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.jzjgdh is '记账机构编号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.bz is '币种';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.sfdm is '收费代码,';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.sfmc is '收费名称';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.khh is '客户号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.ywtxbh is '业务条线代码,';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.bzcpbh is '标准产品编号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.gxhslx is '关系函数类型';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.sfdjh is '收费单据号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.txlsh is '摊销流水号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.qjlsh is '全局流水号';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxdx_zsjyxx.etl_timestamp is 'ETL处理时间戳';
