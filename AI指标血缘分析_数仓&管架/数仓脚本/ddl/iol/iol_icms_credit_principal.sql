/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_principal
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_principal
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_principal purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_principal(
    serialno varchar2(40) -- 流水号
    ,attribute3 varchar2(32) -- 
    ,attribute1 varchar2(32) -- 还款流水
    ,paymentaccountno varchar2(40) -- 还款账号
    ,signuptype varchar2(10) -- 签约类型
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,duebillserialno varchar2(40) -- 借据流水号
    ,repayserialno varchar2(32) -- 还款流水号
    ,principalsum number(24,6) -- 还本金额
    ,billtype varchar2(2) -- 账单类型
    ,principaldate varchar2(10) -- 还本日期
    ,lssuenumber varchar2(32) -- 期号
    ,businesscurrency varchar2(18) -- 货币种类
    ,attribute2 varchar2(32) -- 期号
    ,attribute4 varchar2(32) -- 
    ,paymentsubaccountno varchar2(5) -- 还款子户号
    ,paymentsum number(18,2) -- 还款金额
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
grant select on ${iol_schema}.icms_credit_principal to ${iml_schema};
grant select on ${iol_schema}.icms_credit_principal to ${icl_schema};
grant select on ${iol_schema}.icms_credit_principal to ${idl_schema};
grant select on ${iol_schema}.icms_credit_principal to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_principal is '还本信息';
comment on column ${iol_schema}.icms_credit_principal.serialno is '流水号';
comment on column ${iol_schema}.icms_credit_principal.attribute3 is '';
comment on column ${iol_schema}.icms_credit_principal.attribute1 is '还款流水';
comment on column ${iol_schema}.icms_credit_principal.paymentaccountno is '还款账号';
comment on column ${iol_schema}.icms_credit_principal.signuptype is '签约类型';
comment on column ${iol_schema}.icms_credit_principal.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_credit_principal.duebillserialno is '借据流水号';
comment on column ${iol_schema}.icms_credit_principal.repayserialno is '还款流水号';
comment on column ${iol_schema}.icms_credit_principal.principalsum is '还本金额';
comment on column ${iol_schema}.icms_credit_principal.billtype is '账单类型';
comment on column ${iol_schema}.icms_credit_principal.principaldate is '还本日期';
comment on column ${iol_schema}.icms_credit_principal.lssuenumber is '期号';
comment on column ${iol_schema}.icms_credit_principal.businesscurrency is '货币种类';
comment on column ${iol_schema}.icms_credit_principal.attribute2 is '期号';
comment on column ${iol_schema}.icms_credit_principal.attribute4 is '';
comment on column ${iol_schema}.icms_credit_principal.paymentsubaccountno is '还款子户号';
comment on column ${iol_schema}.icms_credit_principal.paymentsum is '还款金额';
comment on column ${iol_schema}.icms_credit_principal.start_dt is '开始时间';
comment on column ${iol_schema}.icms_credit_principal.end_dt is '结束时间';
comment on column ${iol_schema}.icms_credit_principal.id_mark is '增删标志';
comment on column ${iol_schema}.icms_credit_principal.etl_timestamp is 'ETL处理时间戳';
