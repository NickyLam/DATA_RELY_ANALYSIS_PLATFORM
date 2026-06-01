/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_fxq_blals_all
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_fxq_blals_all
whenever sqlerror continue none;
drop table ${iol_schema}.albs_fxq_blals_all purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_fxq_blals_all(
    black_id varchar2(30) -- 黑名单编号（在黑名单系统中的唯一主键）
    ,original_id varchar2(60) -- 银行家年鉴原始编号（针对数据第三方的唯一编号）
    ,bla_type varchar2(2) -- 名单类型1：个体2：组织或实体
    ,bla_type_detail varchar2(3) -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,gender varchar2(2) -- 性别1：男2：女0：none（空）
    ,is_china_limit varchar2(2) -- 是否属于中国制裁1：是0：否
    ,bla_name varchar2(768) -- 黑名单名称
    ,bla_identity varchar2(150) -- 黑名单证件
    ,source_desc varchar2(180) -- 黑名单来源类型
    ,source_program varchar2(180) -- 黑名单来源明细
    ,active_date varchar2(12) -- 启用日期
    ,input_type varchar2(15) -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,id varchar2(30) -- 表主键
    ,blacklist_type varchar2(9) -- 黑名单归属类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.albs_fxq_blals_all to ${iml_schema};
grant select on ${iol_schema}.albs_fxq_blals_all to ${icl_schema};
grant select on ${iol_schema}.albs_fxq_blals_all to ${idl_schema};
grant select on ${iol_schema}.albs_fxq_blals_all to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_fxq_blals_all is '黑名单系统供数给反洗钱系统黑名单表2';
comment on column ${iol_schema}.albs_fxq_blals_all.black_id is '黑名单编号（在黑名单系统中的唯一主键）';
comment on column ${iol_schema}.albs_fxq_blals_all.original_id is '银行家年鉴原始编号（针对数据第三方的唯一编号）';
comment on column ${iol_schema}.albs_fxq_blals_all.bla_type is '名单类型1：个体2：组织或实体';
comment on column ${iol_schema}.albs_fxq_blals_all.bla_type_detail is '名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织';
comment on column ${iol_schema}.albs_fxq_blals_all.gender is '性别1：男2：女0：none（空）';
comment on column ${iol_schema}.albs_fxq_blals_all.is_china_limit is '是否属于中国制裁1：是0：否';
comment on column ${iol_schema}.albs_fxq_blals_all.bla_name is '黑名单名称';
comment on column ${iol_schema}.albs_fxq_blals_all.bla_identity is '黑名单证件';
comment on column ${iol_schema}.albs_fxq_blals_all.source_desc is '黑名单来源类型';
comment on column ${iol_schema}.albs_fxq_blals_all.source_program is '黑名单来源明细';
comment on column ${iol_schema}.albs_fxq_blals_all.active_date is '启用日期';
comment on column ${iol_schema}.albs_fxq_blals_all.input_type is '决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单';
comment on column ${iol_schema}.albs_fxq_blals_all.id is '表主键';
comment on column ${iol_schema}.albs_fxq_blals_all.blacklist_type is '黑名单归属类型';
comment on column ${iol_schema}.albs_fxq_blals_all.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.albs_fxq_blals_all.etl_timestamp is 'ETL处理时间戳';
