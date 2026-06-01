/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol uxds_industry_eco_index_basic_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.uxds_industry_eco_index_basic_info
whenever sqlerror continue none;
drop table ${iol_schema}.uxds_industry_eco_index_basic_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.uxds_industry_eco_index_basic_info(
    seq number(28,0) -- 记录唯一标识
    ,ctime date -- 记录创建时间
    ,mtime date -- 记录修改时间
    ,rtime date -- 记录通讯到用户端时间
    ,indicator_id varchar2(60) -- 指标id
    ,indicator_name varchar2(384) -- 指标名称
    ,unit varchar2(180) -- 单位
    ,sources varchar2(1536) -- 来源
    ,country varchar2(768) -- 国家
    ,frequency varchar2(4000) -- 频率
    ,currency_variety varchar2(768) -- 币种
    ,is_tree_node number(10) -- 是否树节点@1：树节点；0：指标
    ,first_level_directory varchar2(384) -- 一级目录
    ,second_level_directory varchar2(384) -- 二级目录
    ,third_level_directory varchar2(384) -- 三级目录
    ,forth_level_directory varchar2(384) -- 四级目录
    ,fifth_level_directory varchar2(384) -- 五级目录
    ,sixth_level_directory varchar2(384) -- 六级目录
    ,seventh_level_directory varchar2(384) -- 七级目录
    ,eigth_level_directory varchar2(384) -- 八级目录
    ,ninth_level_directory varchar2(384) -- 九级目录
    ,parent_node number(20,0) -- 父层节点@关联到industry_eco_index_basic_info.seq
    ,indicator_seq number(20,0) -- 指标顺序
    ,isvalid number(10) -- 是否有效
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
grant select on ${iol_schema}.uxds_industry_eco_index_basic_info to ${iml_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_basic_info to ${icl_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_basic_info to ${idl_schema};
grant select on ${iol_schema}.uxds_industry_eco_index_basic_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.uxds_industry_eco_index_basic_info is '行业经济指标基本资料';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.seq is '记录唯一标识';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.ctime is '记录创建时间';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.mtime is '记录修改时间';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.rtime is '记录通讯到用户端时间';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.indicator_id is '指标id';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.indicator_name is '指标名称';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.unit is '单位';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.sources is '来源';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.country is '国家';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.frequency is '频率';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.currency_variety is '币种';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.is_tree_node is '是否树节点@1：树节点；0：指标';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.first_level_directory is '一级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.second_level_directory is '二级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.third_level_directory is '三级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.forth_level_directory is '四级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.fifth_level_directory is '五级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.sixth_level_directory is '六级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.seventh_level_directory is '七级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.eigth_level_directory is '八级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.ninth_level_directory is '九级目录';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.parent_node is '父层节点@关联到industry_eco_index_basic_info.seq';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.indicator_seq is '指标顺序';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.isvalid is '是否有效';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.uxds_industry_eco_index_basic_info.etl_timestamp is 'ETL处理时间戳';
