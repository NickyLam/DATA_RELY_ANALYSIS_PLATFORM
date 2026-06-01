/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_union_accept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_union_accept
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_union_accept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_union_accept(
    id number -- 主键
    ,data_num number -- 序号
    ,org_id varchar2(255) -- 机构id
    ,org_name varchar2(255) -- 机构名
    ,cust_num varchar2(120) -- 客户号
    ,cust_account varchar2(120) -- 账户
    ,cust_name varchar2(255) -- 客户名称
    ,partner_name varchar2(255) -- 联合合作商
    ,stat_cycle timestamp -- 统计周期
    ,stat_cycle_tra_money number(38,2) -- 统计周期内金额
    ,stat_cycle_tra_count number -- 统计周期内笔数
    ,perk number(38,2) -- 联合补贴费用
    ,remark varchar2(120) -- 备注
    ,create_user number -- 创建用户
    ,create_emp varchar2(120) -- 创建者
    ,create_time timestamp -- 创建时间
    ,update_time timestamp -- 更新时间
    ,physics_flag number -- 物理删除标识 1正常 2删除
    ,address varchar2(200) -- 经营地址(省市区+详细地址)
    ,account_type varchar2(32) -- 账户类型.账户类型：1企业,2个人
    ,term_count number(32,0) -- 终端数量
    ,partner_dt timestamp -- 合作开始时间(YYYY/mm/dd)
    ,is_rural number(32,0) -- 是否农村地区
	,account_num varchar2(32) --账户
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
grant select on ${iol_schema}.amss_cms_union_accept to ${iml_schema};
grant select on ${iol_schema}.amss_cms_union_accept to ${icl_schema};
grant select on ${iol_schema}.amss_cms_union_accept to ${idl_schema};
grant select on ${iol_schema}.amss_cms_union_accept to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_union_accept is '联合收单数据表';
comment on column ${iol_schema}.amss_cms_union_accept.id is '主键';
comment on column ${iol_schema}.amss_cms_union_accept.data_num is '序号';
comment on column ${iol_schema}.amss_cms_union_accept.org_id is '机构id';
comment on column ${iol_schema}.amss_cms_union_accept.org_name is '机构名';
comment on column ${iol_schema}.amss_cms_union_accept.cust_num is '客户号';
comment on column ${iol_schema}.amss_cms_union_accept.cust_account is '账户';
comment on column ${iol_schema}.amss_cms_union_accept.cust_name is '客户名称';
comment on column ${iol_schema}.amss_cms_union_accept.partner_name is '联合合作商';
comment on column ${iol_schema}.amss_cms_union_accept.stat_cycle is '统计周期';
comment on column ${iol_schema}.amss_cms_union_accept.stat_cycle_tra_money is '统计周期内金额';
comment on column ${iol_schema}.amss_cms_union_accept.stat_cycle_tra_count is '统计周期内笔数';
comment on column ${iol_schema}.amss_cms_union_accept.perk is '联合补贴费用';
comment on column ${iol_schema}.amss_cms_union_accept.remark is '备注';
comment on column ${iol_schema}.amss_cms_union_accept.create_user is '创建用户';
comment on column ${iol_schema}.amss_cms_union_accept.create_emp is '创建者';
comment on column ${iol_schema}.amss_cms_union_accept.create_time is '创建时间';
comment on column ${iol_schema}.amss_cms_union_accept.update_time is '更新时间';
comment on column ${iol_schema}.amss_cms_union_accept.physics_flag is '物理删除标识 1正常 2删除';
comment on column ${iol_schema}.amss_cms_union_accept.address is '经营地址(省市区+详细地址)';
comment on column ${iol_schema}.amss_cms_union_accept.account_type is '账户类型.账户类型：1企业,2个人';
comment on column ${iol_schema}.amss_cms_union_accept.term_count is '终端数量';
comment on column ${iol_schema}.amss_cms_union_accept.partner_dt is '合作开始时间(YYYY/mm/dd)';
comment on column ${iol_schema}.amss_cms_union_accept.is_rural is '是否农村地区';
comment on column ${iol_schema}.amss_cms_union_accept.account_num is '账号';
comment on column ${iol_schema}.amss_cms_union_accept.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_union_accept.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_union_accept.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_union_accept.etl_timestamp is 'ETL处理时间戳';

