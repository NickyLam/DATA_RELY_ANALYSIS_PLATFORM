/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol albs_bps_albtoctm_out
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.albs_bps_albtoctm_out
whenever sqlerror continue none;
drop table ${iol_schema}.albs_bps_albtoctm_out purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.albs_bps_albtoctm_out(
    black_id varchar2(30) -- 名单表id
    ,source_program varchar2(180) -- 黑名单来源明细
    ,is_china_limit varchar2(2) -- 是否属于中国制裁1：是0：否
    ,bla_type varchar2(2) -- 名单类型 1：个体 2：组织或实体
    ,source_desc varchar2(180) -- 黑名单来源类型
    ,blacklist_type varchar2(9) -- 黑名单归属类型
    ,gender varchar2(2) -- 性别1：男2：女0：none（空）
    ,bla_identity varchar2(150) -- 黑名单证件
    ,bla_name varchar2(768) -- 黑名单名称
    ,input_type varchar2(15) -- 决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单
    ,active_date varchar2(12) -- 启用日期
    ,original_id varchar2(60) -- 黑名单第三方原始id
    ,bla_type_detail varchar2(3) -- 名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织
    ,id varchar2(30) -- 主键id
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
grant select on ${iol_schema}.albs_bps_albtoctm_out to ${iml_schema};
grant select on ${iol_schema}.albs_bps_albtoctm_out to ${icl_schema};
grant select on ${iol_schema}.albs_bps_albtoctm_out to ${idl_schema};
grant select on ${iol_schema}.albs_bps_albtoctm_out to ${iel_schema};

-- comment
comment on table ${iol_schema}.albs_bps_albtoctm_out is '送资金系统名单表';
comment on column ${iol_schema}.albs_bps_albtoctm_out.black_id is '名单表id';
comment on column ${iol_schema}.albs_bps_albtoctm_out.source_program is '黑名单来源明细';
comment on column ${iol_schema}.albs_bps_albtoctm_out.is_china_limit is '是否属于中国制裁1：是0：否';
comment on column ${iol_schema}.albs_bps_albtoctm_out.bla_type is '名单类型 1：个体 2：组织或实体';
comment on column ${iol_schema}.albs_bps_albtoctm_out.source_desc is '黑名单来源类型';
comment on column ${iol_schema}.albs_bps_albtoctm_out.blacklist_type is '黑名单归属类型';
comment on column ${iol_schema}.albs_bps_albtoctm_out.gender is '性别1：男2：女0：none（空）';
comment on column ${iol_schema}.albs_bps_albtoctm_out.bla_identity is '黑名单证件';
comment on column ${iol_schema}.albs_bps_albtoctm_out.bla_name is '黑名单名称';
comment on column ${iol_schema}.albs_bps_albtoctm_out.input_type is '决议类型(名单系统的数据大来源)77：银行家年鉴95：违法失信名单96：买卖账户名单97：违规交易场所名单98：污水池名单99：微盘名单';
comment on column ${iol_schema}.albs_bps_albtoctm_out.active_date is '启用日期';
comment on column ${iol_schema}.albs_bps_albtoctm_out.original_id is '黑名单第三方原始id';
comment on column ${iol_schema}.albs_bps_albtoctm_out.bla_type_detail is '名单类型明细01：国家政府02：城市03：个人04：船05：银行06：其它07：官员08：企业09：政治或宗教组织';
comment on column ${iol_schema}.albs_bps_albtoctm_out.id is '主键id';
comment on column ${iol_schema}.albs_bps_albtoctm_out.start_dt is '开始时间';
comment on column ${iol_schema}.albs_bps_albtoctm_out.end_dt is '结束时间';
comment on column ${iol_schema}.albs_bps_albtoctm_out.id_mark is '增删标志';
comment on column ${iol_schema}.albs_bps_albtoctm_out.etl_timestamp is 'ETL处理时间戳';
