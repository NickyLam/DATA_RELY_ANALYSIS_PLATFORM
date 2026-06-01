/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a1btyhxzdj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a1btyhxzdj
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a1btyhxzdj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a1btyhxzdj(
    transdt varchar2(12) -- 登记日期
    ,transtm varchar2(9) -- 登记时间
    ,qqdbs varchar2(45) -- 请求单标识
    ,rwlsh varchar2(53) -- 任务流水号
    ,yrwlsh varchar2(45) -- 原任务流水号
    ,djzhhz varchar2(150) -- 冻结账户户主
    ,zzlxdm varchar2(23) -- 证件类型代码
    ,zzhm varchar2(45) -- 证件号码
    ,zh varchar2(60) -- 冻结账卡号
    ,zhxh varchar2(75) -- 账户序号
    ,djfs varchar2(3) -- 冻结方式 01-限额内冻结 02-只收不付
    ,je varchar2(30) -- 金额
    ,bz varchar2(30) -- 币种
    ,kssj varchar2(12) -- 开始时间
    ,jssj varchar2(12) -- 结束时间
    ,updttm varchar2(21) -- 更新时间
    ,result varchar2(2) -- 处理结果 0-录入 1-已处理 2-处理失败 3-已登记
    ,tradetype varchar2(2) -- 交易类型 1-冻结 2-续冻 3-解冻
    ,ischeck varchar2(3) -- 分行以上是否已复核  0-否 1-是
    ,isprocess varchar2(3) -- 是否已查询开户行   0-否 1-是
    ,tlrno varchar2(15) -- 经办柜员
    ,ckbkus varchar2(15) -- 授权柜员
    ,dealtm varchar2(21) -- 处理时间
    ,errormsg varchar2(450) -- 错误信息
    ,openbr varchar2(15) -- 开户机构
    ,pckno varchar2(15) -- 
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
grant select on ${iol_schema}.mpcs_a1btyhxzdj to ${iml_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdj to ${icl_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdj to ${idl_schema};
grant select on ${iol_schema}.mpcs_a1btyhxzdj to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a1btyhxzdj is '协助冻结表';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.transdt is '登记日期';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.transtm is '登记时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.qqdbs is '请求单标识';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.rwlsh is '任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.yrwlsh is '原任务流水号';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.djzhhz is '冻结账户户主';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.zzlxdm is '证件类型代码';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.zzhm is '证件号码';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.zh is '冻结账卡号';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.zhxh is '账户序号';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.djfs is '冻结方式 01-限额内冻结 02-只收不付';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.je is '金额';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.bz is '币种';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.kssj is '开始时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.jssj is '结束时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.updttm is '更新时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.result is '处理结果 0-录入 1-已处理 2-处理失败 3-已登记';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.tradetype is '交易类型 1-冻结 2-续冻 3-解冻';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.ischeck is '分行以上是否已复核  0-否 1-是';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.isprocess is '是否已查询开户行   0-否 1-是';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.tlrno is '经办柜员';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.ckbkus is '授权柜员';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.dealtm is '处理时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.errormsg is '错误信息';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.openbr is '开户机构';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.pckno is '';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a1btyhxzdj.etl_timestamp is 'ETL处理时间戳';
