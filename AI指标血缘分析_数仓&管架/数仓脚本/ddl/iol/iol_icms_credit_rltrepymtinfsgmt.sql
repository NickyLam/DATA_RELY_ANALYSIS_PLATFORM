/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_rltrepymtinfsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_rltrepymtinfsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_rltrepymtinfsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_rltrepymtinfsgmt(
    create_time varchar2(19) -- 入库时间
    ,maxguarmcc varchar2(60) -- 保证合同编号
    ,cust_no varchar2(64) -- 客户号码
    ,infoidtype varchar2(1) -- 身份类别
    ,acctcode varchar2(60) -- 账户标识码
    ,arlpname varchar2(80) -- 责任人名称
    ,arlpcerttype varchar2(4) -- 责任人身份标识类型
    ,arlpcertnum varchar2(40) -- 责任人身份标识号码
    ,arlpamt number(24,6) -- 还款责任金额
    ,deptcode varchar2(14) -- 征信机构代码
    ,wartysign varchar2(1) -- 联保标志
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,rptdate varchar2(19) -- 信息报告日期
    ,rltrepymtnm varchar2(2) -- 责任人个数
    ,arlptype varchar2(4) -- 还款责任人类型
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
grant select on ${iol_schema}.icms_credit_rltrepymtinfsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_rltrepymtinfsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_rltrepymtinfsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_rltrepymtinfsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_rltrepymtinfsgmt is '个人借贷账户记录-相关还责款任人段';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.maxguarmcc is '保证合同编号';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.infoidtype is '身份类别';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.arlpname is '责任人名称';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.arlpcerttype is '责任人身份标识类型';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.arlpcertnum is '责任人身份标识号码';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.arlpamt is '还款责任金额';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.wartysign is '联保标志';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.rltrepymtnm is '责任人个数';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.arlptype is '还款责任人类型';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_rltrepymtinfsgmt.etl_timestamp is 'ETL处理时间戳';
