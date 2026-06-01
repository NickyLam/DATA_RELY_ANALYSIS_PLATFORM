/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_menu_inf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_menu_inf
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_menu_inf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_menu_inf(
    cmi_id varchar2(10) -- 菜单ID
    ,cmi_name varchar2(64) -- 菜单名称
    ,cmi_channel varchar2(1) -- 渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)
    ,cmi_authenabled varchar2(1) -- 是否允许授权
    ,cmi_state varchar2(1) -- 功能状态
    ,cmi_type varchar2(1) -- 功能类型(0：查询统计类 1：经办类功能 2：管理功能)
    ,cmi_authtype varchar2(1) -- 授权类型(0：即时生效 1：互为授权 2：指定授权)
    ,cmi_authmode varchar2(1) -- 授权形式(0：审核式 1：临柜)
    ,cmi_router varchar2(64) -- 菜单路由
    ,cmi_showtype varchar2(10) -- 展示方式
    ,cmi_only varchar2(1) -- 是否仅限制菜单(默认：0 1：是)
    ,cmi_actions varchar2(512) -- 菜单有权限的请求
    ,cmi_trancode varchar2(60) -- 交易类型
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
grant select on ${iol_schema}.tbps_cpr_menu_inf to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_menu_inf to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_menu_inf to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_menu_inf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_menu_inf is '企业产品功能(菜单)表';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_id is '菜单ID';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_name is '菜单名称';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_channel is '渠道(TBP：仅交易银行门户 EBK：仅网上银行 OGW：合作商户 ALL：全部)';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_authenabled is '是否允许授权';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_state is '功能状态';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_type is '功能类型(0：查询统计类 1：经办类功能 2：管理功能)';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_authtype is '授权类型(0：即时生效 1：互为授权 2：指定授权)';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_authmode is '授权形式(0：审核式 1：临柜)';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_router is '菜单路由';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_showtype is '展示方式';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_only is '是否仅限制菜单(默认：0 1：是)';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_actions is '菜单有权限的请求';
comment on column ${iol_schema}.tbps_cpr_menu_inf.cmi_trancode is '交易类型';
comment on column ${iol_schema}.tbps_cpr_menu_inf.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_menu_inf.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_menu_inf.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_menu_inf.etl_timestamp is 'ETL处理时间戳';
