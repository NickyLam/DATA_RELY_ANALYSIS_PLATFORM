/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t3b_case
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t3b_case
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t3b_case purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t3b_case(
    case_id varchar2(96) -- 案例编号
    ,stat_dt date -- 数据日期
    ,org_id varchar2(30) -- 甄别机构
    ,case_dt varchar2(15) -- 案例日期
    ,case_kind varchar2(2) -- 案例种类：aml0061
    ,cust_id varchar2(48) -- 主客户编号
    ,cust_name varchar2(768) -- 主客户名称
    ,cust_type varchar2(2) -- 主客户类型
    ,flow_id varchar2(15) -- 流程id ：aml0111
    ,post_id varchar2(15) -- 当前岗位：aml0110
    ,node_id varchar2(30) -- 当前节点：aml0112
    ,case_sts varchar2(2) -- 案例状态：aml0022
    ,is_del varchar2(2) -- 是否排除
    ,is_sys_del varchar2(2) -- 是否系统排除
    ,create_mode varchar2(2) -- 创建方式：aml0024
    ,invalid_dt varchar2(15) -- 正常案例失效日期
    ,is_local_curr varchar2(2) -- 本外币标志
    ,susp_lvl varchar2(99) -- 报送方向：aml0026
    ,take_action varchar2(384) -- 采取措施：aml1020
    ,crime_type varchar2(300) -- 涉罪类型：t1f_susp_actn_code
    ,trig_point varchar2(3003) -- 可疑交易报告触发点：aml0028
    ,is_valid varchar2(2) -- 是否通过验证：aml0042
    ,due_dt date -- 处理期限
    ,create_tm varchar2(29) -- 创建时间
    ,creator varchar2(48) -- 创建人
    ,modify_tm varchar2(29) -- 修改时间
    ,modifier varchar2(48) -- 修改人
    ,fin_act_desc varchar2(4000) -- 资金交易及客户行为情况
    ,other_desc varchar2(4000) -- 疑点分析
    ,is_follow varchar2(2) -- 是否跟踪
    ,eme_lvl varchar2(3) -- 报告紧急程度：aml0140
    ,is_free_trade varchar2(2) -- 是否自贸区案例  0否   1是
    ,rpt_num varchar2(8) -- 报送次数标志
    ,is_continue varchar2(2) -- 是否接续案例(0为否，1为是)
    ,init_case varchar2(96) -- 首次案例号
    ,init_report varchar2(96) -- 首次报告号
    ,p_case_id varchar2(96) -- 父案例编号
    ,score number(18,2) -- 总分值
    ,level_name varchar2(48) -- 可疑度
    ,score_des varchar2(4000) -- 甄别理由
    ,mirs varchar2(96) -- 补正标识
    ,init_msg varchar2(96) -- 首次报文
    ,fill_man varchar2(96) -- 填报人
    ,busi_prod varchar2(96) -- 业务产品-报表使用
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
grant select on ${iol_schema}.amls_t3b_case to ${iml_schema};
grant select on ${iol_schema}.amls_t3b_case to ${icl_schema};
grant select on ${iol_schema}.amls_t3b_case to ${idl_schema};
grant select on ${iol_schema}.amls_t3b_case to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t3b_case is 't3b_可疑案例表';
comment on column ${iol_schema}.amls_t3b_case.case_id is '案例编号';
comment on column ${iol_schema}.amls_t3b_case.stat_dt is '数据日期';
comment on column ${iol_schema}.amls_t3b_case.org_id is '甄别机构';
comment on column ${iol_schema}.amls_t3b_case.case_dt is '案例日期';
comment on column ${iol_schema}.amls_t3b_case.case_kind is '案例种类：aml0061';
comment on column ${iol_schema}.amls_t3b_case.cust_id is '主客户编号';
comment on column ${iol_schema}.amls_t3b_case.cust_name is '主客户名称';
comment on column ${iol_schema}.amls_t3b_case.cust_type is '主客户类型';
comment on column ${iol_schema}.amls_t3b_case.flow_id is '流程id ：aml0111';
comment on column ${iol_schema}.amls_t3b_case.post_id is '当前岗位：aml0110';
comment on column ${iol_schema}.amls_t3b_case.node_id is '当前节点：aml0112';
comment on column ${iol_schema}.amls_t3b_case.case_sts is '案例状态：aml0022';
comment on column ${iol_schema}.amls_t3b_case.is_del is '是否排除';
comment on column ${iol_schema}.amls_t3b_case.is_sys_del is '是否系统排除';
comment on column ${iol_schema}.amls_t3b_case.create_mode is '创建方式：aml0024';
comment on column ${iol_schema}.amls_t3b_case.invalid_dt is '正常案例失效日期';
comment on column ${iol_schema}.amls_t3b_case.is_local_curr is '本外币标志';
comment on column ${iol_schema}.amls_t3b_case.susp_lvl is '报送方向：aml0026';
comment on column ${iol_schema}.amls_t3b_case.take_action is '采取措施：aml1020';
comment on column ${iol_schema}.amls_t3b_case.crime_type is '涉罪类型：t1f_susp_actn_code';
comment on column ${iol_schema}.amls_t3b_case.trig_point is '可疑交易报告触发点：aml0028';
comment on column ${iol_schema}.amls_t3b_case.is_valid is '是否通过验证：aml0042';
comment on column ${iol_schema}.amls_t3b_case.due_dt is '处理期限';
comment on column ${iol_schema}.amls_t3b_case.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t3b_case.creator is '创建人';
comment on column ${iol_schema}.amls_t3b_case.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t3b_case.modifier is '修改人';
comment on column ${iol_schema}.amls_t3b_case.fin_act_desc is '资金交易及客户行为情况';
comment on column ${iol_schema}.amls_t3b_case.other_desc is '疑点分析';
comment on column ${iol_schema}.amls_t3b_case.is_follow is '是否跟踪';
comment on column ${iol_schema}.amls_t3b_case.eme_lvl is '报告紧急程度：aml0140';
comment on column ${iol_schema}.amls_t3b_case.is_free_trade is '是否自贸区案例  0否   1是';
comment on column ${iol_schema}.amls_t3b_case.rpt_num is '报送次数标志';
comment on column ${iol_schema}.amls_t3b_case.is_continue is '是否接续案例(0为否，1为是)';
comment on column ${iol_schema}.amls_t3b_case.init_case is '首次案例号';
comment on column ${iol_schema}.amls_t3b_case.init_report is '首次报告号';
comment on column ${iol_schema}.amls_t3b_case.p_case_id is '父案例编号';
comment on column ${iol_schema}.amls_t3b_case.score is '总分值';
comment on column ${iol_schema}.amls_t3b_case.level_name is '可疑度';
comment on column ${iol_schema}.amls_t3b_case.score_des is '甄别理由';
comment on column ${iol_schema}.amls_t3b_case.mirs is '补正标识';
comment on column ${iol_schema}.amls_t3b_case.init_msg is '首次报文';
comment on column ${iol_schema}.amls_t3b_case.fill_man is '填报人';
comment on column ${iol_schema}.amls_t3b_case.busi_prod is '业务产品-报表使用';
comment on column ${iol_schema}.amls_t3b_case.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t3b_case.etl_timestamp is 'ETL处理时间戳';
