/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lsckmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lsckmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lsckmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lsckmx(
    tjrq number -- 统计日期
    ,khh varchar2(300) -- 客户号
    ,khmc varchar2(1500) -- 客户名称
    ,zhdh varchar2(300) -- 账户代号
    ,zhid varchar2(300) -- 卡号
    ,zzh varchar2(300) -- 子账号
    ,fpjs varchar2(6) -- 分配角色
    ,zzhkhjgh varchar2(300) -- 子帐号开户机构号
    ,zzhkhjgmc varchar2(300) -- 子帐号开户机构名称
    ,khjgkhdxdh number -- 开户机构考核对象代号
    ,ghjgkhdxdh number -- 管户机构考核对象代号
    ,ggjgkhdxdh number -- 共管机构考核对象代号
    ,khqdmc varchar2(300) -- 开户渠道名称
    ,hbf varchar2(300) -- 货币符
    ,kmh varchar2(300) -- 科目号
    ,cklx varchar2(300) -- 存款类型
    ,czdm varchar2(300) -- 操作代码
    ,cz varchar2(300) -- 储种
    ,qx varchar2(300) -- 期限
    ,czqx varchar2(300) -- 储种期限
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,jrj number(25,4) -- 季日均
    ,nrj number(25,4) -- 年日均
    ,ckrq number -- 存款日期
    ,xdrq number -- 销单日期
    ,ckll number(25,4) -- 存款利率(%)
    ,sfkh varchar2(300) -- 是否考核
    ,khjlgh varchar2(300) -- 客户经理工号
    ,khjlmc varchar2(300) -- 客户经理姓名
    ,ghjlgh varchar2(300) -- 管户经理工号
    ,ghjlmc varchar2(300) -- 管户经理名称
    ,ghjgh varchar2(300) -- 管户机构号
    ,ghjgmc varchar2(300) -- 管户机构名称
    ,ggjlgh varchar2(300) -- 共管经理工号
    ,ggjlmc varchar2(300) -- 共管经理名称
    ,ggjgh varchar2(300) -- 共管机构号
    ,ggjgmc varchar2(300) -- 共管机构名称
    ,fpbl number(25,4) -- 分配比例
    ,fphye number(25,4) -- 分配后余额
    ,fphyrj number(25,4) -- 分配后月日均
    ,fphjrj number(25,4) -- 分配后季日均
    ,fphnrj number(25,4) -- 分配后年日均
    ,fptx varchar2(30) -- 分配条线
    ,txfpbl number(19,5) -- 条线分配比例
    ,cpmc varchar2(300) -- 产品名称
    ,shll number(18,6) -- 赎回利率
    ,shqx number -- 赎回期限
    ,cph varchar2(60) -- 产品号
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
grant select on ${iol_schema}.pams_jxbb_lsckmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lsckmx is '绩效报表-零售存款';
comment on column ${iol_schema}.pams_jxbb_lsckmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.zhid is '卡号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_lsckmx.zzhkhjgh is '子帐号开户机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.zzhkhjgmc is '子帐号开户机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ghjgkhdxdh is '管户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ggjgkhdxdh is '共管机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khqdmc is '开户渠道名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.hbf is '货币符';
comment on column ${iol_schema}.pams_jxbb_lsckmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.cklx is '存款类型';
comment on column ${iol_schema}.pams_jxbb_lsckmx.czdm is '操作代码';
comment on column ${iol_schema}.pams_jxbb_lsckmx.cz is '储种';
comment on column ${iol_schema}.pams_jxbb_lsckmx.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx.czqx is '储种期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_lsckmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ckrq is '存款日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx.xdrq is '销单日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ckll is '存款利率(%)';
comment on column ${iol_schema}.pams_jxbb_lsckmx.sfkh is '是否考核';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.khjlmc is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ghjlgh is '管户经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ghjlmc is '管户经理名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ghjgh is '管户机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ghjgmc is '管户机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ggjlgh is '共管经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ggjlmc is '共管经理名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ggjgh is '共管机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.ggjgmc is '共管机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fphye is '分配后余额';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fphyrj is '分配后月日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fphjrj is '分配后季日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fphnrj is '分配后年日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_lsckmx.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_lsckmx.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx.shll is '赎回利率';
comment on column ${iol_schema}.pams_jxbb_lsckmx.shqx is '赎回期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx.cph is '产品号';
comment on column ${iol_schema}.pams_jxbb_lsckmx.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx.etl_timestamp is 'ETL处理时间戳';
