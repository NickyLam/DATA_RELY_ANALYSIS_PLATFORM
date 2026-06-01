/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_ncts_teller_login
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_ncts_teller_login
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_ncts_teller_login purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_ncts_teller_login(
    etl_dt date --数据日期
    ,login_date varchar2(8) -- 登录日期
    ,login_time varchar2(8) -- 登录时间
    ,login_teller varchar2(10) -- 登录柜员
    ,mac_address varchar2(40) -- mac地址
    ,ip_address varchar2(20) -- ip地址
    ,compu_name varchar2(200) -- 计算机名
    ,login_status varchar2(1) -- 登录状态：0-上线；1-下线
    ,logout_date varchar2(8) -- 下线日期
    ,logout_time varchar2(8) -- 下线时间
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.itl_edw_ncts_teller_login to ${idl_schema};

-- comment
comment on table ${itl_schema}.itl_edw_ncts_teller_login is '柜员登录信息表';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.login_date is '登录日期';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.login_time is '登录时间';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.login_teller is '登录柜员';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.mac_address is 'mac地址';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.ip_address is 'ip地址';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.compu_name is '计算机名';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.login_status is '登录状态：0-上线；1-下线';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.logout_date is '下线日期';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.logout_time is '下线时间';
comment on column ${itl_schema}.itl_edw_ncts_teller_login.etl_timestamp is 'ETL处理时间戳';