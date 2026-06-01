/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scrm_we_customer
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scrm_we_customer
whenever sqlerror continue none;
drop table ${iol_schema}.scrm_we_customer purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scrm_we_customer(
    external_userid varchar2(32) -- 外部联系人的USERID
    ,customer_name varchar2(100) -- 客户昵称
    ,avatar varchar2(200) -- 外部联系人头像
    ,customer_type number(22) -- 外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户
    ,gender number(22) -- 外部联系人性别0-未知1-男性2-女性
    ,unionid varchar2(64) -- 
    ,position_ora varchar2(255) -- 职位
    ,corp_name varchar2(255) -- 企业的简称
    ,corp_full_name varchar2(512) -- 企业的主体名称
    ,external_profile varchar2(512) -- 自定义展示信息
    ,is_bank_customer varchar2(2) -- 是否银行客户1：是0：否
    ,ident_no varchar2(32) -- 身份证编号
    ,birth varchar2(10) -- 备注生日
    ,mobile varchar2(20) -- 客户电话
    ,cust_id varchar2(32) -- 客户编号
    ,cust_name varchar2(255) -- 客户姓名
    ,ident_flg varchar2(1) -- 0未识别，1已识别行内  2已识别非行内
    ,create_by varchar2(32) -- 创建者
    ,create_time varchar2(23) -- 创建时间
    ,last_modi_by varchar2(32) -- 更新者
    ,last_modi_time varchar2(23) -- 更新时间
    ,email varchar2(255) -- 邮箱
    ,address varchar2(255) -- 地址
    ,customer_initial varchar2(1) -- 首字母
    ,line_id varchar2(32) -- 条线ID
    ,corp_id varchar2(32) -- 企微ID
    ,auth_dt varchar2(50) -- 认证日期和时间
    ,auth_mode varchar2(1) -- 认证方式 1：自动认证 2：自助认证 3：手工认证
    ,auth_user_id varchar2(50) -- 认证人
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
grant select on ${iol_schema}.scrm_we_customer to ${iml_schema};
grant select on ${iol_schema}.scrm_we_customer to ${icl_schema};
grant select on ${iol_schema}.scrm_we_customer to ${idl_schema};
grant select on ${iol_schema}.scrm_we_customer to ${iel_schema};

-- comment
comment on table ${iol_schema}.scrm_we_customer is '客户信息表';
comment on column ${iol_schema}.scrm_we_customer.external_userid is '外部联系人的USERID';
comment on column ${iol_schema}.scrm_we_customer.customer_name is '客户昵称';
comment on column ${iol_schema}.scrm_we_customer.avatar is '外部联系人头像';
comment on column ${iol_schema}.scrm_we_customer.customer_type is '外部联系人的类型，1表示该外部联系人是微信用户，2表示该外部联系人是企业微信用户';
comment on column ${iol_schema}.scrm_we_customer.gender is '外部联系人性别0-未知1-男性2-女性';
comment on column ${iol_schema}.scrm_we_customer.unionid is '';
comment on column ${iol_schema}.scrm_we_customer.position_ora is '职位';
comment on column ${iol_schema}.scrm_we_customer.corp_name is '企业的简称';
comment on column ${iol_schema}.scrm_we_customer.corp_full_name is '企业的主体名称';
comment on column ${iol_schema}.scrm_we_customer.external_profile is '自定义展示信息';
comment on column ${iol_schema}.scrm_we_customer.is_bank_customer is '是否银行客户1：是0：否';
comment on column ${iol_schema}.scrm_we_customer.ident_no is '身份证编号';
comment on column ${iol_schema}.scrm_we_customer.birth is '备注生日';
comment on column ${iol_schema}.scrm_we_customer.mobile is '客户电话';
comment on column ${iol_schema}.scrm_we_customer.cust_id is '客户编号';
comment on column ${iol_schema}.scrm_we_customer.cust_name is '客户姓名';
comment on column ${iol_schema}.scrm_we_customer.ident_flg is '0未识别，1已识别行内  2已识别非行内';
comment on column ${iol_schema}.scrm_we_customer.create_by is '创建者';
comment on column ${iol_schema}.scrm_we_customer.create_time is '创建时间';
comment on column ${iol_schema}.scrm_we_customer.last_modi_by is '更新者';
comment on column ${iol_schema}.scrm_we_customer.last_modi_time is '更新时间';
comment on column ${iol_schema}.scrm_we_customer.email is '邮箱';
comment on column ${iol_schema}.scrm_we_customer.address is '地址';
comment on column ${iol_schema}.scrm_we_customer.customer_initial is '首字母';
comment on column ${iol_schema}.scrm_we_customer.line_id is '条线ID';
comment on column ${iol_schema}.scrm_we_customer.corp_id is '企微ID';
comment on column ${iol_schema}.scrm_we_customer.auth_dt is '认证日期和时间';
comment on column ${iol_schema}.scrm_we_customer.auth_mode is '认证方式 1：自动认证 2：自助认证 3：手工认证';
comment on column ${iol_schema}.scrm_we_customer.auth_user_id is '认证人';
comment on column ${iol_schema}.scrm_we_customer.start_dt is '开始时间';
comment on column ${iol_schema}.scrm_we_customer.end_dt is '结束时间';
comment on column ${iol_schema}.scrm_we_customer.id_mark is '增删标志';
comment on column ${iol_schema}.scrm_we_customer.etl_timestamp is 'ETL处理时间戳';
