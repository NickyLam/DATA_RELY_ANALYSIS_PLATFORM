/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_loan_adj_int_eso
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_loan_adj_int_eso
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_loan_adj_int_eso purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_loan_adj_int_eso(
    contractno varchar2(64) -- 借呗平台贷款合同号
    ,settledate varchar2(8) -- 会计日T日
    ,adjintbal number(24,6) -- 利息调整余额（单位分）
    ,duedays number(24,6) -- 到期剩余天数
    ,adjintamt number(24,6) -- 利息调整金额（单位分）
    ,direction varchar2(8) -- 方向
    ,bsntype varchar2(64) -- 产品业务类型
    ,regioncode varchar2(8) -- 行政区划
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
grant select on ${iol_schema}.icms_mybk_loan_adj_int_eso to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_loan_adj_int_eso to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_loan_adj_int_eso to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_loan_adj_int_eso to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_loan_adj_int_eso is '网商贷利息调整计提文件中间表-债权直转';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.contractno is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.settledate is '会计日T日';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.adjintbal is '利息调整余额（单位分）';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.duedays is '到期剩余天数';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.adjintamt is '利息调整金额（单位分）';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.direction is '方向';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.regioncode is '行政区划';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_loan_adj_int_eso.etl_timestamp is 'ETL处理时间戳';
