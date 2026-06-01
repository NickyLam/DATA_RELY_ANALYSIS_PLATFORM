/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_appr_letter_sub
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_appr_letter_sub
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_appr_letter_sub purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_appr_letter_sub(
    ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,appr_letter_no varchar2(30) -- 核准件编号
    ,company varchar2(20) -- 法人
    ,main_sub_ind varchar2(1) -- 核准件主子标志
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_limit_amt number(17,2) -- 核准件限额
    ,cr_total_amt number(17,2) -- 贷方总金额
    ,dr_total_amt number(17,2) -- 借方金额
    ,grace_amt number(17,2) -- 浮动金额
    ,grace_proportion number(10,6) -- 浮动比例
    ,remark varchar2(600) -- 备注
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
grant select on ${iol_schema}.ncbs_rb_appr_letter_sub to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_sub to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_sub to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_sub to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_appr_letter_sub is '核准件子表信息';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.appr_letter_no is '核准件编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.company is '法人';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.main_sub_ind is '核准件主子标志';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.appr_limit_amt is '核准件限额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.cr_total_amt is '贷方总金额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.dr_total_amt is '借方金额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.grace_amt is '浮动金额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.grace_proportion is '浮动比例';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_appr_letter_sub.etl_timestamp is 'ETL处理时间戳';
