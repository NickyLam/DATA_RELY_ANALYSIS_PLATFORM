/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_equity_final_invest_ratio
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio(
    id number(22,0) -- 序号
    ,final_invest_type varchar2(450) -- 最终投向类型（穿透底层）
    ,weight number(31,6) -- 权重(%)
    ,date_explain varchar2(450) -- 数据项说明
    ,asset_class varchar2(75) -- 映射资本新规基础资产品种或资产中类
    ,parent_id number(22,0) -- 所属分类id
    ,invest_ratio_flag varchar2(2) -- 当期投资金额占比是否只读：1只读
    ,grade_flag varchar2(2) -- 评级是否只读：1只读
    ,grade_type varchar2(2) -- 评级类型
    ,low_prop_flag varchar2(2) -- 合同中的最低投资比例是否只读：1只读
    ,high_prop_flag varchar2(2) -- 合同中的最高投资是否只读：1只读
    ,weight_flag varchar2(2) -- 权重是否只读：1只读
    ,style_level varchar2(2) -- 1-加粗 2-空1格 3-空2格
    ,remark varchar2(750) -- 备注
    ,relate_ratio_grade varchar2(2) -- 评级和权重是否存在联动,1-是 0-否
    ,node_type varchar2(2) -- 几类节点  1 一类项   2 二类项 3 三类项
    ,grade_required varchar2(2) -- 该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑
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
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest_ratio to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest_ratio to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest_ratio to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_equity_final_invest_ratio to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_equity_final_invest_ratio is '净值型项目基础资产权重模板表';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.id is '序号';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.final_invest_type is '最终投向类型（穿透底层）';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.weight is '权重(%)';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.date_explain is '数据项说明';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.asset_class is '映射资本新规基础资产品种或资产中类';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.parent_id is '所属分类id';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.invest_ratio_flag is '当期投资金额占比是否只读：1只读';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.grade_flag is '评级是否只读：1只读';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.grade_type is '评级类型';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.low_prop_flag is '合同中的最低投资比例是否只读：1只读';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.high_prop_flag is '合同中的最高投资是否只读：1只读';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.weight_flag is '权重是否只读：1只读';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.style_level is '1-加粗 2-空1格 3-空2格';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.remark is '备注';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.relate_ratio_grade is '评级和权重是否存在联动,1-是 0-否';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.node_type is '几类节点  1 一类项   2 二类项 3 三类项';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.grade_required is '该项比例有值，主体评级项必填逻辑  1存在该逻辑 0 不存在该逻辑';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_equity_final_invest_ratio.etl_timestamp is 'ETL处理时间戳';
