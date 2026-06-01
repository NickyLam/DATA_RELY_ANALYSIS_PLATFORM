/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_creditcardcondition
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_creditcardcondition
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_creditcardcondition purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_creditcardcondition(
    serialno varchar2(40) -- 流水号
    ,inputuserid varchar2(32) -- 登记人
    ,creditcardnum number(22) -- 信用卡张数
    ,reportno varchar2(80) -- 报告编号
    ,overduebalance number(24,6) -- 逾期金额
    ,inputorgid varchar2(32) -- 登记机构
    ,change1 number(24,6) -- 与前期相比变化
    ,inputdate date -- 登记日期
    ,creditcardchange number(22) -- 信用卡变化数
    ,usedcreditsum number(24,6) -- 实际使用额度
    ,customername varchar2(80) -- 信用卡用户名称
    ,updatedate date -- 更新日期
    ,querydate date -- 查询日期
    ,creditsum number(24,6) -- 信用卡总额度
    ,userate number(24,6) -- 信用卡使用占比
    ,orgsumcheck number(22) -- 信用卡银行变化数
    ,mfcustomerid varchar2(40) -- 核心客户号
    ,migtflag varchar2(80) -- 
    ,orgsum number(22) -- 信用卡银行数
    ,customerid varchar2(32) -- 客户编号
    ,change2 number(24,6) -- 与前期相比变化
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
grant select on ${iol_schema}.icms_afterloan_creditcardcondition to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardcondition to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardcondition to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_creditcardcondition to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_creditcardcondition is '同业信用卡情况表';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.creditcardnum is '信用卡张数';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.reportno is '报告编号';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.overduebalance is '逾期金额';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.change1 is '与前期相比变化';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.creditcardchange is '信用卡变化数';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.usedcreditsum is '实际使用额度';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.customername is '信用卡用户名称';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.updatedate is '更新日期';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.querydate is '查询日期';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.creditsum is '信用卡总额度';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.userate is '信用卡使用占比';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.orgsumcheck is '信用卡银行变化数';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.mfcustomerid is '核心客户号';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.migtflag is '';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.orgsum is '信用卡银行数';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.customerid is '客户编号';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.change2 is '与前期相比变化';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_creditcardcondition.etl_timestamp is 'ETL处理时间戳';
