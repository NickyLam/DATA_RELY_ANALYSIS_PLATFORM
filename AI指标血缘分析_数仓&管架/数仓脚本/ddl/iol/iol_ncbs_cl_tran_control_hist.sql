/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_tran_control_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_tran_control_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_tran_control_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_tran_control_hist(
    branch varchar2(12) -- 机构编号
    ,reference varchar2(50) -- 交易参考号
    ,timestamp varchar2(26) -- 时间戳
    ,busi_category varchar2(20) -- 业务分类
    ,busi_sub_class varchar2(10) -- 业务子细类
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,channel_sub_seq_no varchar2(50) -- 渠道子流水号
    ,company varchar2(20) -- 法人
    ,message_code varchar2(10) -- 接口服务代码
    ,message_type varchar2(10) -- 接口服务类型
    ,service_code varchar2(20) -- 服务代码
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_status varchar2(1) -- 冲补抹标志
    ,channel_date date -- 渠道日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_cl_tran_control_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_tran_control_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_control_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_tran_control_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_tran_control_hist is '交易流程控制表';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.timestamp is '时间戳';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.busi_category is '业务分类';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.busi_sub_class is '业务子细类';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.channel_sub_seq_no is '渠道子流水号';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.company is '法人';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.message_code is '接口服务代码';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.message_type is '接口服务类型';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.service_code is '服务代码';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_tran_control_hist.etl_timestamp is 'ETL处理时间戳';
