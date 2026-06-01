/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_dd_increase
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_dd_increase
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_dd_increase purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_dd_increase(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,dd_no number(5) -- 发放号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,appr_flag varchar2(1) -- 复核标志
    ,company varchar2(20) -- 法人
    ,counter number(5) -- 序号
    ,ddi_date date -- 增发日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,ddi_amt number(17,2) -- 增发金额
    ,loan_no varchar2(50) -- 贷款号
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
grant select on ${iol_schema}.ncbs_cl_dd_increase to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_dd_increase to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_dd_increase to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_dd_increase to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_dd_increase is '贷款增发表';
comment on column ${iol_schema}.ncbs_cl_dd_increase.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_dd_increase.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_dd_increase.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_cl_dd_increase.company is '法人';
comment on column ${iol_schema}.ncbs_cl_dd_increase.counter is '序号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.ddi_date is '增发日期';
comment on column ${iol_schema}.ncbs_cl_dd_increase.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_dd_increase.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_dd_increase.ddi_amt is '增发金额';
comment on column ${iol_schema}.ncbs_cl_dd_increase.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_dd_increase.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_dd_increase.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_dd_increase.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_dd_increase.etl_timestamp is 'ETL处理时间戳';
