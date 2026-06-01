/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_mem_user_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_mem_user_info
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_mem_user_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_mem_user_info(
    id varchar2(60) -- ID
    ,mem_no varchar2(9) -- 会员代码
    ,brh_no varchar2(14) -- 机构代码
    ,user_id varchar2(15) -- 用户ID
    ,user_type varchar2(6) -- 用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员
    ,user_identi varchar2(6) -- 用户身份： UR01 交易员
    ,user_name varchar2(450) -- 用户姓名
    ,user_status varchar2(6) -- 用户状态： US01 正常 US02 禁用 US03 锁定
    ,adress varchar2(450) -- 地址
    ,tel varchar2(30) -- 座机
    ,is_public varchar2(2) -- 手机是否公开
    ,moblie varchar2(30) -- 手机
    ,signature varchar2(1500) -- 个性签名
    ,email varchar2(113) -- 邮箱
    ,remark1 varchar2(1500) -- 备注1
    ,remark2 varchar2(1500) -- 备注2
    ,last_upd_time varchar2(21) -- 最后修改时间
    ,last_upd_opr varchar2(48) -- 最后修改人
    ,create_by varchar2(48) -- 创建人
    ,create_time varchar2(21) -- 创建时间
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
grant select on ${iol_schema}.bdms_mem_user_info to ${iml_schema};
grant select on ${iol_schema}.bdms_mem_user_info to ${icl_schema};
grant select on ${iol_schema}.bdms_mem_user_info to ${idl_schema};
grant select on ${iol_schema}.bdms_mem_user_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_mem_user_info is '机构交易员信息表';
comment on column ${iol_schema}.bdms_mem_user_info.id is 'ID';
comment on column ${iol_schema}.bdms_mem_user_info.mem_no is '会员代码';
comment on column ${iol_schema}.bdms_mem_user_info.brh_no is '机构代码';
comment on column ${iol_schema}.bdms_mem_user_info.user_id is '用户ID';
comment on column ${iol_schema}.bdms_mem_user_info.user_type is '用户类别: UT01 场务管理员 UT02 场务操作员 UT03 机构管理员 UT04 机构操作员 UT05 交易员';
comment on column ${iol_schema}.bdms_mem_user_info.user_identi is '用户身份： UR01 交易员';
comment on column ${iol_schema}.bdms_mem_user_info.user_name is '用户姓名';
comment on column ${iol_schema}.bdms_mem_user_info.user_status is '用户状态： US01 正常 US02 禁用 US03 锁定';
comment on column ${iol_schema}.bdms_mem_user_info.adress is '地址';
comment on column ${iol_schema}.bdms_mem_user_info.tel is '座机';
comment on column ${iol_schema}.bdms_mem_user_info.is_public is '手机是否公开';
comment on column ${iol_schema}.bdms_mem_user_info.moblie is '手机';
comment on column ${iol_schema}.bdms_mem_user_info.signature is '个性签名';
comment on column ${iol_schema}.bdms_mem_user_info.email is '邮箱';
comment on column ${iol_schema}.bdms_mem_user_info.remark1 is '备注1';
comment on column ${iol_schema}.bdms_mem_user_info.remark2 is '备注2';
comment on column ${iol_schema}.bdms_mem_user_info.last_upd_time is '最后修改时间';
comment on column ${iol_schema}.bdms_mem_user_info.last_upd_opr is '最后修改人';
comment on column ${iol_schema}.bdms_mem_user_info.create_by is '创建人';
comment on column ${iol_schema}.bdms_mem_user_info.create_time is '创建时间';
comment on column ${iol_schema}.bdms_mem_user_info.start_dt is '开始时间';
comment on column ${iol_schema}.bdms_mem_user_info.end_dt is '结束时间';
comment on column ${iol_schema}.bdms_mem_user_info.id_mark is '增删标志';
comment on column ${iol_schema}.bdms_mem_user_info.etl_timestamp is 'ETL处理时间戳';
