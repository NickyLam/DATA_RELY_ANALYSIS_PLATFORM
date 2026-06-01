/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_ban_account_main
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_ban_account_main
whenever sqlerror continue none;
drop table ${iol_schema}.fams_ban_account_main purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_account_main(
    vouch_num varchar2(32) -- 凭证编号
    ,bus_vouchnum varchar2(32) -- 凭证编号
    ,bookset_id varchar2(50) -- 账套代码
    ,trade_id varchar2(32) -- 交易编号
    ,book_date date -- 日期
    ,com_table_id varchar2(32) -- 合并场景代码
    ,vouch_remark varchar2(200) -- 凭证说明
    ,offset_flag varchar2(50) -- 冲正标识
    ,vouch_year number(10) -- 年份
    ,vouch_month number(10) -- 月份
    ,num number(10) -- 编号位数
    ,book_type varchar2(50) -- 凭证类型
    ,handle_user varchar2(20) -- 经办人
    ,approve_user varchar2(20) -- 复核人
    ,approve_status varchar2(2) -- 审批状态
    ,send_user varchar2(20) -- 发送人
    ,send_status varchar2(2) -- 发送状态
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,vouch_type varchar2(10) -- 账务类型
    ,customer_name varchar2(200) -- 客户名称
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
grant select on ${iol_schema}.fams_ban_account_main to ${iml_schema};
grant select on ${iol_schema}.fams_ban_account_main to ${icl_schema};
grant select on ${iol_schema}.fams_ban_account_main to ${idl_schema};
grant select on ${iol_schema}.fams_ban_account_main to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_ban_account_main is '凭证主表';
comment on column ${iol_schema}.fams_ban_account_main.vouch_num is '凭证编号';
comment on column ${iol_schema}.fams_ban_account_main.bus_vouchnum is '凭证编号';
comment on column ${iol_schema}.fams_ban_account_main.bookset_id is '账套代码';
comment on column ${iol_schema}.fams_ban_account_main.trade_id is '交易编号';
comment on column ${iol_schema}.fams_ban_account_main.book_date is '日期';
comment on column ${iol_schema}.fams_ban_account_main.com_table_id is '合并场景代码';
comment on column ${iol_schema}.fams_ban_account_main.vouch_remark is '凭证说明';
comment on column ${iol_schema}.fams_ban_account_main.offset_flag is '冲正标识';
comment on column ${iol_schema}.fams_ban_account_main.vouch_year is '年份';
comment on column ${iol_schema}.fams_ban_account_main.vouch_month is '月份';
comment on column ${iol_schema}.fams_ban_account_main.num is '编号位数';
comment on column ${iol_schema}.fams_ban_account_main.book_type is '凭证类型';
comment on column ${iol_schema}.fams_ban_account_main.handle_user is '经办人';
comment on column ${iol_schema}.fams_ban_account_main.approve_user is '复核人';
comment on column ${iol_schema}.fams_ban_account_main.approve_status is '审批状态';
comment on column ${iol_schema}.fams_ban_account_main.send_user is '发送人';
comment on column ${iol_schema}.fams_ban_account_main.send_status is '发送状态';
comment on column ${iol_schema}.fams_ban_account_main.create_user is '创建人';
comment on column ${iol_schema}.fams_ban_account_main.create_dept is '创建部门';
comment on column ${iol_schema}.fams_ban_account_main.create_time is '创建时间';
comment on column ${iol_schema}.fams_ban_account_main.update_user is '更新人';
comment on column ${iol_schema}.fams_ban_account_main.update_time is '更新时间';
comment on column ${iol_schema}.fams_ban_account_main.vouch_type is '账务类型';
comment on column ${iol_schema}.fams_ban_account_main.customer_name is '客户名称';
comment on column ${iol_schema}.fams_ban_account_main.start_dt is '开始时间';
comment on column ${iol_schema}.fams_ban_account_main.end_dt is '结束时间';
comment on column ${iol_schema}.fams_ban_account_main.id_mark is '增删标志';
comment on column ${iol_schema}.fams_ban_account_main.etl_timestamp is 'ETL处理时间戳';
