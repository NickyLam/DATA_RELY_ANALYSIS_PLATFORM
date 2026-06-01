/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_mst_bond_valuation_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_mst_bond_valuation_info
whenever sqlerror continue none;
drop table ${iol_schema}.fams_mst_bond_valuation_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_bond_valuation_info(
    sec_id varchar2(30) -- 债券代码，市场代码
    ,value_date date -- 估值日
    ,value_source varchar2(50) -- 估值来源，中债、中证等
    ,last_period number(30,14) -- 剩余期限
    ,price number(30,14) -- 市价全价
    ,netprice number(30,14) -- 市价净价
    ,m_duration number(30,14) -- 市价久期
    ,m_convexity number(30,14) -- 市价凸性
    ,bpvalue number(30,14) -- 基点价值
    ,sduration number(30,14) -- 利差久期
    ,scnvxty number(30,14) -- 利差凸性
    ,interest_duration number(30,14) -- 利率久期
    ,interest_cnvxty number(30,14) -- 利率凸性
    ,bpyield number(30,14) -- 市价收益率
    ,input_type varchar2(50) -- 录入方式，接口、手工等
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,mbpvalue number(30,14) -- 估价基点价值
    ,var number(30,14) -- 风险价值
    ,cvar number(30,14) -- 条件风险价值
    ,mduration number(30,14) -- 麦考利久期
    ,implicit_grade varchar2(50) -- 市价隐含评级（中债）
    ,implicit_hgrade varchar2(50) -- 市价历史隐含评级（中债）
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
grant select on ${iol_schema}.fams_mst_bond_valuation_info to ${iml_schema};
grant select on ${iol_schema}.fams_mst_bond_valuation_info to ${icl_schema};
grant select on ${iol_schema}.fams_mst_bond_valuation_info to ${idl_schema};
grant select on ${iol_schema}.fams_mst_bond_valuation_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_mst_bond_valuation_info is '债券估值行情';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.sec_id is '债券代码，市场代码';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.value_date is '估值日';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.value_source is '估值来源，中债、中证等';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.last_period is '剩余期限';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.price is '市价全价';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.netprice is '市价净价';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.m_duration is '市价久期';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.m_convexity is '市价凸性';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.bpvalue is '基点价值';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.sduration is '利差久期';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.scnvxty is '利差凸性';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.interest_duration is '利率久期';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.interest_cnvxty is '利率凸性';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.bpyield is '市价收益率';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.input_type is '录入方式，接口、手工等';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.create_user is '创建人';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.create_dept is '创建部门';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.create_time is '创建时间';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.update_user is '更新人';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.update_time is '更新时间';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.mbpvalue is '估价基点价值';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.var is '风险价值';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.cvar is '条件风险价值';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.mduration is '麦考利久期';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.implicit_grade is '市价隐含评级（中债）';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.implicit_hgrade is '市价历史隐含评级（中债）';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.start_dt is '开始时间';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.end_dt is '结束时间';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.id_mark is '增删标志';
comment on column ${iol_schema}.fams_mst_bond_valuation_info.etl_timestamp is 'ETL处理时间戳';
