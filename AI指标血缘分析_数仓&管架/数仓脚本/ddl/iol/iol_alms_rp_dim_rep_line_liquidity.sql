/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol alms_rp_dim_rep_line_liquidity
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.alms_rp_dim_rep_line_liquidity
whenever sqlerror continue none;
drop table ${iol_schema}.alms_rp_dim_rep_line_liquidity purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alms_rp_dim_rep_line_liquidity(
    v_rep_cd varchar2(20) -- 报表ID
    ,v_rep_line_order number(3) -- 序号
    ,n_rep_line_cd number -- 报表条目编号
    ,v_rep_line_name varchar2(800) -- 报表条目名称(即指标名称)
    ,v_rep_line_display_order number(3) -- 报表条目展示顺序号
    ,n_bold_ind number(3) -- 粗体展示标识:0：正常；1：粗体
    ,n_indent_level number(3) -- 缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；
    ,v_regulatory_level varchar2(200) -- 监控级别
    ,v_index_class varchar2(200) -- 指标分类
    ,v_supervision_require varchar2(200) -- 监管要求
    ,v_limit_value varchar2(200) -- 限额值
    ,v_prewarning_value varchar2(200) -- 预警值
    ,v_index_type varchar2(200) -- 指标类型
    ,v_statistical_frequency varchar2(200) -- 统计频率
    ,v_monitor_frequency varchar2(200) -- 监测频率
    ,v_read_lvl varchar2(200) -- 审阅层级
    ,v_department_type varchar2(1000) -- 指标部门
    ,d_created_dt date -- 创建日期
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
grant select on ${iol_schema}.alms_rp_dim_rep_line_liquidity to ${iml_schema};
grant select on ${iol_schema}.alms_rp_dim_rep_line_liquidity to ${icl_schema};
grant select on ${iol_schema}.alms_rp_dim_rep_line_liquidity to ${idl_schema};
grant select on ${iol_schema}.alms_rp_dim_rep_line_liquidity to ${iel_schema};

-- comment
comment on table ${iol_schema}.alms_rp_dim_rep_line_liquidity is '指标参数表';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_rep_cd is '报表ID';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_rep_line_order is '序号';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.n_rep_line_cd is '报表条目编号';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_rep_line_name is '报表条目名称(即指标名称)';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_rep_line_display_order is '报表条目展示顺序号';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.n_bold_ind is '粗体展示标识:0：正常；1：粗体';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.n_indent_level is '缩进级别：0：不缩进；1：缩进一级；2：缩进2级；3：缩进3级；4：缩进4级；；5：缩进5级；';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_regulatory_level is '监控级别';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_index_class is '指标分类';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_supervision_require is '监管要求';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_limit_value is '限额值';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_prewarning_value is '预警值';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_index_type is '指标类型';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_statistical_frequency is '统计频率';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_monitor_frequency is '监测频率';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_read_lvl is '审阅层级';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.v_department_type is '指标部门';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.d_created_dt is '创建日期';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.start_dt is '开始时间';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.end_dt is '结束时间';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.id_mark is '增删标志';
comment on column ${iol_schema}.alms_rp_dim_rep_line_liquidity.etl_timestamp is 'ETL处理时间戳';
