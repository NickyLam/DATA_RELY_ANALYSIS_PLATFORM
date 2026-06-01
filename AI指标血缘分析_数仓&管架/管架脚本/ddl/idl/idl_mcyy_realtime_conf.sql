/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_realtime_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_realtime_conf
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_realtime_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_realtime_conf(
    cfg_id varchar2(30) -- 配置编号
    ,cfg_desc varchar2(200) -- 配置描述
    ,index_no varchar2(30) -- 指标编码
    ,index_name varchar2(200) -- 指标名称
    ,sum_frequency number(4,0) -- 统计频率
    ,sts number(1,0) -- 配置状态
    ,val_time timestamp(6) -- 生效时间
    ,exp_time timestamp(6) -- 失效时间
    ,vision varchar2(30) -- 版本号
    ,data_source_desc varchar2(300) -- 数据来源描述
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_realtime_conf to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_realtime_conf is '准实时跑数配置表';
comment on column ${idl_schema}.mcyy_realtime_conf.cfg_id is '配置编号';
comment on column ${idl_schema}.mcyy_realtime_conf.cfg_desc is '配置描述';
comment on column ${idl_schema}.mcyy_realtime_conf.index_no is '指标编码';
comment on column ${idl_schema}.mcyy_realtime_conf.index_name is '指标名称';
comment on column ${idl_schema}.mcyy_realtime_conf.sum_frequency is '统计频率';
comment on column ${idl_schema}.mcyy_realtime_conf.sts is '配置状态';
comment on column ${idl_schema}.mcyy_realtime_conf.val_time is '生效时间';
comment on column ${idl_schema}.mcyy_realtime_conf.exp_time is '失效时间';
comment on column ${idl_schema}.mcyy_realtime_conf.vision is '版本号';
comment on column ${idl_schema}.mcyy_realtime_conf.data_source_desc is '数据来源描述';


prompt Disabling triggers for MCYY_REALTIME_CONF...
alter table MCYY_REALTIME_CONF disable all triggers;
prompt Deleting MCYY_REALTIME_CONF...
delete from MCYY_REALTIME_CONF;
commit;
prompt Loading MCYY_REALTIME_CONF...
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1002', 'T+0:对公账户开户数', 'WD030101', '对公账户开户数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '核心');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1003', 'T+0:个人账户开户数', 'WD030201', '个人账户开户数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '核心');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1004', 'T+0:对公账户累计户数', 'WD030207', '对公账户累计户数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '核心');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1005', 'T+0:个人账户累计户数', 'WD030215', '个人账户累计户数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '核心');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1006', 'T+0:支付业务交易量', 'WD040101', '支付业务交易量', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '统一支付');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1007', 'T+0:支付业务交易额', 'WD040102', '支付业务交易额', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '统一支付');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1008', 'T+0:全渠道交易量', 'WD040201', '全渠道交易量', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '营运预警');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1009', 'T+0:全渠道交易额', 'WD040202', '全渠道交易额', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '营运预警');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1010', 'T+0:集中授权总任务数', 'JZ010101', '集中授权总任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '新柜面');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1011', 'T+0:集中授权已处理任务数', 'JZ010102', '集中授权已处理任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '新柜面');
commit;
prompt 10 records committed...
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1012', 'T+0:集中授权等待中任务数', 'JZ010103', '集中授权等待中任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '新柜面');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1013', 'T+0:集中授权处理中任务数', 'JZ010104', '集中授权处理中任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '新柜面');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1014', 'T+0:流程银行总任务数', 'JZ020101', '流程银行总任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '流程银行');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1015', 'T+0:流程银行已处理任务数', 'JZ020102', '流程银行已处理任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '流程银行');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1016', 'T+0:流程银行等待中任务数', 'JZ020103', '流程银行等待中任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '流程银行');
insert into MCYY_REALTIME_CONF (cfg_id, cfg_desc, index_no, index_name, sum_frequency, sts, val_time, exp_time, vision, data_source_desc)
values ('1017', 'T+0:流程银行处理中任务数', 'JZ020104', '流程银行处理中任务数', 5, 1, to_timestamp('01-01-2020 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), to_timestamp('31-12-2099 00:00:00.000000', 'dd-mm-yyyy hh24:mi:ss.ff'), '1.0', '流程银行');
commit;
prompt 16 records loaded
prompt Enabling triggers for MCYY_REALTIME_CONF...
alter table MCYY_REALTIME_CONF enable all triggers;
set feedback on
set define on
prompt Done.
