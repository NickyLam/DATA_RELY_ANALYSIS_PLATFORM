/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_zjywsrmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_zjywsrmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_zjywsrmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_zjywsrmx_recal(
    tjrq number(22) -- 数据入库日期
    ,recal_dt number(22) -- 重算日期
    ,jzlsh varchar2(180) -- 记账流水号
    ,rzrq number(22) -- 入账日期
    ,tjrzrq number(22) -- 统计入账日期
    ,rzkm varchar2(60) -- 入账科目
    ,kmmc varchar2(300) -- 科目名称
    ,jzjgdh varchar2(60) -- 记账机构编号
    ,jzjgmc varchar2(300) -- 记账机构名称
    ,bz varchar2(30) -- 币种
    ,khlx varchar2(30) -- 客户类型
    ,hsje number(30,8) -- 含税金额
    ,shje number(30,8) -- 赎回金额
    ,se number(30,8) -- 税额
    ,txbz varchar2(30) -- 摊销标识
    ,sfrq number(22) -- 收费日期
    ,sflsh varchar2(180) -- 收费流水号
    ,sfje number(30,8) -- 收费金额
    ,ywbh varchar2(180) -- 业务编号
    ,dybwkm varchar2(60) -- 对应表外科目
    ,dybwje number(30,8) -- 对应表外金额
    ,khh varchar2(60) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,jgdh varchar2(60) -- 机构号
    ,jgmc varchar2(300) -- 机构名称
    ,hydh varchar2(60) -- 客户经理工号
    ,hymc varchar2(300) -- 行员名称
    ,zlbl number(19,5) -- 认领比例
    ,jyje number(30,8) -- 交易金额
    ,fphdyje number(30,8) -- 分配后当月金额
    ,fphljje number(30,8) -- 分配后累计金额
    ,ywlx varchar2(30) -- 业务类型
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,jzjgkhdxdh number(22) -- 记账机构考核对象代号
    ,jxdxdh number(22) -- 绩效对象代号
    ,sfdm varchar2(180) -- 收费代码,
    ,sfmc varchar2(600) -- 收费名称
    ,ybbz varchar2(30) -- 原币币种
    ,cpxdl varchar2(300) -- 产品线大类
    ,sflx varchar2(300) -- 算法类型
    ,sfz varchar2(300) -- 身份证
    ,jzsf varchar2(300) -- 基础收费
    ,sfxmc varchar2(1500) -- 收费名称
    ,fptx varchar2(30) -- 所属条线
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
grant select on ${iol_schema}.pams_jxbb_zjywsrmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_zjywsrmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_zjywsrmx_recal is '绩效报表_中间业务收入明细_重算';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.tjrq is '数据入库日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jzlsh is '记账流水号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.rzrq is '入账日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.tjrzrq is '统计入账日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.rzkm is '入账科目';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jzjgdh is '记账机构编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jzjgmc is '记账机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.bz is '币种';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.khlx is '客户类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.hsje is '含税金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.shje is '赎回金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.se is '税额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.txbz is '摊销标识';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfrq is '收费日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sflsh is '收费流水号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfje is '收费金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.ywbh is '业务编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.dybwkm is '对应表外科目';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.dybwje is '对应表外金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jgdh is '机构号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jgmc is '机构名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.hydh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.hymc is '行员名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.zlbl is '认领比例';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jyje is '交易金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.fphdyje is '分配后当月金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.fphljje is '分配后累计金额';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.ywlx is '业务类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jzjgkhdxdh is '记账机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfdm is '收费代码,';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfmc is '收费名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.ybbz is '原币币种';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.cpxdl is '产品线大类';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sflx is '算法类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfz is '身份证';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jzsf is '基础收费';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sfxmc is '收费名称';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.fptx is '所属条线';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.zylx is '质押类型';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.xyzbh is '信用证编号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.sxfzqfs is '手续费收取方式';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.yxtdm is '源系统代码';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.gjywbs is '国际业务标识：0-否，1-是';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_zjywsrmx_recal.etl_timestamp is 'ETL处理时间戳';
