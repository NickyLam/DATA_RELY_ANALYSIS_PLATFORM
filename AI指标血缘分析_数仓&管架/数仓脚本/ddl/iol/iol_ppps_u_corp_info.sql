/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ppps_u_corp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ppps_u_corp_info
whenever sqlerror continue none;
drop table ${iol_schema}.ppps_u_corp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ppps_u_corp_info(
    issr_id varchar2(20) -- 机构标识
    ,issr_name varchar2(256) -- 机构名称
    ,permit_code varchar2(100) -- 营业执照号码
    ,permit_vaild_date varchar2(12) -- 营业执照有效期 YYYYMMDD
    ,regist_fund number(19,2) -- 注册资金
    ,address varchar2(256) -- 注册地址
    ,organ_code varchar2(100) -- 组织机构代码证
    ,corp_id_type varchar2(10) -- 法人证件类型 00-其他，01-身份证，02-军官士兵证，03-港澳台通行证，04-护照
    ,corp_id_no varchar2(100) -- 法人证件号码
    ,corporation_name varchar2(60) -- 法人姓名
    ,email varchar2(100) -- 联系人电子邮箱
    ,linkman varchar2(60) -- 联系人姓名
    ,link_tel_no varchar2(20) -- 联系电话
    ,contact_address varchar2(256) -- 联系人地址
    ,fax varchar2(100) -- 传真
    ,status varchar2(10) -- 状态 ACTIVE-正常服务,INACTIVE-暂停服务
    ,balance_channel varchar2(4) -- 结算通道 1-本行账户，2-他行账户
    ,balance_open_bank varchar2(256) -- 结算账户开户行名
    ,create_time varchar2(20) -- 创建时间
    ,update_time varchar2(20) -- 修改时间
    ,delete_status varchar2(10) -- 0
    ,issr_short_name varchar2(256) -- 机构简称
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
grant select on ${iol_schema}.ppps_u_corp_info to ${iml_schema};
grant select on ${iol_schema}.ppps_u_corp_info to ${icl_schema};
grant select on ${iol_schema}.ppps_u_corp_info to ${idl_schema};
grant select on ${iol_schema}.ppps_u_corp_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ppps_u_corp_info is '支付机构基本信息表';
comment on column ${iol_schema}.ppps_u_corp_info.issr_id is '机构标识';
comment on column ${iol_schema}.ppps_u_corp_info.issr_name is '机构名称';
comment on column ${iol_schema}.ppps_u_corp_info.permit_code is '营业执照号码';
comment on column ${iol_schema}.ppps_u_corp_info.permit_vaild_date is '营业执照有效期 YYYYMMDD';
comment on column ${iol_schema}.ppps_u_corp_info.regist_fund is '注册资金';
comment on column ${iol_schema}.ppps_u_corp_info.address is '注册地址';
comment on column ${iol_schema}.ppps_u_corp_info.organ_code is '组织机构代码证';
comment on column ${iol_schema}.ppps_u_corp_info.corp_id_type is '法人证件类型 00-其他，01-身份证，02-军官士兵证，03-港澳台通行证，04-护照';
comment on column ${iol_schema}.ppps_u_corp_info.corp_id_no is '法人证件号码';
comment on column ${iol_schema}.ppps_u_corp_info.corporation_name is '法人姓名';
comment on column ${iol_schema}.ppps_u_corp_info.email is '联系人电子邮箱';
comment on column ${iol_schema}.ppps_u_corp_info.linkman is '联系人姓名';
comment on column ${iol_schema}.ppps_u_corp_info.link_tel_no is '联系电话';
comment on column ${iol_schema}.ppps_u_corp_info.contact_address is '联系人地址';
comment on column ${iol_schema}.ppps_u_corp_info.fax is '传真';
comment on column ${iol_schema}.ppps_u_corp_info.status is '状态 ACTIVE-正常服务,INACTIVE-暂停服务';
comment on column ${iol_schema}.ppps_u_corp_info.balance_channel is '结算通道 1-本行账户，2-他行账户';
comment on column ${iol_schema}.ppps_u_corp_info.balance_open_bank is '结算账户开户行名';
comment on column ${iol_schema}.ppps_u_corp_info.create_time is '创建时间';
comment on column ${iol_schema}.ppps_u_corp_info.update_time is '修改时间';
comment on column ${iol_schema}.ppps_u_corp_info.delete_status is '0';
comment on column ${iol_schema}.ppps_u_corp_info.issr_short_name is '机构简称';
comment on column ${iol_schema}.ppps_u_corp_info.start_dt is '开始时间';
comment on column ${iol_schema}.ppps_u_corp_info.end_dt is '结束时间';
comment on column ${iol_schema}.ppps_u_corp_info.id_mark is '增删标志';
comment on column ${iol_schema}.ppps_u_corp_info.etl_timestamp is 'ETL处理时间戳';
