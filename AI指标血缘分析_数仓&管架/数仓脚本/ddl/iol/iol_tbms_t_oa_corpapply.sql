/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbms_t_oa_corpapply
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbms_t_oa_corpapply
whenever sqlerror continue none;
drop table ${iol_schema}.tbms_t_oa_corpapply purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbms_t_oa_corpapply(
    flowid number(10) -- 流程ID
    ,flowname varchar2(150) -- 流程名称
    ,cpytempletid number(20) -- 企业模板ID
    ,companyid number(20) -- 企业ID
    ,uaid number(20) -- 发起者
    ,applyuaid number(20) -- 申请人
    ,status number(4) -- 流程状态0.进行中 1.通过 2.不通过 3.撤回 4.转交 10.归档
    ,content varchar2(4000) -- 申请内容
    ,summary varchar2(512) -- 流程要素
    ,sys_ctime date -- 系统-创建时间
    ,sys_utime date -- 系统-修改时间
    ,sys_valid number(4) -- 系统-有效状态
    ,lockstatus number(4) -- 锁定状态 0：不锁定；1：锁定
    ,printcount number(20) -- 打印计数
    ,appletuaid number(20) -- 小应用Id
    ,flowsourcetype number(4) -- 1：普通审批（事务审批和支付审批）；2：复核审批   默认为1
    ,pid number(10) -- 流程Id
    ,clientinfo varchar2(1024) -- 存储客户信息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbms_t_oa_corpapply to ${iml_schema};
grant select on ${iol_schema}.tbms_t_oa_corpapply to ${icl_schema};
grant select on ${iol_schema}.tbms_t_oa_corpapply to ${idl_schema};
grant select on ${iol_schema}.tbms_t_oa_corpapply to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbms_t_oa_corpapply is 'OA审批';
comment on column ${iol_schema}.tbms_t_oa_corpapply.flowid is '流程ID';
comment on column ${iol_schema}.tbms_t_oa_corpapply.flowname is '流程名称';
comment on column ${iol_schema}.tbms_t_oa_corpapply.cpytempletid is '企业模板ID';
comment on column ${iol_schema}.tbms_t_oa_corpapply.companyid is '企业ID';
comment on column ${iol_schema}.tbms_t_oa_corpapply.uaid is '发起者';
comment on column ${iol_schema}.tbms_t_oa_corpapply.applyuaid is '申请人';
comment on column ${iol_schema}.tbms_t_oa_corpapply.status is '流程状态0.进行中 1.通过 2.不通过 3.撤回 4.转交 10.归档';
comment on column ${iol_schema}.tbms_t_oa_corpapply.content is '申请内容';
comment on column ${iol_schema}.tbms_t_oa_corpapply.summary is '流程要素';
comment on column ${iol_schema}.tbms_t_oa_corpapply.sys_ctime is '系统-创建时间';
comment on column ${iol_schema}.tbms_t_oa_corpapply.sys_utime is '系统-修改时间';
comment on column ${iol_schema}.tbms_t_oa_corpapply.sys_valid is '系统-有效状态';
comment on column ${iol_schema}.tbms_t_oa_corpapply.lockstatus is '锁定状态 0：不锁定；1：锁定';
comment on column ${iol_schema}.tbms_t_oa_corpapply.printcount is '打印计数';
comment on column ${iol_schema}.tbms_t_oa_corpapply.appletuaid is '小应用Id';
comment on column ${iol_schema}.tbms_t_oa_corpapply.flowsourcetype is '1：普通审批（事务审批和支付审批）；2：复核审批   默认为1';
comment on column ${iol_schema}.tbms_t_oa_corpapply.pid is '流程Id';
comment on column ${iol_schema}.tbms_t_oa_corpapply.clientinfo is '存储客户信息';
comment on column ${iol_schema}.tbms_t_oa_corpapply.start_dt is '开始时间';
comment on column ${iol_schema}.tbms_t_oa_corpapply.end_dt is '结束时间';
comment on column ${iol_schema}.tbms_t_oa_corpapply.id_mark is '增删标志';
comment on column ${iol_schema}.tbms_t_oa_corpapply.etl_timestamp is 'ETL处理时间戳';
