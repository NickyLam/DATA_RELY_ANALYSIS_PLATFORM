/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amss_cms_risk_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amss_cms_risk_info
whenever sqlerror continue none;
drop table ${iol_schema}.amss_cms_risk_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_cms_risk_info(
    risk_id number(10) -- 主键
    ,risk_pro number(4) -- 提供方. 0:威富通 1:支付宝
    ,risk_type number(4) -- 校验类型.0:卡号,1:商户名,2:身份证号,3:手机
    ,risk_status number(4) -- 校验状态.1已校验
    ,risk_result number(4) -- 校验结果.0：初始，1:正常，2：危险
    ,risk_info varchar2(128) -- 黑名单数据.错误值
    ,remark varchar2(256) -- 备注信息
    ,create_user number(10) -- 
    ,create_emp varchar2(32) -- 
    ,create_time timestamp -- 创建时间.
    ,update_time timestamp -- 更新时间.
    ,fld_n1 number(10) -- 数值型保留字段1.数值型保留字段1
    ,fld_n2 number(10) -- 数值型保留字段2.数值型保留字段2
    ,fld_s1 varchar2(256) -- 字符型保留字段1.字符型保留字段1
    ,fld_s2 varchar2(2048) -- 字符型保留字段2.字符型保留字段2
    ,thi_risk_status varchar2(30) -- 第三方风险状态
    ,risk_level number(4) -- 第三方风险等级
    ,channel_id varchar2(32) -- 所属渠道.关联渠道ID，只有受理机构允许为空
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
grant select on ${iol_schema}.amss_cms_risk_info to ${iml_schema};
grant select on ${iol_schema}.amss_cms_risk_info to ${icl_schema};
grant select on ${iol_schema}.amss_cms_risk_info to ${idl_schema};
grant select on ${iol_schema}.amss_cms_risk_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.amss_cms_risk_info is '黑名单数据';
comment on column ${iol_schema}.amss_cms_risk_info.risk_id is '主键';
comment on column ${iol_schema}.amss_cms_risk_info.risk_pro is '提供方. 0:威富通 1:支付宝';
comment on column ${iol_schema}.amss_cms_risk_info.risk_type is '校验类型.0:卡号,1:商户名,2:身份证号,3:手机';
comment on column ${iol_schema}.amss_cms_risk_info.risk_status is '校验状态.1已校验';
comment on column ${iol_schema}.amss_cms_risk_info.risk_result is '校验结果.0：初始，1:正常，2：危险';
comment on column ${iol_schema}.amss_cms_risk_info.risk_info is '黑名单数据.错误值';
comment on column ${iol_schema}.amss_cms_risk_info.remark is '备注信息';
comment on column ${iol_schema}.amss_cms_risk_info.create_user is '';
comment on column ${iol_schema}.amss_cms_risk_info.create_emp is '';
comment on column ${iol_schema}.amss_cms_risk_info.create_time is '创建时间.';
comment on column ${iol_schema}.amss_cms_risk_info.update_time is '更新时间.';
comment on column ${iol_schema}.amss_cms_risk_info.fld_n1 is '数值型保留字段1.数值型保留字段1';
comment on column ${iol_schema}.amss_cms_risk_info.fld_n2 is '数值型保留字段2.数值型保留字段2';
comment on column ${iol_schema}.amss_cms_risk_info.fld_s1 is '字符型保留字段1.字符型保留字段1';
comment on column ${iol_schema}.amss_cms_risk_info.fld_s2 is '字符型保留字段2.字符型保留字段2';
comment on column ${iol_schema}.amss_cms_risk_info.thi_risk_status is '第三方风险状态';
comment on column ${iol_schema}.amss_cms_risk_info.risk_level is '第三方风险等级';
comment on column ${iol_schema}.amss_cms_risk_info.channel_id is '所属渠道.关联渠道ID，只有受理机构允许为空';
comment on column ${iol_schema}.amss_cms_risk_info.start_dt is '开始时间';
comment on column ${iol_schema}.amss_cms_risk_info.end_dt is '结束时间';
comment on column ${iol_schema}.amss_cms_risk_info.id_mark is '增删标志';
comment on column ${iol_schema}.amss_cms_risk_info.etl_timestamp is 'ETL处理时间戳';
