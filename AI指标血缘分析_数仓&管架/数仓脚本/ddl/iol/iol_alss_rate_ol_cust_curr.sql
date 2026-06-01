/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alss_rate_ol_cust_curr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alss_rate_ol_cust_curr
whenever sqlerror continue none;
drop table ${iol_schema}.alss_rate_ol_cust_curr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_rate_ol_cust_curr(
    curr_id number(20,0) -- 主键
    ,rate_id varchar2(180) -- 商户号(主键)
    ,rate_name varchar2(225) -- 商户名称
    ,chanl_code varchar2(225) -- 场景code
    ,chanl_name varchar2(225) -- 场景名称
    ,model_code varchar2(225) -- 模型code
    ,model_name varchar2(225) -- 模型名称
    ,event_code varchar2(225) -- 事件code
    ,event_name varchar2(225) -- 事件名称
    ,method_code varchar2(225) -- 触发方式
    ,method_name varchar2(225) -- 触发方式名称
    ,score varchar2(45) -- 分值
    ,level_name varchar2(225) -- 评分等级名称
    ,namelist varchar2(225) -- 所属名单
    ,oper varchar2(225) -- 更新者
    ,rate_time timestamp -- 评级时间
    ,next_rate_time timestamp -- 下次评级时间
    ,state number(2,0) -- 状态(0：关闭评级；1：开启评级)
    ,develop_dept varchar2(383) -- 运营机构
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,cust_type varchar2(48) -- 
    ,view_status varchar2(15) -- 
    ,risk_list varchar2(750) -- 上一次评级命中黑名单
    ,risk_time timestamp -- 上一次评级命中黑名单时间
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
grant select on ${iol_schema}.alss_rate_ol_cust_curr to ${iml_schema};
grant select on ${iol_schema}.alss_rate_ol_cust_curr to ${icl_schema};
grant select on ${iol_schema}.alss_rate_ol_cust_curr to ${idl_schema};
grant select on ${iol_schema}.alss_rate_ol_cust_curr to ${iel_schema};

-- comment
comment on table ${iol_schema}.alss_rate_ol_cust_curr is '客户评级信息';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.curr_id is '主键';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.rate_id is '商户号(主键)';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.rate_name is '商户名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.chanl_code is '场景code';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.chanl_name is '场景名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.model_code is '模型code';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.model_name is '模型名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.event_code is '事件code';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.event_name is '事件名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.method_code is '触发方式';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.method_name is '触发方式名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.score is '分值';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.level_name is '评分等级名称';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.namelist is '所属名单';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.oper is '更新者';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.rate_time is '评级时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.next_rate_time is '下次评级时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.state is '状态(0：关闭评级；1：开启评级)';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.develop_dept is '运营机构';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.create_time is '创建时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.update_time is '更新时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.cust_type is '';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.view_status is '';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.risk_list is '上一次评级命中黑名单';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.risk_time is '上一次评级命中黑名单时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.start_dt is '开始时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.end_dt is '结束时间';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.id_mark is '增删标志';
comment on column ${iol_schema}.alss_rate_ol_cust_curr.etl_timestamp is 'ETL处理时间戳';
