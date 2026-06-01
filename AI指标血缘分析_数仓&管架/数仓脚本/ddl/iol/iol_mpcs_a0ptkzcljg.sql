/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ptkzcljg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ptkzcljg
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ptkzcljg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ptkzcljg(
    bdhm varchar2(45) -- 控制请求单号
    ,ccxh number(22) -- 序号
    ,khzh varchar2(45) -- 开户账号
    ,kznr varchar2(3) -- 控制内容 1-资金  2-账户
    ,kzzt varchar2(3) -- 控制结果 1-已控  2-未控
    ,ye varchar2(30) -- 账户余额
    ,kyye varchar2(30) -- 可用余额
    ,csksrq varchar2(29) -- 措施始期
    ,csjsrq varchar2(29) -- 措施终期
    ,djxe varchar2(30) -- 冻结限额
    ,skje varchar2(30) -- 实际控制可用金额
    ,ceskje varchar2(30) -- 超额控制金额
    ,wnkzyy varchar2(150) -- 未能控制原因
    ,beiz varchar2(1500) -- 备注
    ,hostdt varchar2(30) -- 核心交易日期
    ,hostseqno varchar2(30) -- 核心交易流水
    ,dataid varchar2(30) -- 中台流水
    ,openbr varchar2(15) -- 开立机构
    ,diskno varchar2(90) -- 批次号
    ,lcseqno varchar2(48) -- 中台发送流水
    ,lcdate varchar2(12) -- 理财冻结日期
    ,jrcpbh varchar2(45) -- 金融产品编号
    ,lczh varchar2(75) -- 理财账号
    ,skse varchar2(30) -- 理财控制金额
    ,serialno varchar2(48) -- 理财控制流水
    ,assoserial varchar2(48) -- 理财原控制流水
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
grant select on ${iol_schema}.mpcs_a0ptkzcljg to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ptkzcljg to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ptkzcljg to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ptkzcljg to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ptkzcljg is '高院';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.bdhm is '控制请求单号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.ccxh is '序号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.khzh is '开户账号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.kznr is '控制内容 1-资金  2-账户';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.kzzt is '控制结果 1-已控  2-未控';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.ye is '账户余额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.kyye is '可用余额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.csksrq is '措施始期';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.csjsrq is '措施终期';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.djxe is '冻结限额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.skje is '实际控制可用金额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.ceskje is '超额控制金额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.wnkzyy is '未能控制原因';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.beiz is '备注';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.hostdt is '核心交易日期';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.hostseqno is '核心交易流水';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.dataid is '中台流水';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.openbr is '开立机构';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.diskno is '批次号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.lcseqno is '中台发送流水';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.lcdate is '理财冻结日期';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.jrcpbh is '金融产品编号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.lczh is '理财账号';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.skse is '理财控制金额';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.serialno is '理财控制流水';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.assoserial is '理财原控制流水';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ptkzcljg.etl_timestamp is 'ETL处理时间戳';
