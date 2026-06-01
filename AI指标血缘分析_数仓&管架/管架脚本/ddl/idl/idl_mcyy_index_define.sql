/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl mcyy_index_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.mcyy_index_define
whenever sqlerror continue none;
drop table ${idl_schema}.mcyy_index_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mcyy_index_define(
    index_no varchar2(60) -- 标准指标编号
    ,index_clsaa_f varchar2(200) -- 标准指标一级分类
    ,index_clsaa_s varchar2(200) -- 标准指标二级分类
    ,index_no_mcs varchar2(60) -- 管驾指标编号
    ,index_clsaa_f_mcs varchar2(200) -- 管驾一级分类
    ,index_clsaa_s_mcs varchar2(200) -- 管驾二级分类
    ,index_clsaa_t_mcs varchar2(200) -- 管驾三级分类
    ,index_name_mcs varchar2(200) -- 指标名称
    ,index_name varchar2(200) -- 指标常用名
    ,source_system varchar2(200) -- 来源系统
    ,dept_mg varchar2(200) -- 管理部门
    ,dept_use varchar2(200) -- 使用部门
    ,regulatory_flag varchar2(10) -- 监管报送标志
    ,index_type varchar2(60) -- 指标类型
    ,index_measure varchar2(61) -- 度量衡
    ,frequency varchar2(200) -- 频度
    ,dimension varchar2(200) -- 维度
    ,unit varchar2(200) -- 计量单位
    ,manual_adj_flag varchar2(10) -- 是否涉及手工调整
    ,index_state varchar2(10) -- 指标状态
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.mcyy_index_define to ${iel_schema};

-- comment
comment on table ${idl_schema}.mcyy_index_define is '指标映射表';
comment on column ${idl_schema}.mcyy_index_define.index_no is '标准指标编号';
comment on column ${idl_schema}.mcyy_index_define.index_clsaa_f is '标准指标一级分类';
comment on column ${idl_schema}.mcyy_index_define.index_clsaa_s is '标准指标二级分类';
comment on column ${idl_schema}.mcyy_index_define.index_no_mcs is '管驾指标编号';
comment on column ${idl_schema}.mcyy_index_define.index_clsaa_f_mcs is '管驾一级分类';
comment on column ${idl_schema}.mcyy_index_define.index_clsaa_s_mcs is '管驾二级分类';
comment on column ${idl_schema}.mcyy_index_define.index_clsaa_t_mcs is '管驾三级分类';
comment on column ${idl_schema}.mcyy_index_define.index_name_mcs is '指标名称';
comment on column ${idl_schema}.mcyy_index_define.index_name is '指标常用名';
comment on column ${idl_schema}.mcyy_index_define.source_system is '来源系统';
comment on column ${idl_schema}.mcyy_index_define.dept_mg is '管理部门';
comment on column ${idl_schema}.mcyy_index_define.dept_use is '使用部门';
comment on column ${idl_schema}.mcyy_index_define.regulatory_flag is '监管报送标志';
comment on column ${idl_schema}.mcyy_index_define.index_type is '指标类型';
comment on column ${idl_schema}.mcyy_index_define.index_measure is '度量衡';
comment on column ${idl_schema}.mcyy_index_define.frequency is '频度';
comment on column ${idl_schema}.mcyy_index_define.dimension is '维度';
comment on column ${idl_schema}.mcyy_index_define.unit is '计量单位';
comment on column ${idl_schema}.mcyy_index_define.manual_adj_flag is '是否涉及手工调整';
comment on column ${idl_schema}.mcyy_index_define.index_state is '指标状态';


prompt Disabling triggers for MCYY_INDEX_DEFINE...
alter table MCYY_INDEX_DEFINE disable all triggers;
prompt Deleting MCYY_INDEX_DEFINE...
delete from MCYY_INDEX_DEFINE;
commit;
prompt Loading MCYY_INDEX_DEFINE...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD010101', null, null, 'WD010101', '网点作业', '人员分析', '结构', '人员结构', null, '营运人员职业生涯管理系统 ', null, null, null, '基础指标', '原始值', '月', '日期、机构(总分支行)、人员结构(机构、层级、学历、年龄、工龄、性别)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD010201', null, null, 'WD010201', '网点作业', '人员分析', '产能', '业务量笔数', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、员工、产能类型(折标、原始)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD010202', null, null, 'WD010202', '网点作业', '人员分析', '产能', '人均业务量笔数', null, '营运预警/新柜面', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、产能类型(折标、原始)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD010301', null, null, 'WD010301', '网点作业', '人员分析', '产能', '业务量结构', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、员工、产能类型(折标、原始)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD020101', null, null, 'WD020101', '网点作业', '客户分析', null, '进店客户数', null, '智能服务', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、客户类型', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD020102', null, null, 'WD020102', '网点作业', '客户分析', null, '人均接待客户数', null, '智能服务/新柜面', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030101', null, null, 'WD030101', '网点作业', '账户类业务', '对公账户', '对公账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '户', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030102', null, null, 'WD030102', '网点作业', '账户类业务', '对公账户', '对公结算账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030103', null, null, 'WD030103', '网点作业', '账户类业务', '对公账户', '对公基本存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030104', null, null, 'WD030104', '网点作业', '账户类业务', '对公账户', '对公一般存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
commit;
prompt 10 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030105', null, null, 'WD030105', '网点作业', '账户类业务', '对公账户', '对公专用存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030108', null, null, 'WD030108', '网点作业', '账户类业务', '对公账户', '对公保证金存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030106', null, null, 'WD030106', '网点作业', '账户类业务', '对公账户', '对公临时账户开户数存款', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030107', null, null, 'WD030107', '网点作业', '账户类业务', '对公账户', '对公定期存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030201', null, null, 'WD030201', '网点作业', '账户类业务', '个人账户', '个人账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '户', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030202', null, null, 'WD030202', '网点作业', '账户类业务', '个人账户', '个人结算账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030203', null, null, 'WD030203', '网点作业', '账户类业务', '个人账户', '个人结算Ⅰ类户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030204', null, null, 'WD030204', '网点作业', '账户类业务', '个人账户', '个人结算Ⅱ类户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030205', null, null, 'WD030205', '网点作业', '账户类业务', '个人账户', '个人结算Ⅲ类户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030207', null, null, 'WD030207', '网点作业', '账户类业务', '对公账户', '对公账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
commit;
prompt 20 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030208', null, null, 'WD030208', '网点作业', '账户类业务', '对公账户', '对公结算账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030209', null, null, 'WD030209', '网点作业', '账户类业务', '对公账户', '对公基本存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030210', null, null, 'WD030210', '网点作业', '账户类业务', '对公账户', '对公一般存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030211', null, null, 'WD030211', '网点作业', '账户类业务', '对公账户', '对公专用存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030212', null, null, 'WD030212', '网点作业', '账户类业务', '对公账户', '对公临时账户累计户数存款', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030213', null, null, 'WD030213', '网点作业', '账户类业务', '对公账户', '对公定期存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030214', null, null, 'WD030214', '网点作业', '账户类业务', '对公账户', '对公保证金存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030215', null, null, 'WD030215', '网点作业', '账户类业务', '个人账户', '个人账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030216', null, null, 'WD030216', '网点作业', '账户类业务', '个人账户', '个人结算账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030217', null, null, 'WD030217', '网点作业', '账户类业务', '个人账户', '个人结算Ⅰ类户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
commit;
prompt 30 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030218', null, null, 'WD030218', '网点作业', '账户类业务', '个人账户', '个人结算Ⅱ类户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030219', null, null, 'WD030219', '网点作业', '账户类业务', '个人账户', '个人结算Ⅲ类户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030220', null, null, 'WD030220', '网点作业', '账户类业务', '个人账户', '个人定期存款账户累计户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040101', null, null, 'WD040101', '网点作业', '交易类业务', null, '支付业务交易量', null, null, null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040201', null, null, 'WD040201', '网点作业', '交易类业务', null, '全渠道交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040202', null, null, 'WD040202', '网点作业', '交易类业务', null, '全渠道交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)、币种(本外币)', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040301', null, null, 'WD040301', '网点作业', '交易类业务', null, '大额支付系统交易量', null, '大额支付系统', '陈玲玲、邹云华', null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040302', null, null, 'WD040302', '网点作业', '交易类业务', null, '大额支付系统交易额', null, '大额支付系统', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040401', null, null, 'WD040401', '网点作业', '交易类业务', null, '小额支付系统交易量', null, '小额支付系统', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040402', null, null, 'WD040402', '网点作业', '交易类业务', null, '小额支付系统交易额', null, '小额支付系统', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
commit;
prompt 40 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040501', null, null, 'WD040501', '网点作业', '交易类业务', null, '银联交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040502', null, null, 'WD040502', '网点作业', '交易类业务', null, '银联交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040601', null, null, 'WD040601', '网点作业', '交易类业务', null, '网银交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040602', null, null, 'WD040602', '网点作业', '交易类业务', null, '网银交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040701', null, null, 'WD040701', '网点作业', '交易类业务', null, '手机银行交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040702', null, null, 'WD040702', '网点作业', '交易类业务', null, '手机银行交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040801', null, null, 'WD040801', '网点作业', '交易类业务', null, 'STM数量', null, '自助设备', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '台', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040802', null, null, 'WD040802', '网点作业', '交易类业务', null, 'STM交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、员工、设备、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040803', null, null, 'WD040803', '网点作业', '交易类业务', null, 'STM交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、员工、设备、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040804', null, null, 'WD040804', '网点作业', '交易类业务', null, 'STM交易时长', null, '自助设备', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、操作阶段（交易授权、客户交易、全流程)', '分钟', '否', null);
commit;
prompt 50 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040901', null, null, 'WD040901', '网点作业', '交易类业务', null, '移动终端（PAD）交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040902', null, null, 'WD040902', '网点作业', '交易类业务', null, '移动终端（PAD）交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041001', null, null, 'WD041001', '网点作业', '交易类业务', null, '自助设备（ATM/CRS）交易量', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041002', null, null, 'WD041002', '网点作业', '交易类业务', null, '自助设备（ATM/CRS）交易额', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、币种(本外币)、业务品种', '元', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010105', null, null, 'JZ010105', '集中作业', '集中授权', null, '集中授权退拒任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010106', null, null, 'JZ010106', '集中作业', '集中授权', null, '集中授权暂缓中任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010201', null, null, 'JZ010201', '集中作业', '集中授权', null, '集中授权在线人数', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010301', null, null, 'JZ010301', '集中作业', '集中授权', null, '集中授权预警业务量', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010302', null, null, 'JZ010302', '集中作业', '集中授权', null, '集中授权预警人数', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010401', null, null, 'JZ010401', '集中作业', '集中授权', null, '集中授权各时段业务量', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '笔', '否', null);
commit;
prompt 60 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020101', null, null, 'JZ020101', '集中作业', '流程银行', null, '流程银行总任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020102', null, null, 'JZ020102', '集中作业', '流程银行', null, '流程银行已处理任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020103', null, null, 'JZ020103', '集中作业', '流程银行', null, '流程银行等待中任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020104', null, null, 'JZ020104', '集中作业', '流程银行', null, '流程银行处理中任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '删除');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020105', null, null, 'JZ020105', '集中作业', '流程银行', null, '流程银行替补件任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020106', null, null, 'JZ020106', '集中作业', '流程银行', null, '流程银行退票任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020201', null, null, 'JZ020201', '集中作业', '流程银行', null, '流程银行业务节点任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、操作阶段（录入、版面识别、影像拆分、业务仲裁、人工验印、业务外呼、全票核检、移动受理、全票复核、复核授权)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020202', null, null, 'JZ020202', '集中作业', '流程银行', null, '流程银行已处理节点任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、操作阶段（录入、版面识别、影像拆分、业务仲裁、人工验印、业务外呼、全票核检、移动受理、全票复核、复核授权)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020203', null, null, 'JZ020203', '集中作业', '流程银行', null, '流程银行等待中节点任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、操作阶段（录入、版面识别、影像拆分、业务仲裁、人工验印、业务外呼、全票核检、移动受理、全票复核、复核授权)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020204', null, null, 'JZ020204', '集中作业', '流程银行', null, '流程银行处理中节点任务数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、操作阶段（录入、版面识别、影像拆分、业务仲裁、人工验印、业务外呼、全票核检、移动受理、全票复核、复核授权)', '笔', '否', null);
commit;
prompt 70 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020301', null, null, 'JZ020301', '集中作业', '流程银行', null, '流程银行在线人数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020401', null, null, 'JZ020401', '集中作业', '流程银行', null, '预警业务量', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020402', null, null, 'JZ020402', '集中作业', '流程银行', null, '预警人数', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ020501', null, null, 'JZ020501', '集中作业', '流程银行', null, '流程银行各时段业务量', null, '流程银行', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总行集中作业中心)', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041003', null, null, 'WD041003', '网点作业', '交易类业务', null, '平均营运开机考核率', null, '自助设备', null, null, null, '组合指标', '原始值', '月', '日期、机构(总分支行)、设备', '%', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041004', null, null, 'WD041004', '网点作业', '交易类业务', null, '单台营运开机考核率', null, '自助设备', null, null, null, '基础指标', '原始值', '月', '日期、机构(总分支行)、设备', '%', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041005', null, null, 'WD041005', '网点作业', '交易类业务', null, '平均全功能服务率', null, '自助设备', null, null, null, '组合指标', '原始值', '月', '日期、机构(总分支行)、设备', '%', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041006', null, null, 'WD041006', '网点作业', '交易类业务', null, '单台全功能服务率', null, '自助设备', null, null, null, '基础指标', '原始值', '月', '日期、机构(总分支行)、设备', '%', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041101', null, null, 'WD041101', '网点作业', '交易类业务', null, '预受理渠道交易量', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、业务品种', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041102', null, null, 'WD041102', '网点作业', '交易类业务', null, '预受理渠道交易额', null, '新柜面', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、币种(本外币)、业务品种', '元', '否', null);
commit;
prompt 80 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD041103', null, null, 'WD041103', '网点作业', '交易类业务', null, '预受理渠道成功开立人民币单位银行结算账户比率', null, '新柜面', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '%', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX010101', null, null, 'FX010101', '风险监测', '高风险', null, '高风险问题单种类占比', null, '营运预警', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级、问题单种类', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX010102', null, null, 'FX010102', '风险监测', '高风险', null, '高风险问题单笔数', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX020101', null, null, 'FX020101', '风险监测', '中风险', null, '中风险问题单种类占比', null, '营运预警', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级、问题单种类', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX020102', null, null, 'FX020102', '风险监测', '中风险', null, '中风险问题单笔数', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX030101', null, null, 'FX030101', '风险监测', '低风险', null, '低风险问题单种类占比', null, '营运预警', null, null, null, '组合指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级、问题单种类', '笔', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('FX030102', null, null, 'FX030102', '风险监测', '低风险', null, '低风险问题单笔数', null, '营运预警', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、问题单等级', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010101', null, null, 'JZ010101', '集中作业', '集中授权', null, '集中授权总任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010102', null, null, 'JZ010102', '集中作业', '集中授权', null, '集中授权已处理任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010103', null, null, 'JZ010103', '集中作业', '集中授权', null, '集中授权等待中任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
commit;
prompt 90 records committed...
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('JZ010104', null, null, 'JZ010104', '集中作业', '集中授权', null, '集中授权处理中任务数', null, '新柜面', null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总行集中作业中心)、业务品种', '笔', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD020201', null, null, 'WD020201', '网点作业', '客户分析', null, '客流量时间段分布', null, '智能服务', null, null, null, '基础指标', '原始值', '半小时', '日期、机构(总分支行)', '人', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD030206', null, null, 'WD030206', '网点作业', '账户类业务', '个人账户', '个人定期存款账户开户数', null, '核心', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)', '户', '否', null);
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040102', null, null, 'WD040102', '网点作业', '交易类业务', null, '支付业务交易额', null, null, null, null, null, '基础指标', '原始值', '5分钟/日/月/季/年', '日期、机构(总分支行)、币种(本外币)', '元', '否', '在用');
insert into MCYY_INDEX_DEFINE (index_no, index_clsaa_f, index_clsaa_s, index_no_mcs, index_clsaa_f_mcs, index_clsaa_s_mcs, index_clsaa_t_mcs, index_name_mcs, index_name, source_system, dept_mg, dept_use, regulatory_flag, index_type, index_measure, frequency, dimension, unit, manual_adj_flag, index_state)
values ('WD040805', null, null, 'WD040805', '网点作业', '交易类业务', null, 'STM交重空数', null, '自助设备', null, null, null, '基础指标', '原始值', '日/月/季/年', '日期、机构(总分支行)、设备、业务品种(借记卡、U盾、吞卡)、操作阶段（交易授权、客户交易、全流程)', '分钟', '否', null);
commit;
prompt 95 records loaded
prompt Enabling triggers for MCYY_INDEX_DEFINE...
alter table MCYY_INDEX_DEFINE enable all triggers;
set feedback on
set define on
prompt Done.