/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ccdb_log_call_worksum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ccdb_log_call_worksum
whenever sqlerror continue none;
drop table ${iol_schema}.ccdb_log_call_worksum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccdb_log_call_worksum(
    connect_id varchar2(50) -- 呼叫流水号
    ,cust_name varchar2(100) -- 客户姓名
    ,cust_gender varchar2(4) -- 客户性别
    ,cust_type varchar2(4) -- 客户类型
    ,cust_no varchar2(50) -- 客户号
    ,cust_paper_type varchar2(4) -- 客户证件类型
    ,cust_paper_id varchar2(50) -- 客户证件号
    ,card_no varchar2(30) -- 卡号
    ,card_type varchar2(4) -- 卡类型
    ,sum_input varchar2(1024) -- 通话内容
    ,agent_id varchar2(20) -- agentid
    ,emp_code varchar2(30) -- 员工编号
    ,sum_time date -- 应答时间
    ,call_no varchar2(30) -- 呼入/呼出号码
    ,account_code varchar2(30) -- 用户号
    ,sum_no varchar2(30) -- 主键
    ,skill_group_id varchar2(10) -- 技能组id
    ,service_type varchar2(30) -- 服务类型
    ,proc_level varchar2(30) -- 处理级别
    ,appraise varchar2(1024) -- 对客户评价
    ,sign_flag varchar2(4) -- 签约标志
    ,satisfied_type varchar2(4) -- 满意度
    ,acw_end_time date -- 结束事后处理时间
    ,call_type varchar2(4) -- 呼叫类型,3呼出,除3以外都是呼入
    ,org_code varchar2(10) -- 座席组织机构id
    ,org_name varchar2(100) -- 座席组织机构名称
    ,certi_type varchar2(20) -- 凭证类型
    ,tsringtime varchar2(26) -- 振铃/外呼时间
    ,tspicktime varchar2(26) -- 摘机时间
    ,tshangtime varchar2(26) -- 挂机时间
    ,tsacwtime varchar2(26) -- 处理结束时间
    ,asumagent varchar2(20) -- 受理坐席
    ,tsproctime varchar2(36) -- 处理时间
    ,aprocresult varchar2(400) -- 处理结果
    ,aprocagent varchar2(20) -- 处理座席
    ,aprocstate varchar2(6) -- 处理状态
    ,aplanno varchar2(60) -- 
    ,ataskno varchar2(60) -- 
    ,idcardno varchar2(80) -- 
    ,mobiletel varchar2(60) -- 
    ,hometel varchar2(60) -- 
    ,officetel varchar2(60) -- 
    ,acustomerid varchar2(60) -- 
    ,language varchar2(2) -- 语种(英语（en）普通话（cn）)
    ,extension varchar2(30) -- 坐席分机号
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
grant select on ${iol_schema}.ccdb_log_call_worksum to ${iml_schema};
grant select on ${iol_schema}.ccdb_log_call_worksum to ${icl_schema};
grant select on ${iol_schema}.ccdb_log_call_worksum to ${idl_schema};

-- comment
comment on table ${iol_schema}.ccdb_log_call_worksum is '来电小结主表';
comment on column ${iol_schema}.ccdb_log_call_worksum.connect_id is '呼叫流水号';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_name is '客户姓名';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_gender is '客户性别';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_type is '客户类型';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_no is '客户号';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_paper_type is '客户证件类型';
comment on column ${iol_schema}.ccdb_log_call_worksum.cust_paper_id is '客户证件号';
comment on column ${iol_schema}.ccdb_log_call_worksum.card_no is '卡号';
comment on column ${iol_schema}.ccdb_log_call_worksum.card_type is '卡类型';
comment on column ${iol_schema}.ccdb_log_call_worksum.sum_input is '通话内容';
comment on column ${iol_schema}.ccdb_log_call_worksum.agent_id is 'agentid';
comment on column ${iol_schema}.ccdb_log_call_worksum.emp_code is '员工编号';
comment on column ${iol_schema}.ccdb_log_call_worksum.sum_time is '应答时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.call_no is '呼入/呼出号码';
comment on column ${iol_schema}.ccdb_log_call_worksum.account_code is '用户号';
comment on column ${iol_schema}.ccdb_log_call_worksum.sum_no is '主键';
comment on column ${iol_schema}.ccdb_log_call_worksum.skill_group_id is '技能组id';
comment on column ${iol_schema}.ccdb_log_call_worksum.service_type is '服务类型';
comment on column ${iol_schema}.ccdb_log_call_worksum.proc_level is '处理级别';
comment on column ${iol_schema}.ccdb_log_call_worksum.appraise is '对客户评价';
comment on column ${iol_schema}.ccdb_log_call_worksum.sign_flag is '签约标志';
comment on column ${iol_schema}.ccdb_log_call_worksum.satisfied_type is '满意度';
comment on column ${iol_schema}.ccdb_log_call_worksum.acw_end_time is '结束事后处理时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.call_type is '呼叫类型,3呼出,除3以外都是呼入';
comment on column ${iol_schema}.ccdb_log_call_worksum.org_code is '座席组织机构id';
comment on column ${iol_schema}.ccdb_log_call_worksum.org_name is '座席组织机构名称';
comment on column ${iol_schema}.ccdb_log_call_worksum.certi_type is '凭证类型';
comment on column ${iol_schema}.ccdb_log_call_worksum.tsringtime is '振铃/外呼时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.tspicktime is '摘机时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.tshangtime is '挂机时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.tsacwtime is '处理结束时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.asumagent is '受理坐席';
comment on column ${iol_schema}.ccdb_log_call_worksum.tsproctime is '处理时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.aprocresult is '处理结果';
comment on column ${iol_schema}.ccdb_log_call_worksum.aprocagent is '处理座席';
comment on column ${iol_schema}.ccdb_log_call_worksum.aprocstate is '处理状态';
comment on column ${iol_schema}.ccdb_log_call_worksum.aplanno is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.ataskno is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.idcardno is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.mobiletel is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.hometel is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.officetel is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.acustomerid is '';
comment on column ${iol_schema}.ccdb_log_call_worksum.language is '语种(英语（en）普通话（cn）)';
comment on column ${iol_schema}.ccdb_log_call_worksum.extension is '坐席分机号';
comment on column ${iol_schema}.ccdb_log_call_worksum.start_dt is '开始时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.end_dt is '结束时间';
comment on column ${iol_schema}.ccdb_log_call_worksum.id_mark is '增删标志';
comment on column ${iol_schema}.ccdb_log_call_worksum.etl_timestamp is 'ETL处理时间戳';
