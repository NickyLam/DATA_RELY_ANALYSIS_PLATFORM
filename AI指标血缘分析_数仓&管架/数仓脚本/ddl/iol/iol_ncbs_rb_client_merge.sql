/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_client_merge
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_client_merge
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_client_merge purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_client_merge(
    user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,merge_flag varchar2(2) -- 合并状态
    ,merge_no varchar2(50) -- 合并编号
    ,merge_date date -- 合并日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,ch_client_name_a varchar2(200) -- 客户中文名1
    ,ch_client_name_b varchar2(200) -- 客户中文名2
    ,client_a varchar2(16) -- 客户a
    ,client_b varchar2(16) -- 客户b
    ,document_type_a varchar2(3) -- 被合并客户证件类型
    ,document_id_a varchar2(50) -- 被合并客户证件号码
    ,document_type_b varchar2(3) -- 合并目标客户证件类型
    ,document_id_b varchar2(50) -- 合并目标客户证件号码
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
grant select on ${iol_schema}.ncbs_rb_client_merge to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_client_merge to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_client_merge to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_client_merge to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_client_merge is '客户合并信息表';
comment on column ${iol_schema}.ncbs_rb_client_merge.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_client_merge.company is '法人';
comment on column ${iol_schema}.ncbs_rb_client_merge.merge_flag is '合并状态';
comment on column ${iol_schema}.ncbs_rb_client_merge.merge_no is '合并编号';
comment on column ${iol_schema}.ncbs_rb_client_merge.merge_date is '合并日期';
comment on column ${iol_schema}.ncbs_rb_client_merge.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_client_merge.ch_client_name_a is '客户中文名1';
comment on column ${iol_schema}.ncbs_rb_client_merge.ch_client_name_b is '客户中文名2';
comment on column ${iol_schema}.ncbs_rb_client_merge.client_a is '客户a';
comment on column ${iol_schema}.ncbs_rb_client_merge.client_b is '客户b';
comment on column ${iol_schema}.ncbs_rb_client_merge.document_type_a is '被合并客户证件类型';
comment on column ${iol_schema}.ncbs_rb_client_merge.document_id_a is '被合并客户证件号码';
comment on column ${iol_schema}.ncbs_rb_client_merge.document_type_b is '合并目标客户证件类型';
comment on column ${iol_schema}.ncbs_rb_client_merge.document_id_b is '合并目标客户证件号码';
comment on column ${iol_schema}.ncbs_rb_client_merge.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_client_merge.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_client_merge.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_client_merge.etl_timestamp is 'ETL处理时间戳';
