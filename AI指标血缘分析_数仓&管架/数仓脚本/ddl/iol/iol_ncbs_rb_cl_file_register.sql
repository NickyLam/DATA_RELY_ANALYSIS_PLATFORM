/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_cl_file_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_cl_file_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_cl_file_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_cl_file_register(
    file_name varchar2(200) -- 文件名称
    ,file_path varchar2(200) -- 文件路径
    ,company varchar2(20) -- 法人
    ,exe_id varchar2(50) -- 执行id
    ,file_class varchar2(5) -- 文件种类
    ,file_desc varchar2(50) -- 文件描述
    ,seq_no varchar2(50) -- 序号
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_cl_file_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_cl_file_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_cl_file_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_cl_file_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_cl_file_register is '存贷文件登记表';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.file_name is '文件名称';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.file_path is '文件路径';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.exe_id is '执行id';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.file_class is '文件种类';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.file_desc is '文件描述';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_cl_file_register.etl_timestamp is 'ETL处理时间戳';
