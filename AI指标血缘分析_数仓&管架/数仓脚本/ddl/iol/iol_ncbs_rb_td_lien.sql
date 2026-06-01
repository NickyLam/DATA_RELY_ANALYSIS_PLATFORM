/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_td_lien
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_td_lien
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_td_lien purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_td_lien(
    client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,restraint_type varchar2(3) -- 限制类型
    ,company varchar2(20) -- 法人
    ,res_seq_no varchar2(50) -- 限制编号
    ,end_date date -- 结束日期
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,last_change_user_id varchar2(8) -- 最后修改柜员
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
grant select on ${iol_schema}.ncbs_rb_td_lien to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_td_lien to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_td_lien to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_td_lien to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_td_lien is '存单质押登记簿';
comment on column ${iol_schema}.ncbs_rb_td_lien.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_td_lien.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_td_lien.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_td_lien.restraint_type is '限制类型';
comment on column ${iol_schema}.ncbs_rb_td_lien.company is '法人';
comment on column ${iol_schema}.ncbs_rb_td_lien.res_seq_no is '限制编号';
comment on column ${iol_schema}.ncbs_rb_td_lien.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_td_lien.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_td_lien.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_td_lien.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_td_lien.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_rb_td_lien.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_td_lien.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_td_lien.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_td_lien.etl_timestamp is 'ETL处理时间戳';
