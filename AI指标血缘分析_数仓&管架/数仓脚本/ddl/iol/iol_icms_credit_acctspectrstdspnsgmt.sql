/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_credit_acctspectrstdspnsgmt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_credit_acctspectrstdspnsgmt
whenever sqlerror continue none;
drop table ${iol_schema}.icms_credit_acctspectrstdspnsgmt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_credit_acctspectrstdspnsgmt(
    rptdate varchar2(19) -- 信息报告日期
    ,create_time varchar2(19) -- 入库时间
    ,cagoftrdnm varchar2(2) -- 交易个数
    ,top_deptcode varchar2(14) -- 顶级征信机构代码
    ,trandate varchar2(19) -- 交易日期
    ,cust_no varchar2(64) -- 客户号码
    ,detinfo varchar2(200) -- 交易明细信息
    ,deptcode varchar2(14) -- 征信机构代码
    ,acctcode varchar2(60) -- 账户标识码
    ,chantrantype varchar2(4) -- 交易类型
    ,tranamt varchar2(15) -- 交易金额
    ,duetranmon varchar2(3) -- 到期日期变更月数
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
grant select on ${iol_schema}.icms_credit_acctspectrstdspnsgmt to ${iml_schema};
grant select on ${iol_schema}.icms_credit_acctspectrstdspnsgmt to ${icl_schema};
grant select on ${iol_schema}.icms_credit_acctspectrstdspnsgmt to ${idl_schema};
grant select on ${iol_schema}.icms_credit_acctspectrstdspnsgmt to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_credit_acctspectrstdspnsgmt is '个人借贷账户记录-特殊交易说明段';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.rptdate is '信息报告日期';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.create_time is '入库时间';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.cagoftrdnm is '交易个数';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.top_deptcode is '顶级征信机构代码';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.trandate is '交易日期';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.cust_no is '客户号码';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.detinfo is '交易明细信息';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.deptcode is '征信机构代码';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.acctcode is '账户标识码';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.chantrantype is '交易类型';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.tranamt is '交易金额';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.duetranmon is '到期日期变更月数';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_credit_acctspectrstdspnsgmt.etl_timestamp is 'ETL处理时间戳';
