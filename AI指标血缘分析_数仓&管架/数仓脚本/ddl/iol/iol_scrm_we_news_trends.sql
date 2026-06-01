/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_we_news_trends
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_we_news_trends
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_we_news_trends purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_we_news_trends(
    trends_id varchar2(32) -- 
    ,external_userid varchar2(32) -- 
    ,external_username varchar2(50) -- 外部联系人的姓名
    ,opr_prsn_id varchar2(32) -- 
    ,vist_func_id varchar2(32) -- 1云店 2 早报 3：资讯
    ,counts number(22) -- 
    ,mov_tp_cd varchar2(5) -- 操作类型
    ,mov_tp_nm varchar2(64) -- 
    ,mov_title varchar2(100) -- 动态标题
    ,mov_inf_dsc varchar2(2048) -- 动态描述
    ,mov_dt varchar2(10) -- 动态日期
    ,mov_tm varchar2(8) -- 动态时间
    ,corp_id varchar2(64) -- 
    ,opr_prsn_name varchar2(255) -- 操作人姓名
    ,mobile varchar2(11) -- 手机号
    ,type_id varchar2(64) -- 类型ID
    ,trends_type varchar2(1) -- 记录类型 1：浏览  2：分享
    ,cust_type varchar2(1) -- 操作角色类型0客户 1客户经理
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
grant select on ${iol_schema}.scrm_we_news_trends to ${iml_schema};
grant select on ${iol_schema}.scrm_we_news_trends to ${icl_schema};
grant select on ${iol_schema}.scrm_we_news_trends to ${idl_schema};
grant select on ${iol_schema}.scrm_we_news_trends to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_we_news_trends is '早报动态';
comment on column ${iol_schema}.scrm_we_news_trends.trends_id is '';
comment on column ${iol_schema}.scrm_we_news_trends.external_userid is '';
comment on column ${iol_schema}.scrm_we_news_trends.external_username is '外部联系人的姓名';
comment on column ${iol_schema}.scrm_we_news_trends.opr_prsn_id is '';
comment on column ${iol_schema}.scrm_we_news_trends.vist_func_id is '1云店 2 早报 3：资讯';
comment on column ${iol_schema}.scrm_we_news_trends.counts is '';
comment on column ${iol_schema}.scrm_we_news_trends.mov_tp_cd is '操作类型';
comment on column ${iol_schema}.scrm_we_news_trends.mov_tp_nm is '';
comment on column ${iol_schema}.scrm_we_news_trends.mov_title is '动态标题';
comment on column ${iol_schema}.scrm_we_news_trends.mov_inf_dsc is '动态描述';
comment on column ${iol_schema}.scrm_we_news_trends.mov_dt is '动态日期';
comment on column ${iol_schema}.scrm_we_news_trends.mov_tm is '动态时间';
comment on column ${iol_schema}.scrm_we_news_trends.corp_id is '';
comment on column ${iol_schema}.scrm_we_news_trends.opr_prsn_name is '操作人姓名';
comment on column ${iol_schema}.scrm_we_news_trends.mobile is '手机号';
comment on column ${iol_schema}.scrm_we_news_trends.type_id is '类型ID';
comment on column ${iol_schema}.scrm_we_news_trends.trends_type is '记录类型 1：浏览  2：分享';
comment on column ${iol_schema}.scrm_we_news_trends.cust_type is '操作角色类型0客户 1客户经理';
comment on column ${iol_schema}.scrm_we_news_trends.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.scrm_we_news_trends.etl_timestamp is 'ETL处理时间戳';
