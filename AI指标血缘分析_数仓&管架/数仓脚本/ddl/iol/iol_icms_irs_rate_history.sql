/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_irs_rate_history
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_irs_rate_history
whenever sqlerror continue none;
drop table ${iol_schema}.icms_irs_rate_history purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_irs_rate_history(
    adjustlevel varchar2(2) -- 调整等级
    ,applyid varchar2(64) -- 评级申请Id
    ,balance number(22,8) -- 当时余额
    ,customerid varchar2(64) -- 客户ID
    ,datasource varchar2(1) -- 数据来源 1.申请2.跑批3.老评级
    ,finallevel varchar2(2) -- 确认级别
    ,ifvalid varchar2(1) -- 评级是否失效(0是失效1是有效)
    ,inputdate timestamp -- 新增时间
    ,inputorgid varchar2(64) -- 发起人机构id
    ,inputuserid varchar2(64) -- 发起人id
    ,modelcode varchar2(64) -- 模型编码
    ,modelname varchar2(64) -- 模型名称
    ,occurtype varchar2(8) -- 发生类型 IRS_OCCUR_TYPE
    ,originlevel varchar2(2) -- 初始等级
    ,overthrowlevel varchar2(2) -- 推翻等级
    ,pusherrorinfo varchar2(200) -- 同盾推动异常信息，如果推送成功则为空
    ,ratedate varchar2(8) -- 评级生效日期
    ,ratedelayreason varchar2(1000) -- 评级延期原因
    ,rateenddate varchar2(8) -- 评级失效日期
    ,ratereport varchar2(64) -- 评级报告
    ,realenddate varchar2(8) -- 评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效
    ,reportdelete varchar2(1) -- 评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）
    ,reportno varchar2(64) -- 使用报表号
    ,reporttime varchar2(6) -- 使用报表期次
    ,reserve varchar2(500) -- 备用字段
    ,serialno varchar2(100) -- 主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段
    ,wyreason varchar2(1000) -- 查询code_library对应的WYREASON对应的违约原因
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
grant select on ${iol_schema}.icms_irs_rate_history to ${iml_schema};
grant select on ${iol_schema}.icms_irs_rate_history to ${icl_schema};
grant select on ${iol_schema}.icms_irs_rate_history to ${idl_schema};
grant select on ${iol_schema}.icms_irs_rate_history to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_irs_rate_history is '评级结果历史表';
comment on column ${iol_schema}.icms_irs_rate_history.adjustlevel is '调整等级';
comment on column ${iol_schema}.icms_irs_rate_history.applyid is '评级申请Id';
comment on column ${iol_schema}.icms_irs_rate_history.balance is '当时余额';
comment on column ${iol_schema}.icms_irs_rate_history.customerid is '客户ID';
comment on column ${iol_schema}.icms_irs_rate_history.datasource is '数据来源 1.申请2.跑批3.老评级';
comment on column ${iol_schema}.icms_irs_rate_history.finallevel is '确认级别';
comment on column ${iol_schema}.icms_irs_rate_history.ifvalid is '评级是否失效(0是失效1是有效)';
comment on column ${iol_schema}.icms_irs_rate_history.inputdate is '新增时间';
comment on column ${iol_schema}.icms_irs_rate_history.inputorgid is '发起人机构id';
comment on column ${iol_schema}.icms_irs_rate_history.inputuserid is '发起人id';
comment on column ${iol_schema}.icms_irs_rate_history.modelcode is '模型编码';
comment on column ${iol_schema}.icms_irs_rate_history.modelname is '模型名称';
comment on column ${iol_schema}.icms_irs_rate_history.occurtype is '发生类型 IRS_OCCUR_TYPE';
comment on column ${iol_schema}.icms_irs_rate_history.originlevel is '初始等级';
comment on column ${iol_schema}.icms_irs_rate_history.overthrowlevel is '推翻等级';
comment on column ${iol_schema}.icms_irs_rate_history.pusherrorinfo is '同盾推动异常信息，如果推送成功则为空';
comment on column ${iol_schema}.icms_irs_rate_history.ratedate is '评级生效日期';
comment on column ${iol_schema}.icms_irs_rate_history.ratedelayreason is '评级延期原因';
comment on column ${iol_schema}.icms_irs_rate_history.rateenddate is '评级失效日期';
comment on column ${iol_schema}.icms_irs_rate_history.ratereport is '评级报告';
comment on column ${iol_schema}.icms_irs_rate_history.realenddate is '评级真正失效日期,新增记录时默认和评级失效日期一致，所以不能通过是否有值来判断是否失效';
comment on column ${iol_schema}.icms_irs_rate_history.reportdelete is '评级使用期次财报是否删除 1.是（财报删除时） 0.否（使用财报创建新的评级记录时）';
comment on column ${iol_schema}.icms_irs_rate_history.reportno is '使用报表号';
comment on column ${iol_schema}.icms_irs_rate_history.reporttime is '使用报表期次';
comment on column ${iol_schema}.icms_irs_rate_history.reserve is '备用字段';
comment on column ${iol_schema}.icms_irs_rate_history.serialno is '主要用于存来自老评级迁移的结果历史表里的SNUMBERRAT字段';
comment on column ${iol_schema}.icms_irs_rate_history.wyreason is '查询code_library对应的WYREASON对应的违约原因';
comment on column ${iol_schema}.icms_irs_rate_history.start_dt is '开始时间';
comment on column ${iol_schema}.icms_irs_rate_history.end_dt is '结束时间';
comment on column ${iol_schema}.icms_irs_rate_history.id_mark is '增删标志';
comment on column ${iol_schema}.icms_irs_rate_history.etl_timestamp is 'ETL处理时间戳';
