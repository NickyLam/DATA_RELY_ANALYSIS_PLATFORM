/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_lsckmx_recal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_lsckmx_recal
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_lsckmx_recal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_lsckmx_recal(
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
    ,cph varchar2(60) -- 
    ,recal_dt number -- 重算日期
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
grant select on ${iol_schema}.pams_jxbb_lsckmx_recal to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx_recal to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx_recal to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_lsckmx_recal to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_lsckmx_recal is '绩效报表-零售存款-重算';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.zhid is '卡号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fpjs is '分配角色';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.zzhkhjgh is '子帐号开户机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.zzhkhjgmc is '子帐号开户机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khjgkhdxdh is '开户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ghjgkhdxdh is '管户机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ggjgkhdxdh is '共管机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khqdmc is '开户渠道名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.hbf is '货币符';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.cklx is '存款类型';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.czdm is '操作代码';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.cz is '储种';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.qx is '期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.czqx is '储种期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ckrq is '存款日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.xdrq is '销单日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ckll is '存款利率(%)';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.sfkh is '是否考核';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.khjlmc is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ghjlgh is '管户经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ghjlmc is '管户经理名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ghjgh is '管户机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ghjgmc is '管户机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ggjlgh is '共管经理工号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ggjlmc is '共管经理名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ggjgh is '共管机构号';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.ggjgmc is '共管机构名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fphye is '分配后余额';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fphyrj is '分配后月日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fphjrj is '分配后季日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fphnrj is '分配后年日均';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.fptx is '分配条线';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.txfpbl is '条线分配比例';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.cpmc is '产品名称';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.shll is '赎回利率';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.shqx is '赎回期限';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.cph is '';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.recal_dt is '重算日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.pams_jxbb_lsckmx_recal.etl_timestamp is 'ETL处理时间戳';
