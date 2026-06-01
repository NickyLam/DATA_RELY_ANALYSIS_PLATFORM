/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zjywsrmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zjywsrmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zjywsrmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zjywsrmx(
    tjrq number(22,0) -- 统计日期
    ,jzlsh varchar2(180) -- 记账流水号
    ,rzrq number(22,0) -- 入账日期
    ,tjrzrq number(22,0) -- 统计入账日期
    ,rzkm varchar2(60) -- 入账科目
    ,kmmc varchar2(300) -- 科目名称
    ,jzjgdh varchar2(60) -- 记账机构编号
    ,jzjgmc varchar2(300) -- 记账机构名称
    ,bz varchar2(30) -- 币种
    ,khlx varchar2(30) -- 客户类型
    ,hsje number(30,8) -- 含税金额,
    ,shje number(30,8) -- 赎回金额
    ,se number(30,8) -- 税额
    ,txbz varchar2(30) -- 停息标志
    ,sfrq number(22,0) -- 收费日期,
    ,sflsh varchar2(180) -- 收费流水号,
    ,sfje number(30,8) -- 收费金额,
    ,ywbh varchar2(180) -- 业务编号
    ,dybwkm varchar2(60) -- 对应表外科目
    ,dybwje number(30,8) -- 对应表外金额
    ,khh varchar2(60) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,jgdh varchar2(60) -- 机构代号
    ,jgmc varchar2(300) -- 机构名称
    ,hydh varchar2(60) -- 行员代号
    ,hymc varchar2(300) -- 行员名称
    ,zlbl number(19,5) -- 增量比例
    ,jyje number(30,8) -- 交易金额
    ,fphdyje number(30,8) -- 分配后当月金额
    ,fphljje number(30,8) -- 分配后累计金额
    ,ywlx varchar2(30) -- 业务类型
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,jzjgkhdxdh number(22,0) -- 记账机构考核对象代号
    ,jxdxdh number(22,0) -- 绩效对象代号
    ,sfdm varchar2(180) -- 收费代码
    ,sfmc varchar2(600) -- 收费名称
    ,ybbz varchar2(30) -- 原币币种
    ,cpxdl varchar2(300) -- 产品线大类
    ,sflx varchar2(300) -- 产品类型
    ,sfz varchar2(300) -- 收费项
    ,jzsf varchar2(300) -- 基础收费
    ,sfxmc varchar2(1500) -- 收费项名称
    ,fptx varchar2(15) -- 所属条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,zylx varchar2(300) -- 质押类型
    ,xyzbh varchar2(300) -- 信用证编号
    ,jylsh varchar2(600) -- 交易流水号
    ,sxfzqfs varchar2(300) -- 手续费收取方式
    ,yxtdm varchar2(450) -- 源系统代码
    ,gjywbs varchar2(10) -- 国际业务标识：0-否，1-是
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
grant select on ${iol_schema}.pams_jxbb_zjywsrmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zjywsrmx is '绩效报表_中间业务收入明细';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jzlsh is '记账流水号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.rzrq is '入账日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.tjrzrq is '统计入账日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.rzkm is '入账科目';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jzjgdh is '记账机构编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jzjgmc is '记账机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.hsje is '含税金额,';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.shje is '赎回金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.se is '税额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.txbz is '停息标志';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfrq is '收费日期,';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sflsh is '收费流水号,';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfje is '收费金额,';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.dybwkm is '对应表外科目';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.dybwje is '对应表外金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.hydh is '行员代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.fphdyje is '分配后当月金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.fphljje is '分配后累计金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.ywlx is '业务类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jzjgkhdxdh is '记账机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfdm is '收费代码';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfmc is '收费名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.ybbz is '原币币种';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.cpxdl is '产品线大类';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sflx is '产品类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfz is '收费项';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jzsf is '基础收费';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sfxmc is '收费项名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.zylx is '质押类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.xyzbh is '信用证编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.sxfzqfs is '手续费收取方式';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.yxtdm is '源系统代码';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.gjywbs is '国际业务标识：0-否，1-是';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx.etl_timestamp is 'ETL处理时间戳';
