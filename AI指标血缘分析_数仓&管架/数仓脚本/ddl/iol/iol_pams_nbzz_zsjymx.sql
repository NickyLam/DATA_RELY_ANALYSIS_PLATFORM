/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_nbzz_zsjymx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_nbzz_zsjymx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_nbzz_zsjymx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_nbzz_zsjymx(
    tjrq number(22) -- 统计日期
    ,jxdxdh number(22) -- 绩效对象代号
    ,jgkhdxdh number(22) -- 机构考核对象代号
    ,khdxdh number(22) -- 考核对象代号
    ,jzlsh varchar2(600) -- 记账流水号
    ,rzrq number(22) -- 入账日期
    ,rzkm varchar2(60) -- 入账科目
    ,jgdh varchar2(60) -- 机构代号
    ,bz varchar2(30) -- 币种
    ,hsje number(30,8) -- 含税金额
    ,shje number(30,8) -- 赎回金额
    ,se number(30,8) -- 税额
    ,txbz varchar2(30) -- 停息标志
    ,sfrq number(22) -- 收费日期
    ,sflsh varchar2(600) -- 收费流水号
    ,sfje number(30,8) -- 收费金额
    ,ywbh varchar2(180) -- 业务编号
    ,dybwkm varchar2(60) -- 对应表外科目
    ,dybwje number(30,2) -- 对应表外金额
    ,khh varchar2(90) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,zlbl number(19,5) -- 增量比例
    ,jyje number(30,8) -- 交易金额
    ,fphdyje number(30,8) -- 分配后当月金额
    ,fphljje number(30,8) -- 分配后累计金额
    ,khlx varchar2(30) -- 客户类型
    ,hyyhsje number(30,8) -- 行员月含税金额
    ,hyyshje number(30,8) -- 行员月税后金额
    ,hyjhsje number(30,8) -- 行员季含税金额
    ,hyjshje number(30,8) -- 行员季税后金额
    ,hynhsje number(30,8) -- 行员年含税金额
    ,hynshje number(30,8) -- 行员年税后金额
    ,sfdm varchar2(180) -- 收费代码
    ,sfmc varchar2(600) -- 收费名称
    ,ybbz varchar2(30) -- 原币币种
    ,ypbzjblqj varchar2(30) -- 押品保证金比例区间
    ,jylsh varchar2(600) -- 交易流水号
    ,sxfzqfs varchar2(300) -- 手续费收取方式
    ,gjywbs varchar2(3) -- 国际业务标识：0-否，1-是
    ,yxtdm varchar2(450) -- 源系统代码
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
grant select on ${iol_schema}.pams_nbzz_zsjymx to ${iml_schema};
grant select on ${iol_schema}.pams_nbzz_zsjymx to ${icl_schema};
grant select on ${iol_schema}.pams_nbzz_zsjymx to ${idl_schema};
grant select on ${iol_schema}.pams_nbzz_zsjymx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_nbzz_zsjymx is '内部总账-中收交易明细';
comment on column ${iol_schema}.pams_nbzz_zsjymx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jxdxdh is '绩效对象代号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.khdxdh is '考核对象代号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jzlsh is '记账流水号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.rzrq is '入账日期';
comment on column ${iol_schema}.pams_nbzz_zsjymx.rzkm is '入账科目';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jgdh is '机构代号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.bz is '币种';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hsje is '含税金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.shje is '赎回金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.se is '税额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.txbz is '停息标志';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sfrq is '收费日期';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sflsh is '收费流水号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sfje is '收费金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.ywbh is '业务编号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.dybwkm is '对应表外科目';
comment on column ${iol_schema}.pams_nbzz_zsjymx.dybwje is '对应表外金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.khh is '客户号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.khmc is '客户名称';
comment on column ${iol_schema}.pams_nbzz_zsjymx.zlbl is '增量比例';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jyje is '交易金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.fphdyje is '分配后当月金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.fphljje is '分配后累计金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.khlx is '客户类型';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hyyhsje is '行员月含税金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hyyshje is '行员月税后金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hyjhsje is '行员季含税金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hyjshje is '行员季税后金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hynhsje is '行员年含税金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.hynshje is '行员年税后金额';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sfdm is '收费代码';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sfmc is '收费名称';
comment on column ${iol_schema}.pams_nbzz_zsjymx.ybbz is '原币币种';
comment on column ${iol_schema}.pams_nbzz_zsjymx.ypbzjblqj is '押品保证金比例区间';
comment on column ${iol_schema}.pams_nbzz_zsjymx.jylsh is '交易流水号';
comment on column ${iol_schema}.pams_nbzz_zsjymx.sxfzqfs is '手续费收取方式';
comment on column ${iol_schema}.pams_nbzz_zsjymx.gjywbs is '国际业务标识：0-否，1-是';
comment on column ${iol_schema}.pams_nbzz_zsjymx.yxtdm is '源系统代码';
comment on column ${iol_schema}.pams_nbzz_zsjymx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_nbzz_zsjymx.etl_timestamp is 'ETL处理时间戳';
