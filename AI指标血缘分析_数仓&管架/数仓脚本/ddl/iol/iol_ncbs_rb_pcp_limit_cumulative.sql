/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_pcp_limit_cumulative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_pcp_limit_cumulative
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_pcp_limit_cumulative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_pcp_limit_cumulative(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,limit_num number(5) -- 累计笔数
    ,limit_type varchar2(2) -- 限额类型
    ,total_key varchar2(30) -- 累计额度编号
    ,last_change_date date -- 最后修改日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,limit_amt number(17,2) -- 累计额度金额
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
grant select on ${iol_schema}.ncbs_rb_pcp_limit_cumulative to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_limit_cumulative to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_limit_cumulative to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_pcp_limit_cumulative to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_pcp_limit_cumulative is '分户限额累计表';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.company is '法人';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.limit_num is '累计笔数';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.limit_type is '限额类型';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.total_key is '累计额度编号';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.limit_amt is '累计额度金额';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_pcp_limit_cumulative.etl_timestamp is 'ETL处理时间戳';
