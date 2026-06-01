/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_ob_list_collection
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_ob_list_collection
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_ob_list_collection purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_ob_list_collection(
    task_code varchar2(50) -- 任务编号
    ,code varchar2(50) -- 主键
    ,work_tel varchar2(20) -- 单位电话
    ,home_tel varchar2(20) -- 家庭电话
    ,phone varchar2(20) -- 联系电话
    ,cust_name varchar2(50) -- 客户姓名
    ,cust_no varchar2(20) -- 客户号
    ,days number(22) -- 日期-最大逾期天数(催收)
    ,money number(10,2) -- 金额-合计逾期金额(催收)
    ,call_result varchar2(30) -- 外呼结果
    ,call_status varchar2(10) -- 外呼状态
    ,create_date date -- 创建时间
    ,creator_code varchar2(30) -- 创建人用户号
    ,creator_name varchar2(30) -- 创建姓名
    ,last_call_time date -- 最后呼叫时间
    ,data_stat number(22) -- 数据状态
    ,call_id varchar2(50) -- 最后的呼叫流水号
    ,succ_tel varchar2(20) -- 呼叫成功号码
    ,fail_code varchar2(50) -- 呼叫结果原因码
    ,max_call_count number(22) -- 最大呼叫次数
    ,call_count number(22) -- 已呼叫次数
    ,call_data varchar2(500) -- 播报内容
    ,batch_date varchar2(10) -- 跑批日期
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
grant select on ${iol_schema}.ccdb_ob_list_collection to ${iml_schema};
grant select on ${iol_schema}.ccdb_ob_list_collection to ${icl_schema};
grant select on ${iol_schema}.ccdb_ob_list_collection to ${idl_schema};
grant select on ${iol_schema}.ccdb_ob_list_collection to ${iel_schema};

-- comment
comment on table ${iol_schema}.ccdb_ob_list_collection is '自动外呼催收语音播报客户名单';
comment on column ${iol_schema}.ccdb_ob_list_collection.task_code is '任务编号';
comment on column ${iol_schema}.ccdb_ob_list_collection.code is '主键';
comment on column ${iol_schema}.ccdb_ob_list_collection.work_tel is '单位电话';
comment on column ${iol_schema}.ccdb_ob_list_collection.home_tel is '家庭电话';
comment on column ${iol_schema}.ccdb_ob_list_collection.phone is '联系电话';
comment on column ${iol_schema}.ccdb_ob_list_collection.cust_name is '客户姓名';
comment on column ${iol_schema}.ccdb_ob_list_collection.cust_no is '客户号';
comment on column ${iol_schema}.ccdb_ob_list_collection.days is '日期-最大逾期天数(催收)';
comment on column ${iol_schema}.ccdb_ob_list_collection.money is '金额-合计逾期金额(催收)';
comment on column ${iol_schema}.ccdb_ob_list_collection.call_result is '外呼结果';
comment on column ${iol_schema}.ccdb_ob_list_collection.call_status is '外呼状态';
comment on column ${iol_schema}.ccdb_ob_list_collection.create_date is '创建时间';
comment on column ${iol_schema}.ccdb_ob_list_collection.creator_code is '创建人用户号';
comment on column ${iol_schema}.ccdb_ob_list_collection.creator_name is '创建姓名';
comment on column ${iol_schema}.ccdb_ob_list_collection.last_call_time is '最后呼叫时间';
comment on column ${iol_schema}.ccdb_ob_list_collection.data_stat is '数据状态';
comment on column ${iol_schema}.ccdb_ob_list_collection.call_id is '最后的呼叫流水号';
comment on column ${iol_schema}.ccdb_ob_list_collection.succ_tel is '呼叫成功号码';
comment on column ${iol_schema}.ccdb_ob_list_collection.fail_code is '呼叫结果原因码';
comment on column ${iol_schema}.ccdb_ob_list_collection.max_call_count is '最大呼叫次数';
comment on column ${iol_schema}.ccdb_ob_list_collection.call_count is '已呼叫次数';
comment on column ${iol_schema}.ccdb_ob_list_collection.call_data is '播报内容';
comment on column ${iol_schema}.ccdb_ob_list_collection.batch_date is '跑批日期';
comment on column ${iol_schema}.ccdb_ob_list_collection.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_ob_list_collection.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_ob_list_collection.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_ob_list_collection.etl_timestamp is 'ETL处理时间戳';
