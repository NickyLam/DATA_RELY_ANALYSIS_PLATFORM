/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_std_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_std_prod_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_std_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_std_prod_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,prod_id varchar2(500) -- 产品编号
    ,prod_name varchar2(4000) -- 产品名称
    ,base_prod_id varchar2(60) -- 基础产品编号
    ,level1_prod_id varchar2(500) -- 一级产品编号
    ,level1_prod_name varchar2(4000) -- 一级产品名称
    ,level2_prod_id varchar2(500) -- 二级产品编号
    ,level2_prod_name varchar2(4000) -- 二级产品名称
    ,level3_prod_id varchar2(500) -- 三级产品编号
    ,level3_prod_name varchar2(4000) -- 三级产品名称
    ,level4_prod_id varchar2(500) -- 四级产品编号
    ,level4_prod_name varchar2(4000) -- 四级产品名称
    ,issue_status_cd varchar2(60) -- 发布状态代码
    ,prod_lev_cd varchar2(60) -- 产品级别代码
    ,prod_status_cd varchar2(4000) -- 产品状态代码
    ,effect_dt date -- 生效日期
    ,invalid_dt date -- 失效日期
    ,prod_sum varchar2(4000) -- 产品概述
    ,mgmt_dept_name varchar2(4000) -- 管理部门名称
    ,map_rule_descb varchar2(4000) -- 映射规则描述
    ,comb_prod_flg varchar2(10) -- 产品组标志
    ,prod_range_cd varchar2(10) -- 产品作用范围代码
    ,provi_merge_flg varchar2(10) -- 计提合并标志
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_std_prod_info to ${idl_schema};
grant select on ${icl_schema}.cmm_std_prod_info to ${iel_schema};
grant select on ${icl_schema}.cmm_std_prod_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_std_prod_info is '标准产品信息';
comment on column ${icl_schema}.cmm_std_prod_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_std_prod_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_std_prod_info.prod_id is '产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.prod_name is '产品名称';
comment on column ${icl_schema}.cmm_std_prod_info.base_prod_id is '基础产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.level1_prod_id is '一级产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.level1_prod_name is '一级产品名称';
comment on column ${icl_schema}.cmm_std_prod_info.level2_prod_id is '二级产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.level2_prod_name is '二级产品名称';
comment on column ${icl_schema}.cmm_std_prod_info.level3_prod_id is '三级产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.level3_prod_name is '三级产品名称';
comment on column ${icl_schema}.cmm_std_prod_info.level4_prod_id is '四级产品编号';
comment on column ${icl_schema}.cmm_std_prod_info.level4_prod_name is '四级产品名称';
comment on column ${icl_schema}.cmm_std_prod_info.issue_status_cd is '发布状态代码';
comment on column ${icl_schema}.cmm_std_prod_info.prod_lev_cd is '产品级别代码';
comment on column ${icl_schema}.cmm_std_prod_info.prod_status_cd is '产品状态代码';
comment on column ${icl_schema}.cmm_std_prod_info.effect_dt is '生效日期';
comment on column ${icl_schema}.cmm_std_prod_info.invalid_dt is '失效日期';
comment on column ${icl_schema}.cmm_std_prod_info.prod_sum is '产品概述';
comment on column ${icl_schema}.cmm_std_prod_info.mgmt_dept_name is '管理部门名称';
comment on column ${icl_schema}.cmm_std_prod_info.map_rule_descb is '映射规则描述';
comment on column ${icl_schema}.cmm_std_prod_info.comb_prod_flg is '产品组标志';
comment on column ${icl_schema}.cmm_std_prod_info.prod_range_cd is '产品作用范围代码';
comment on column ${icl_schema}.cmm_std_prod_info.provi_merge_flg is '计提合并标志';
comment on column ${icl_schema}.cmm_std_prod_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_std_prod_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_std_prod_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_std_prod_info.etl_timestamp is 'ETL处理时间戳';
