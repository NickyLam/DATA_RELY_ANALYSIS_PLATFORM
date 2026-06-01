/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_a_ent_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_a_ent_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_a_ent_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_ent_info(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,application_num varchar2(40) -- 申请编号
    ,data_time varchar2(20) -- 数据记录时间
    ,ent_name varchar2(200) -- 经营体名称
    ,ent_id varchar2(40) -- 经营体注册号
    ,ent_est_date varchar2(10) -- 设立日期
    ,ent_legal_name varchar2(40) -- 法定代表人名称
    ,ent_tel varchar2(40) -- 经营体电话
    ,end_reg_ad varchar2(200) -- 注册地址
    ,ent_office_ad varchar2(200) -- 经营地址
    ,ent_reg_capital number(24,6) -- 注册资本
    ,ent_real_capital number(24,6) -- 实收资本
    ,ent_emp_num number(10,0) -- 员工人数
    ,ent_cus_relation varchar2(40) -- 申请人与经营体之关系
    ,ent_cus_relation_std varchar2(40) -- 申请人与经营体之关系(规则标准)
    ,ent_cus_share number(24,6) -- 申请人对经营体持股比例
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_ir_a_ent_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_a_ent_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_a_ent_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_a_ent_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_a_ent_info is '一次性数据-经营体基本信息';
comment on column ${iol_schema}.rcds_ir_a_ent_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_a_ent_info.application_num is '申请编号';
comment on column ${iol_schema}.rcds_ir_a_ent_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_name is '经营体名称';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_id is '经营体注册号';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_est_date is '设立日期';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_legal_name is '法定代表人名称';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_tel is '经营体电话';
comment on column ${iol_schema}.rcds_ir_a_ent_info.end_reg_ad is '注册地址';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_office_ad is '经营地址';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_reg_capital is '注册资本';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_real_capital is '实收资本';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_emp_num is '员工人数';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_cus_relation is '申请人与经营体之关系';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_cus_relation_std is '申请人与经营体之关系(规则标准)';
comment on column ${iol_schema}.rcds_ir_a_ent_info.ent_cus_share is '申请人对经营体持股比例';
comment on column ${iol_schema}.rcds_ir_a_ent_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_a_ent_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_a_ent_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_a_ent_info.etl_timestamp is 'ETL处理时间戳';
