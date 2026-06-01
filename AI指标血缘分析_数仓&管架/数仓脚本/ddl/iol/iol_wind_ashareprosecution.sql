/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareprosecution
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareprosecution
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareprosecution purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareprosecution(
    object_id varchar2(150) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,s_info_compcode varchar2(60) -- 公司ID
    ,ann_dt varchar2(12) -- 公告日期
    ,title varchar2(60) -- 案件名称
    ,accuser varchar2(4000) -- 原告方
    ,defendant varchar2(4000) -- 被告方
    ,pro_type varchar2(15) -- 诉讼类型
    ,amount number(20,4) -- 涉案金额
    ,crncy_code varchar2(15) -- 货币代码
    ,prosecute_dt varchar2(12) -- 起诉日期
    ,court varchar2(300) -- 一审受理法院
    ,judge_dt varchar2(12) -- 判决日期
    ,result varchar2(4000) -- 判决内容
    ,is_appeal number(5,0) -- 是否上诉
    ,appellant varchar2(2) -- 二审上诉方(是否原告)
    ,court2 varchar2(300) -- 二审受理法院
    ,judge_dt2 varchar2(12) -- 二审判决日期
    ,result2 varchar2(3000) -- 二审判决内容
    ,resultamount number(20,4) -- 判决金额
    ,briefresult varchar2(150) -- 诉讼结果
    ,execution varchar2(4000) -- 执行情况
    ,introduction varchar2(4000) -- 案件描述
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
grant select on ${iol_schema}.wind_ashareprosecution to ${iml_schema};
grant select on ${iol_schema}.wind_ashareprosecution to ${icl_schema};
grant select on ${iol_schema}.wind_ashareprosecution to ${idl_schema};
grant select on ${iol_schema}.wind_ashareprosecution to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareprosecution is '中国A股诉讼事件';
comment on column ${iol_schema}.wind_ashareprosecution.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareprosecution.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareprosecution.s_info_compcode is '公司ID';
comment on column ${iol_schema}.wind_ashareprosecution.ann_dt is '公告日期';
comment on column ${iol_schema}.wind_ashareprosecution.title is '案件名称';
comment on column ${iol_schema}.wind_ashareprosecution.accuser is '原告方';
comment on column ${iol_schema}.wind_ashareprosecution.defendant is '被告方';
comment on column ${iol_schema}.wind_ashareprosecution.pro_type is '诉讼类型';
comment on column ${iol_schema}.wind_ashareprosecution.amount is '涉案金额';
comment on column ${iol_schema}.wind_ashareprosecution.crncy_code is '货币代码';
comment on column ${iol_schema}.wind_ashareprosecution.prosecute_dt is '起诉日期';
comment on column ${iol_schema}.wind_ashareprosecution.court is '一审受理法院';
comment on column ${iol_schema}.wind_ashareprosecution.judge_dt is '判决日期';
comment on column ${iol_schema}.wind_ashareprosecution.result is '判决内容';
comment on column ${iol_schema}.wind_ashareprosecution.is_appeal is '是否上诉';
comment on column ${iol_schema}.wind_ashareprosecution.appellant is '二审上诉方(是否原告)';
comment on column ${iol_schema}.wind_ashareprosecution.court2 is '二审受理法院';
comment on column ${iol_schema}.wind_ashareprosecution.judge_dt2 is '二审判决日期';
comment on column ${iol_schema}.wind_ashareprosecution.result2 is '二审判决内容';
comment on column ${iol_schema}.wind_ashareprosecution.resultamount is '判决金额';
comment on column ${iol_schema}.wind_ashareprosecution.briefresult is '诉讼结果';
comment on column ${iol_schema}.wind_ashareprosecution.execution is '执行情况';
comment on column ${iol_schema}.wind_ashareprosecution.introduction is '案件描述';
comment on column ${iol_schema}.wind_ashareprosecution.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareprosecution.etl_timestamp is 'ETL处理时间戳';
