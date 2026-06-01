/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t4a_cust_rslt
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t4a_cust_rslt
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t4a_cust_rslt purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t4a_cust_rslt(
    rslt_id varchar2(192) -- 评级结果编码
    ,model_id varchar2(72) -- 模板编码
    ,fomula_id varchar2(72) -- 公式编号
    ,cust_id varchar2(48) -- 客户号
    ,cust_name varchar2(768) -- 客户名称
    ,first_lvl varchar2(24) -- 初评等级  t1h_risk_lvl_map
    ,adjust_lvl varchar2(24) -- 调整等级  t1h_risk_lvl_map
    ,curr_lvl varchar2(24) -- 最终风险等级  t1h_risk_lvl_map
    ,last_lvl varchar2(24) -- 上次评级结果
    ,stat_dt date -- 评级日期
    ,cust_type varchar2(2) -- 客户类型
    ,org_id varchar2(30) -- 客户机构
    ,rslt_sts varchar2(2) -- 评级结果状态[aml0132]
    ,model_type varchar2(2) -- 评级模板类型aml0124
    ,model_freq varchar2(2) -- 计算频度（参见[字典:t00026]）
    ,create_dt date -- 建立日期
    ,post_id varchar2(15) -- 当前岗位（参见[字典:aml0113]）
    ,flow_id varchar2(15) -- 流程id （参见[字典:aml0114]）
    ,modifier varchar2(48) -- 调整人
    ,modify_tm varchar2(29) -- 调整时间
    ,reason varchar2(3900) -- 调整原因
    ,model_catg varchar2(2) -- 评级类别aml0122
    ,score number(30,2) -- 得分
    ,curr_score number(30,2) -- 调整后得分
    ,is_adjust_score varchar2(2) -- 分值是否调整
    ,due_dt date -- 处理时限
    ,next_stat_dt date -- 下次评级日期
    ,assist_sts varchar2(2) -- 协查状态
    ,rate_source varchar2(2) -- 评级来源：1-系统评级；2-重新调整
    ,rate_type varchar2(2) -- 重评发起方式：1-系统重评；2-人工调整
    ,re_adjust_dt date -- 重评发起日期
    ,adjust_score_reason varchar2(1500) -- 分值调整原因
    ,cust_sts varchar2(2) -- 客户状态(0:销户1:正常)
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
grant select on ${iol_schema}.amls_t4a_cust_rslt to ${iml_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt to ${icl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt to ${idl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t4a_cust_rslt is '高风险客户等级';
comment on column ${iol_schema}.amls_t4a_cust_rslt.rslt_id is '评级结果编码';
comment on column ${iol_schema}.amls_t4a_cust_rslt.model_id is '模板编码';
comment on column ${iol_schema}.amls_t4a_cust_rslt.fomula_id is '公式编号';
comment on column ${iol_schema}.amls_t4a_cust_rslt.cust_id is '客户号';
comment on column ${iol_schema}.amls_t4a_cust_rslt.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t4a_cust_rslt.first_lvl is '初评等级  t1h_risk_lvl_map';
comment on column ${iol_schema}.amls_t4a_cust_rslt.adjust_lvl is '调整等级  t1h_risk_lvl_map';
comment on column ${iol_schema}.amls_t4a_cust_rslt.curr_lvl is '最终风险等级  t1h_risk_lvl_map';
comment on column ${iol_schema}.amls_t4a_cust_rslt.last_lvl is '上次评级结果';
comment on column ${iol_schema}.amls_t4a_cust_rslt.stat_dt is '评级日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt.cust_type is '客户类型';
comment on column ${iol_schema}.amls_t4a_cust_rslt.org_id is '客户机构';
comment on column ${iol_schema}.amls_t4a_cust_rslt.rslt_sts is '评级结果状态[aml0132]';
comment on column ${iol_schema}.amls_t4a_cust_rslt.model_type is '评级模板类型aml0124';
comment on column ${iol_schema}.amls_t4a_cust_rslt.model_freq is '计算频度（参见[字典:t00026]）';
comment on column ${iol_schema}.amls_t4a_cust_rslt.create_dt is '建立日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt.post_id is '当前岗位（参见[字典:aml0113]）';
comment on column ${iol_schema}.amls_t4a_cust_rslt.flow_id is '流程id （参见[字典:aml0114]）';
comment on column ${iol_schema}.amls_t4a_cust_rslt.modifier is '调整人';
comment on column ${iol_schema}.amls_t4a_cust_rslt.modify_tm is '调整时间';
comment on column ${iol_schema}.amls_t4a_cust_rslt.reason is '调整原因';
comment on column ${iol_schema}.amls_t4a_cust_rslt.model_catg is '评级类别aml0122';
comment on column ${iol_schema}.amls_t4a_cust_rslt.score is '得分';
comment on column ${iol_schema}.amls_t4a_cust_rslt.curr_score is '调整后得分';
comment on column ${iol_schema}.amls_t4a_cust_rslt.is_adjust_score is '分值是否调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt.due_dt is '处理时限';
comment on column ${iol_schema}.amls_t4a_cust_rslt.next_stat_dt is '下次评级日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt.assist_sts is '协查状态';
comment on column ${iol_schema}.amls_t4a_cust_rslt.rate_source is '评级来源：1-系统评级；2-重新调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt.rate_type is '重评发起方式：1-系统重评；2-人工调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt.re_adjust_dt is '重评发起日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt.adjust_score_reason is '分值调整原因';
comment on column ${iol_schema}.amls_t4a_cust_rslt.cust_sts is '客户状态(0:销户1:正常)';
comment on column ${iol_schema}.amls_t4a_cust_rslt.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt.etl_timestamp is 'ETL处理时间戳';
