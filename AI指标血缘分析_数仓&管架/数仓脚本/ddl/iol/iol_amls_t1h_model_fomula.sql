/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t1h_model_fomula
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t1h_model_fomula
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t1h_model_fomula purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t1h_model_fomula(
    fomula_id varchar2(108) -- 公式编号
    ,model_id varchar2(108) -- 模板编码
    ,fomula_name varchar2(576) -- 公式名称
    ,level_id varchar2(23) -- 等级编号
    ,fomula_des varchar2(1152) -- 描述
    ,fomula_freq varchar2(3) -- 计算频度（参见[字典:t00026]）
    ,fomula_explain varchar2(1152) -- 公式说明
    ,exec_seq number(22) -- 计算顺序
    ,flag varchar2(3) -- 是否启用
    ,cust_type varchar2(3) -- 公式客户类型
    ,create_tm varchar2(44) -- 创建时间
    ,creator varchar2(72) -- 创建人
    ,create_org varchar2(45) -- 创建机构
    ,modify_tm varchar2(44) -- 修改时间
    ,modifier varchar2(72) -- 修改人
    ,who_first number(22) -- 值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果
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
grant select on ${iol_schema}.amls_t1h_model_fomula to ${iml_schema};
grant select on ${iol_schema}.amls_t1h_model_fomula to ${icl_schema};
grant select on ${iol_schema}.amls_t1h_model_fomula to ${idl_schema};
grant select on ${iol_schema}.amls_t1h_model_fomula to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t1h_model_fomula is '评级模型公式表';
comment on column ${iol_schema}.amls_t1h_model_fomula.fomula_id is '公式编号';
comment on column ${iol_schema}.amls_t1h_model_fomula.model_id is '模板编码';
comment on column ${iol_schema}.amls_t1h_model_fomula.fomula_name is '公式名称';
comment on column ${iol_schema}.amls_t1h_model_fomula.level_id is '等级编号';
comment on column ${iol_schema}.amls_t1h_model_fomula.fomula_des is '描述';
comment on column ${iol_schema}.amls_t1h_model_fomula.fomula_freq is '计算频度（参见[字典:t00026]）';
comment on column ${iol_schema}.amls_t1h_model_fomula.fomula_explain is '公式说明';
comment on column ${iol_schema}.amls_t1h_model_fomula.exec_seq is '计算顺序';
comment on column ${iol_schema}.amls_t1h_model_fomula.flag is '是否启用';
comment on column ${iol_schema}.amls_t1h_model_fomula.cust_type is '公式客户类型';
comment on column ${iol_schema}.amls_t1h_model_fomula.create_tm is '创建时间';
comment on column ${iol_schema}.amls_t1h_model_fomula.creator is '创建人';
comment on column ${iol_schema}.amls_t1h_model_fomula.create_org is '创建机构';
comment on column ${iol_schema}.amls_t1h_model_fomula.modify_tm is '修改时间';
comment on column ${iol_schema}.amls_t1h_model_fomula.modifier is '修改人';
comment on column ${iol_schema}.amls_t1h_model_fomula.who_first is '值为空正常熟高原则；此字段填数值时，评级结果为数值较小的那条指标结果';
comment on column ${iol_schema}.amls_t1h_model_fomula.start_dt is '开始时间';
comment on column ${iol_schema}.amls_t1h_model_fomula.end_dt is '结束时间';
comment on column ${iol_schema}.amls_t1h_model_fomula.id_mark is '增删标志';
comment on column ${iol_schema}.amls_t1h_model_fomula.etl_timestamp is 'ETL处理时间戳';
