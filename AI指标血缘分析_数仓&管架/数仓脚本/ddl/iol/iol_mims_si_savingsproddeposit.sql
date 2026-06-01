/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_savingsproddeposit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_savingsproddeposit
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_savingsproddeposit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_savingsproddeposit(
    sccode varchar2(48) -- 押品编号
    ,protocolcode varchar2(45) -- 协议编号
    ,prodcode varchar2(45) -- 产品编号
    ,buyaccount varchar2(45) -- 购买账号
    ,buyamt number(20,2) -- 购买金额
    ,custid varchar2(45) -- 客户号
    ,rate number(5,2) -- 利率
    ,protocolstatus varchar2(30) -- 协议状态
    ,startdate varchar2(15) -- 起始日期
    ,enddate varchar2(15) -- 到期日期
    ,remark varchar2(4000) -- 其他说明
    ,type varchar2(3) -- 类型
    ,parentaccount varchar2(60) -- 保证金母户号
    ,childaccount varchar2(75) -- 子户号
    ,prodname varchar2(600) -- 产品名称
    ,deposit varchar2(15) -- 存期
    ,balanceamt number(20,2) -- 可用余额
    ,accountamt number(20,2) -- 账户余额
    ,tdcurrency varchar2(5) -- 币种
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
grant select on ${iol_schema}.mims_si_savingsproddeposit to ${iml_schema};
grant select on ${iol_schema}.mims_si_savingsproddeposit to ${icl_schema};
grant select on ${iol_schema}.mims_si_savingsproddeposit to ${idl_schema};
grant select on ${iol_schema}.mims_si_savingsproddeposit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_savingsproddeposit is '储蓄产品类存款';
comment on column ${iol_schema}.mims_si_savingsproddeposit.sccode is '押品编号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.protocolcode is '协议编号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.prodcode is '产品编号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.buyaccount is '购买账号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.buyamt is '购买金额';
comment on column ${iol_schema}.mims_si_savingsproddeposit.custid is '客户号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.rate is '利率';
comment on column ${iol_schema}.mims_si_savingsproddeposit.protocolstatus is '协议状态';
comment on column ${iol_schema}.mims_si_savingsproddeposit.startdate is '起始日期';
comment on column ${iol_schema}.mims_si_savingsproddeposit.enddate is '到期日期';
comment on column ${iol_schema}.mims_si_savingsproddeposit.remark is '其他说明';
comment on column ${iol_schema}.mims_si_savingsproddeposit.type is '类型';
comment on column ${iol_schema}.mims_si_savingsproddeposit.parentaccount is '保证金母户号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.childaccount is '子户号';
comment on column ${iol_schema}.mims_si_savingsproddeposit.prodname is '产品名称';
comment on column ${iol_schema}.mims_si_savingsproddeposit.deposit is '存期';
comment on column ${iol_schema}.mims_si_savingsproddeposit.balanceamt is '可用余额';
comment on column ${iol_schema}.mims_si_savingsproddeposit.accountamt is '账户余额';
comment on column ${iol_schema}.mims_si_savingsproddeposit.tdcurrency is '币种';
comment on column ${iol_schema}.mims_si_savingsproddeposit.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_savingsproddeposit.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_savingsproddeposit.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_savingsproddeposit.etl_timestamp is 'ETL处理时间戳';
