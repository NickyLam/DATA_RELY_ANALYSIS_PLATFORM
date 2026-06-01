/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_batch_sl_sign_close_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail(
    batch_file_status varchar2(1) -- 批处理文件处理状态
    ,company varchar2(20) -- 法人
    ,error_msg varchar2(3000) -- 错误代码
    ,exe_id varchar2(50) -- 执行id
    ,seq_no varchar2(50) -- 序号
    ,unsign_operate_type varchar2(2) -- 解约操作类型
    ,run_date date -- 运行日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail is '特殊贷款产品批处理自动解约和终止登记表';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.batch_file_status is '批处理文件处理状态';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.company is '法人';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.error_msg is '错误代码';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.exe_id is '执行id';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.unsign_operate_type is '解约操作类型';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.run_date is '运行日期';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_batch_sl_sign_close_detail.etl_timestamp is 'ETL处理时间戳';
