/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t4a_cust_rslt_hst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t4a_cust_rslt_hst
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t4a_cust_rslt_hst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t4a_cust_rslt_hst(
    rslt_id varchar2(192) -- 评级结果编码
    ,model_id varchar2(72) -- 模板编码
    ,fomula_id varchar2(72) -- 公式编号
    ,cust_id varchar2(48) -- 客户号
    ,cust_name varchar2(768) -- 客户名称
    ,first_lvl varchar2(24) -- 初评等级
    ,adjust_lvl varchar2(24) -- 调整等级
    ,curr_lvl varchar2(24) -- 最终风险等级
    ,last_lvl varchar2(24) -- 上次评级结果
    ,stat_dt date -- 评级日期
    ,cust_type varchar2(2) -- 客户类型
    ,org_id varchar2(30) -- 客户机构
    ,rslt_sts varchar2(2) -- 评级结果状态
    ,model_type varchar2(2) -- 模板类型
    ,model_freq varchar2(2) -- 计算频度（参见[字典:t00026]）
    ,create_dt date -- 建立日期
    ,post_id varchar2(15) -- 当前岗位
    ,flow_id varchar2(15) -- 流程id
    ,modifier varchar2(48) -- 调整人
    ,modify_tm varchar2(29) -- 调整时间
    ,reason varchar2(3900) -- 调整原因
    ,model_catg varchar2(2) -- 模板类别
    ,score number(30,2) -- 得分
    ,curr_score number(30,2) -- 调整后得分
    ,is_adjust_score varchar2(2) -- 分值是否调整
    ,due_dt date -- 处理时限
    ,next_stat_dt date -- 下次评级日期
    ,assist_sts varchar2(2) -- 协查状态
    ,rate_source varchar2(2) -- 评级来源：1-系统评级；2-重新调整
    ,rate_type varchar2(2) -- 重评发起方式：1-系统重评；2-人工调整
    ,re_adjust_dt date -- 重评发起日期
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
grant select on ${iol_schema}.amls_t4a_cust_rslt_hst to ${iml_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_hst to ${icl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_hst to ${idl_schema};
grant select on ${iol_schema}.amls_t4a_cust_rslt_hst to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t4a_cust_rslt_hst is '高风险客户等级历史表';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.rslt_id is '评级结果编码';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.model_id is '模板编码';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.fomula_id is '公式编号';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.cust_id is '客户号';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.cust_name is '客户名称';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.first_lvl is '初评等级';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.adjust_lvl is '调整等级';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.curr_lvl is '最终风险等级';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.last_lvl is '上次评级结果';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.stat_dt is '评级日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.cust_type is '客户类型';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.org_id is '客户机构';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.rslt_sts is '评级结果状态';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.model_type is '模板类型';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.model_freq is '计算频度（参见[字典:t00026]）';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.create_dt is '建立日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.post_id is '当前岗位';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.flow_id is '流程id';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.modifier is '调整人';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.modify_tm is '调整时间';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.reason is '调整原因';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.model_catg is '模板类别';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.score is '得分';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.curr_score is '调整后得分';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.is_adjust_score is '分值是否调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.due_dt is '处理时限';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.next_stat_dt is '下次评级日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.assist_sts is '协查状态';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.rate_source is '评级来源：1-系统评级；2-重新调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.rate_type is '重评发起方式：1-系统重评；2-人工调整';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.re_adjust_dt is '重评发起日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t4a_cust_rslt_hst.etl_timestamp is 'ETL处理时间戳';
