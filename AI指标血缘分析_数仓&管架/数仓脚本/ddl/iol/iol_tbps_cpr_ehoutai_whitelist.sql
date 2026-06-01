/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tbps_cpr_ehoutai_whitelist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tbps_cpr_ehoutai_whitelist
whenever sqlerror continue none;
drop table ${iol_schema}.tbps_cpr_ehoutai_whitelist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tbps_cpr_ehoutai_whitelist(
    ewl_ecifno varchar2(20) -- ecif客户号
    ,ewl_custnamne varchar2(512) -- 客户名称
    ,ewl_brchno varchar2(32) -- 机构号
    ,ewl_brchname varchar2(512) -- 机构名称
    ,ewl_createtime varchar2(14) -- 生成时间
    ,ewl_userseq varchar2(20) -- 操作员网银序号
    ,ewl_certno varchar2(30) -- 操作员证件号码
    ,ewl_certtype varchar2(10) -- 操作员证件类型
    ,ewl_movestate varchar2(1) -- 是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)
    ,ewl_returncode varchar2(50) -- 迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)
    ,ewl_returnmsg varchar2(256) -- 迁移返回信息
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.tbps_cpr_ehoutai_whitelist to ${iml_schema};
grant select on ${iol_schema}.tbps_cpr_ehoutai_whitelist to ${icl_schema};
grant select on ${iol_schema}.tbps_cpr_ehoutai_whitelist to ${idl_schema};
grant select on ${iol_schema}.tbps_cpr_ehoutai_whitelist to ${iel_schema};

-- comment
comment on table ${iol_schema}.tbps_cpr_ehoutai_whitelist is '网银后台白名单表';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_ecifno is 'ecif客户号';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_custnamne is '客户名称';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_brchno is '机构号';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_brchname is '机构名称';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_createtime is '生成时间';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_userseq is '操作员网银序号';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_certno is '操作员证件号码';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_certtype is '操作员证件类型';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_movestate is '是否已经做数据迁移(0:已经迁移(查询白名单请带这个状态);1:新增客户待迁移;2:迁移失败的客户)';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_returncode is '迁移返回码(空表示未执行迁移脚本,90表示迁移成功,其他错误码表示迁移失败)';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.ewl_returnmsg is '迁移返回信息';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.start_dt is '开始时间';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.end_dt is '结束时间';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.id_mark is '增删标志';
comment on column ${iol_schema}.tbps_cpr_ehoutai_whitelist.etl_timestamp is 'ETL处理时间戳';
