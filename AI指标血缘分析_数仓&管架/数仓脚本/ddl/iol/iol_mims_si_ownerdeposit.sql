/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mims_si_ownerdeposit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mims_si_ownerdeposit
whenever sqlerror continue none;
drop table ${iol_schema}.mims_si_ownerdeposit purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_ownerdeposit(
    sccode varchar2(48) -- 
    ,certificatecode varchar2(150) -- 
    ,stoppaymentmoney number(20,2) -- 
    ,account varchar2(150) -- 
    ,startdate varchar2(15) -- 
    ,enddate varchar2(15) -- 
    ,duedate varchar2(15) -- 
    ,rate number(11,7) -- 
    ,money number(20,2) -- 
    ,remark varchar2(4000) -- 
    ,childaccount varchar2(90) -- 
    ,stoppayaccount varchar2(150) -- 
    ,tdcurrency varchar2(5) -- 
    ,deposittype varchar2(3) -- 存单类型
    ,buyaccount varchar2(60) -- 认购账号
    ,depositaccount varchar2(60) -- 存款账号
    ,valuedate varchar2(15) -- 起息日
    ,amt number(22,4) -- 金额
    ,prodcode varchar2(30) -- 产品编号
    ,prodname varchar2(600) -- 产品名称
    ,payinterest varchar2(15) -- 付息方式
    ,liabaccount varchar2(90) -- 负债账号
    ,ptyid varchar2(60) -- 客户号
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
grant select on ${iol_schema}.mims_si_ownerdeposit to ${iml_schema};
grant select on ${iol_schema}.mims_si_ownerdeposit to ${icl_schema};
grant select on ${iol_schema}.mims_si_ownerdeposit to ${idl_schema};
grant select on ${iol_schema}.mims_si_ownerdeposit to ${iel_schema};

-- comment
comment on table ${iol_schema}.mims_si_ownerdeposit is '本行存单';
comment on column ${iol_schema}.mims_si_ownerdeposit.sccode is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.certificatecode is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.stoppaymentmoney is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.account is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.startdate is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.enddate is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.duedate is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.rate is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.money is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.remark is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.childaccount is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.stoppayaccount is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.tdcurrency is '';
comment on column ${iol_schema}.mims_si_ownerdeposit.deposittype is '存单类型';
comment on column ${iol_schema}.mims_si_ownerdeposit.buyaccount is '认购账号';
comment on column ${iol_schema}.mims_si_ownerdeposit.depositaccount is '存款账号';
comment on column ${iol_schema}.mims_si_ownerdeposit.valuedate is '起息日';
comment on column ${iol_schema}.mims_si_ownerdeposit.amt is '金额';
comment on column ${iol_schema}.mims_si_ownerdeposit.prodcode is '产品编号';
comment on column ${iol_schema}.mims_si_ownerdeposit.prodname is '产品名称';
comment on column ${iol_schema}.mims_si_ownerdeposit.payinterest is '付息方式';
comment on column ${iol_schema}.mims_si_ownerdeposit.liabaccount is '负债账号';
comment on column ${iol_schema}.mims_si_ownerdeposit.ptyid is '客户号';
comment on column ${iol_schema}.mims_si_ownerdeposit.start_dt is '开始时间';
comment on column ${iol_schema}.mims_si_ownerdeposit.end_dt is '结束时间';
comment on column ${iol_schema}.mims_si_ownerdeposit.id_mark is '增删标志';
comment on column ${iol_schema}.mims_si_ownerdeposit.etl_timestamp is 'ETL处理时间戳';
