/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_cust_save_mobile_no
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_cust_save_mobile_no
whenever sqlerror continue none;
drop table ${iml_schema}.pty_cust_save_mobile_no purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_cust_save_mobile_no(
    party_id varchar2(100) -- 当事人编号
    ,lp_id varchar2(60) -- 法人编号
    ,save_mobile_no varchar2(60) -- 安全手机号码
    ,save_mobile_no_status_cd varchar2(30) -- 安全手机号码状态代码
    ,user_seq_num varchar2(60) -- 用户顺序号
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.pty_cust_save_mobile_no to ${icl_schema};
grant select on ${iml_schema}.pty_cust_save_mobile_no to ${idl_schema};
grant select on ${iml_schema}.pty_cust_save_mobile_no to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_cust_save_mobile_no is '客户安全手机号';
comment on column ${iml_schema}.pty_cust_save_mobile_no.party_id is '当事人编号';
comment on column ${iml_schema}.pty_cust_save_mobile_no.lp_id is '法人编号';
comment on column ${iml_schema}.pty_cust_save_mobile_no.save_mobile_no is '安全手机号码';
comment on column ${iml_schema}.pty_cust_save_mobile_no.save_mobile_no_status_cd is '安全手机号码状态代码';
comment on column ${iml_schema}.pty_cust_save_mobile_no.user_seq_num is '用户顺序号';
comment on column ${iml_schema}.pty_cust_save_mobile_no.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.pty_cust_save_mobile_no.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_cust_save_mobile_no.job_cd is '任务编码';
comment on column ${iml_schema}.pty_cust_save_mobile_no.etl_timestamp is 'ETL处理时间戳';
