/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol umss_icc_msg_hdws_stat
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.umss_icc_msg_hdws_stat
whenever sqlerror continue none;
drop table ${iol_schema}.umss_icc_msg_hdws_stat purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.umss_icc_msg_hdws_stat(
    id number(20) -- ID
    ,pack_id number(20) -- 批次ID
    ,batch_name varchar2(800) -- 批次名称
    ,terminal_id varchar2(400) -- 手机号
    ,cust_id varchar2(200) -- 客户号
    ,state number(11) -- 平台提交给运营商网关的结果，0成功，1失败
    ,origin_result varchar2(200) -- 运营商原始送达状态
    ,result number(11) -- 送达状态0成功，1失败，2未知
    ,short_url number(11) -- 是否有短链，0有，1无
    ,click_url number(11) -- 短链是否点开，0有，1无
    ,create_time date -- 创建时间
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
grant select on ${iol_schema}.umss_icc_msg_hdws_stat to ${iml_schema};
grant select on ${iol_schema}.umss_icc_msg_hdws_stat to ${icl_schema};
grant select on ${iol_schema}.umss_icc_msg_hdws_stat to ${idl_schema};
grant select on ${iol_schema}.umss_icc_msg_hdws_stat to ${iel_schema};

-- comment
comment on table ${iol_schema}.umss_icc_msg_hdws_stat is '';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.id is 'ID';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.pack_id is '批次ID';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.batch_name is '批次名称';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.terminal_id is '手机号';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.cust_id is '客户号';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.state is '平台提交给运营商网关的结果，0成功，1失败';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.origin_result is '运营商原始送达状态';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.result is '送达状态0成功，1失败，2未知';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.short_url is '是否有短链，0有，1无';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.click_url is '短链是否点开，0有，1无';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.create_time is '创建时间';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.start_dt is '开始时间';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.end_dt is '结束时间';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.id_mark is '增删标志';
comment on column ${iol_schema}.umss_icc_msg_hdws_stat.etl_timestamp is 'ETL处理时间戳';
