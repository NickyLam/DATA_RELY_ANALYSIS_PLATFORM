/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol pams_jxbb_gsckmx
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.pams_jxbb_gsckmx
whenever sqlerror continue none;
drop table ${iol_schema}.pams_jxbb_gsckmx purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pams_jxbb_gsckmx(
    tjrq number(22,0) -- 统计日期
    ,khh varchar2(150) -- 客户号
    ,khmc varchar2(750) -- 客户名称
    ,zhdh varchar2(150) -- 账户代号
    ,zhhm varchar2(750) -- 账户名
    ,zzh varchar2(150) -- 子账号
    ,zhid varchar2(150) -- 卡号
    ,jgkhdxdh number(22,0) -- 机构考核对象代号
    ,khjgh varchar2(150) -- 开户机构号
    ,khjgmc varchar2(150) -- 开户机构名称
    ,hbf varchar2(150) -- 货币符
    ,kmh varchar2(150) -- 科目号
    ,kmmc varchar2(150) -- 科目名称
    ,czdm varchar2(150) -- 业务编号
    ,cz varchar2(150) -- 储种
    ,czqx varchar2(150) -- 储种期限
    ,ye number(25,4) -- 余额
    ,yrj number(25,4) -- 月日均
    ,jrj number(25,4) -- 季日均
    ,nrj number(25,4) -- 年日均
    ,qxr number(22,0) -- 起息日
    ,dqr number(22,0) -- 到期日
    ,sjxhr number(22,0) -- 实际销户日
    ,ckll number(25,4) -- 存款利率(%)
    ,khjlgh varchar2(150) -- 客户经理工号
    ,khjlmc varchar2(150) -- 客户经理姓名
    ,ssjgh varchar2(150) -- 所属机构号
    ,ssjgmc varchar2(150) -- 所属机构名称
    ,fpbl number(25,4) -- 分配比例
    ,fphye number(25,4) -- 分配后余额
    ,fphyrj number(25,4) -- 分配后月日均
    ,fphjrj number(25,4) -- 分配后季日均
    ,fphnrj number(25,4) -- 分配后年日均
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
grant select on ${iol_schema}.pams_jxbb_gsckmx to ${iml_schema};
grant select on ${iol_schema}.pams_jxbb_gsckmx to ${icl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckmx to ${idl_schema};
grant select on ${iol_schema}.pams_jxbb_gsckmx to ${iel_schema};

-- comment
comment on table ${iol_schema}.pams_jxbb_gsckmx is '绩效报表-公司存款明细';
comment on column ${iol_schema}.pams_jxbb_gsckmx.tjrq is '统计日期';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khh is '客户号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khmc is '客户名称';
comment on column ${iol_schema}.pams_jxbb_gsckmx.zhdh is '账户代号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.zhhm is '账户名';
comment on column ${iol_schema}.pams_jxbb_gsckmx.zzh is '子账号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.zhid is '卡号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.jgkhdxdh is '机构考核对象代号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khjgh is '开户机构号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khjgmc is '开户机构名称';
comment on column ${iol_schema}.pams_jxbb_gsckmx.hbf is '货币符';
comment on column ${iol_schema}.pams_jxbb_gsckmx.kmh is '科目号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.kmmc is '科目名称';
comment on column ${iol_schema}.pams_jxbb_gsckmx.czdm is '业务编号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.cz is '储种';
comment on column ${iol_schema}.pams_jxbb_gsckmx.czqx is '储种期限';
comment on column ${iol_schema}.pams_jxbb_gsckmx.ye is '余额';
comment on column ${iol_schema}.pams_jxbb_gsckmx.yrj is '月日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.jrj is '季日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.nrj is '年日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.qxr is '起息日';
comment on column ${iol_schema}.pams_jxbb_gsckmx.dqr is '到期日';
comment on column ${iol_schema}.pams_jxbb_gsckmx.sjxhr is '实际销户日';
comment on column ${iol_schema}.pams_jxbb_gsckmx.ckll is '存款利率(%)';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khjlgh is '客户经理工号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.khjlmc is '客户经理姓名';
comment on column ${iol_schema}.pams_jxbb_gsckmx.ssjgh is '所属机构号';
comment on column ${iol_schema}.pams_jxbb_gsckmx.ssjgmc is '所属机构名称';
comment on column ${iol_schema}.pams_jxbb_gsckmx.fpbl is '分配比例';
comment on column ${iol_schema}.pams_jxbb_gsckmx.fphye is '分配后余额';
comment on column ${iol_schema}.pams_jxbb_gsckmx.fphyrj is '分配后月日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.fphjrj is '分配后季日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.fphnrj is '分配后年日均';
comment on column ${iol_schema}.pams_jxbb_gsckmx.start_dt is '开始时间';
comment on column ${iol_schema}.pams_jxbb_gsckmx.end_dt is '结束时间';
comment on column ${iol_schema}.pams_jxbb_gsckmx.id_mark is '增删标志';
comment on column ${iol_schema}.pams_jxbb_gsckmx.etl_timestamp is 'ETL处理时间戳';
