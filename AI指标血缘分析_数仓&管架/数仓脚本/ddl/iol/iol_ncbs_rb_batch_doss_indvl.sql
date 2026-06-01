/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_doss_indvl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_doss_indvl
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_doss_indvl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_doss_indvl(
    com_doss_flag varchar2(1) -- 对公转久悬导入标志
    ,company varchar2(20) -- 法人
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,per_amt_doss number(17,2) -- 对私转久悬金额
    ,per_amt_tot number(17,2) -- 对私转久悬总金额
    ,per_amt_withdraw number(17,2) -- 对私久悬户转出总金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_batch_doss_indvl to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_indvl to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_indvl to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_doss_indvl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_doss_indvl is '久悬户导入信息统计表(只含已成功导入)';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.com_doss_flag is '对公转久悬导入标志';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.per_amt_doss is '对私转久悬金额';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.per_amt_tot is '对私转久悬总金额';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.per_amt_withdraw is '对私久悬户转出总金额';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_batch_doss_indvl.etl_timestamp is 'ETL处理时间戳';
