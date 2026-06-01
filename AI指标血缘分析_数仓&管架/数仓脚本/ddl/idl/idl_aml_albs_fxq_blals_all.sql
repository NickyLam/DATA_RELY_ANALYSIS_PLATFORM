/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_albs_fxq_blals_all
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_albs_fxq_blals_all
whenever sqlerror continue none;
drop table ${idl_schema}.aml_albs_fxq_blals_all purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_albs_fxq_blals_all(
    etl_dt date -- 数据日期   
    ,black_id varchar2(20) -- 黑名单编号（在黑名单系统中的唯一主键）   
    ,original_id varchar2(40) -- 银行家年鉴原始编号（针对数据第三方的唯一编号）   
    ,bla_type varchar2(1) -- 名单类型1：个体2：组织或实体   
    ,bla_type_detail varchar2(2) -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织   
    ,gender varchar2(1) -- 性别1：男2：女0：NONE（空）   
    ,is_china_limit varchar2(1) -- 是否属于中国制裁1：是0：否   
    ,bla_name varchar2(512) -- 黑名单名称   
    ,bla_identity varchar2(100) -- 黑名单证件   
    ,source_desc varchar2(120) -- 黑名单来源类型   
    ,source_program varchar2(120) -- 黑名单来源明细   
    ,active_date varchar2(8) -- 启用日期   
    ,input_type varchar2(10) -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单   
    ,id              varchar(20)  -- 表主键    
    ,blacklist_type  varchar(6)   -- 黑名单归属类型          
    ,etl_timestamp   timestamp    -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_albs_fxq_blals_all to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_albs_fxq_blals_all is '黑名单表';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.black_id is '黑名单编号（在黑名单系统中的唯一主键）';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.original_id is '银行家年鉴原始编号（针对数据第三方的唯一编号）';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.bla_type is '名单类型1：个体2：组织或实体';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.bla_type_detail is '名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.gender is '性别1：男2：女0：NONE（空）';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.is_china_limit is '是否属于中国制裁1：是0：否';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.bla_name is '黑名单名称';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.bla_identity is '黑名单证件';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.source_desc is '黑名单来源类型';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.source_program is '黑名单来源明细';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.active_date is '启用日期';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.input_type is '决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.id is '表主键';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.blacklist_type is '黑名单归属类型';
comment on column ${idl_schema}.aml_albs_fxq_blals_all.etl_timestamp is '数据处理时间';
