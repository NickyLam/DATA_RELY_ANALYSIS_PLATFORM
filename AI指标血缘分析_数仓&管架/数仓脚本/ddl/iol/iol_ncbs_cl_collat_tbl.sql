/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_collat_tbl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_collat_tbl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_collat_tbl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_collat_tbl(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,dd_no number(5) -- 发放号
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,coll_ref varchar2(50) -- 贷款抵押品编号
    ,collat_name varchar2(200) -- 抵押品名称
    ,collat_type varchar2(10) -- 抵押品种类
    ,company varchar2(20) -- 法人
    ,inner_flag varchar2(1) -- 是否本行
    ,narrative varchar2(400) -- 摘要
    ,owner varchar2(200) -- 抵质押人名称
    ,owner_no varchar2(16) -- 权利人客户编号
    ,restraint_seq_no varchar2(50) -- 冻结编号
    ,source_type varchar2(6) -- 渠道编号
    ,verify_flag varchar2(1) -- 是否核实后禁止
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,collat_value number(17,2) -- 押品账面价值
    ,loan_no varchar2(50) -- 贷款号
    ,collat_status varchar2(2) -- 抵押品状态
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
grant select on ${iol_schema}.ncbs_cl_collat_tbl to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_collat_tbl to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_collat_tbl to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_collat_tbl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_collat_tbl is '抵质押品登记薄';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.dd_no is '发放号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.coll_ref is '贷款抵押品编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.collat_name is '抵押品名称';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.collat_type is '抵押品种类';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.company is '法人';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.inner_flag is '是否本行';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.owner is '抵质押人名称';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.owner_no is '权利人客户编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.restraint_seq_no is '冻结编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.verify_flag is '是否核实后禁止';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.collat_value is '押品账面价值';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.collat_status is '抵押品状态';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_collat_tbl.etl_timestamp is 'ETL处理时间戳';
