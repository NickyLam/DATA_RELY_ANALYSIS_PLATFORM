/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_clr_business_relative
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_clr_business_relative
whenever sqlerror continue none;
drop table ${iol_schema}.icms_clr_business_relative purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_business_relative(
    objectno varchar2(64) -- 对象编号
    ,objecttype varchar2(64) -- 对象类型
    ,guarantycontractno varchar2(50) -- 担保合同号码
    ,clrid varchar2(32) -- 押品编号
    ,status varchar2(10) -- 状态
    ,relativetime timestamp -- 关联时间
    ,clrsortno varchar2(10) -- 押权顺序
    ,guarantysum number(24,6) -- 本次担保金额
    ,guarantycurrency varchar2(3) -- 担保币种
    ,approveno varchar2(100) -- 批复编号
    ,productid varchar2(32) -- 产品编号
    ,belongdept varchar2(36) -- 业务条线
    ,guarantyrate number(24,6) -- 参考抵质押率
    ,actuallyrate number(24,6) -- 抵质押率
    ,migtflag varchar2(80) -- 迁移标识：rs rcr ilc upl mim
    ,firstvalnum varchar2(32) -- 初始评估价值流水
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
grant select on ${iol_schema}.icms_clr_business_relative to ${iml_schema};
grant select on ${iol_schema}.icms_clr_business_relative to ${icl_schema};
grant select on ${iol_schema}.icms_clr_business_relative to ${idl_schema};
grant select on ${iol_schema}.icms_clr_business_relative to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_clr_business_relative is '押品业务关联关系记录表';
comment on column ${iol_schema}.icms_clr_business_relative.objectno is '对象编号';
comment on column ${iol_schema}.icms_clr_business_relative.objecttype is '对象类型';
comment on column ${iol_schema}.icms_clr_business_relative.guarantycontractno is '担保合同号码';
comment on column ${iol_schema}.icms_clr_business_relative.clrid is '押品编号';
comment on column ${iol_schema}.icms_clr_business_relative.status is '状态';
comment on column ${iol_schema}.icms_clr_business_relative.relativetime is '关联时间';
comment on column ${iol_schema}.icms_clr_business_relative.clrsortno is '押权顺序';
comment on column ${iol_schema}.icms_clr_business_relative.guarantysum is '本次担保金额';
comment on column ${iol_schema}.icms_clr_business_relative.guarantycurrency is '担保币种';
comment on column ${iol_schema}.icms_clr_business_relative.approveno is '批复编号';
comment on column ${iol_schema}.icms_clr_business_relative.productid is '产品编号';
comment on column ${iol_schema}.icms_clr_business_relative.belongdept is '业务条线';
comment on column ${iol_schema}.icms_clr_business_relative.guarantyrate is '参考抵质押率';
comment on column ${iol_schema}.icms_clr_business_relative.actuallyrate is '抵质押率';
comment on column ${iol_schema}.icms_clr_business_relative.migtflag is '迁移标识：rs rcr ilc upl mim';
comment on column ${iol_schema}.icms_clr_business_relative.firstvalnum is '初始评估价值流水';
comment on column ${iol_schema}.icms_clr_business_relative.start_dt is '开始时间';
comment on column ${iol_schema}.icms_clr_business_relative.end_dt is '结束时间';
comment on column ${iol_schema}.icms_clr_business_relative.id_mark is '增删标志';
comment on column ${iol_schema}.icms_clr_business_relative.etl_timestamp is 'ETL处理时间戳';
