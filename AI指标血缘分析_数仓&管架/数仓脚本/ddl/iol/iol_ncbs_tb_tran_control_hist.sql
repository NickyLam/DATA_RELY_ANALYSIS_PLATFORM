/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_tb_tran_control_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_tb_tran_control_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_tb_tran_control_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_tran_control_hist(
    client_no varchar2(16) -- 客户编号
    ,reference varchar2(50) -- 交易参考号
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,message_code varchar2(10) -- 接口服务代码
    ,message_type varchar2(10) -- 接口服务类型
    ,service_code varchar2(20) -- 服务代码
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,tran_status varchar2(1) -- 冲补抹标志
    ,channel_date date -- 渠道日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_tb_tran_control_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_tb_tran_control_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_tb_tran_control_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_tb_tran_control_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_tb_tran_control_hist is '交易流程控制表';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.company is '法人';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.message_code is '接口服务代码';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.message_type is '接口服务类型';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.service_code is '服务代码';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.channel_date is '渠道日期';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_tb_tran_control_hist.etl_timestamp is 'ETL处理时间戳';
