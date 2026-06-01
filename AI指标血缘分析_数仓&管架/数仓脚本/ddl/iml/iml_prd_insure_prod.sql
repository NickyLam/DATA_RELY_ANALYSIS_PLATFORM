/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_insure_prod
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_insure_prod
whenever sqlerror continue none;
drop table ${iml_schema}.prd_insure_prod purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_insure_prod(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,ta_cd varchar2(30) -- TA代码
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,prod_name varchar2(750) -- 产品名称
    ,prod_descb varchar2(1500) -- 产品描述
    ,prod_type_cd varchar2(30) -- 产品类型代码
    ,prod_sub_type_cd varchar2(30) -- 产品子类型代码
    ,commer_insure_flg varchar2(30) -- 商业保险标志
    ,lmt_ctrl_type_cd varchar2(30) -- 额度控制类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,onl_flg varchar2(10) -- 线上标志
    ,prod_effect_dt date -- 产品生效日期
    ,prod_invalid_dt date -- 产品失效日期
    ,add_flg varchar2(10) -- 增加标志
    ,dir_insure_prod_id varchar2(100) -- 定向保险产品编号
    ,reptac_days number(10) -- 反悔天数
    ,ctrl_flg_comb varchar2(375) -- 控制标志组合
    ,risk_level_cd varchar2(30) -- 风险等级代码
    ,resv_1 varchar2(375) -- 备用1
    ,resv_2 varchar2(375) -- 备用2
    ,resv_3 varchar2(375) -- 备用3
    ,resv_4 varchar2(375) -- 备用4
    ,indv_min_permium_amt number(30,2) -- 个人最小保费金额
    ,org_min_permium_amt number(30,2) -- 机构最小保费金额
    ,indv_max_permium_amt number(30,2) -- 个人最大保费金额
    ,org_max_permium_amt number(30,2) -- 机构最大保费金额
    ,indv_min_permium_corp number(30,2) -- 个人最小保费单位
    ,org_min_permium_corp number(30,2) -- 机构最小保费单位
    ,create_dt date -- 创建日期
    ,update_dt date -- 更新日期
    ,etl_dt date -- ETL处理日期
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_insure_prod to ${icl_schema};
grant select on ${iml_schema}.prd_insure_prod to ${idl_schema};
grant select on ${iml_schema}.prd_insure_prod to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_insure_prod is '保险产品';
comment on column ${iml_schema}.prd_insure_prod.prod_id is '产品编号';
comment on column ${iml_schema}.prd_insure_prod.lp_id is '法人编号';
comment on column ${iml_schema}.prd_insure_prod.ta_cd is 'TA代码';
comment on column ${iml_schema}.prd_insure_prod.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_insure_prod.prod_name is '产品名称';
comment on column ${iml_schema}.prd_insure_prod.prod_descb is '产品描述';
comment on column ${iml_schema}.prd_insure_prod.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_insure_prod.prod_sub_type_cd is '产品子类型代码';
comment on column ${iml_schema}.prd_insure_prod.commer_insure_flg is '商业保险标志';
comment on column ${iml_schema}.prd_insure_prod.lmt_ctrl_type_cd is '额度控制类型代码';
comment on column ${iml_schema}.prd_insure_prod.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_insure_prod.onl_flg is '线上标志';
comment on column ${iml_schema}.prd_insure_prod.prod_effect_dt is '产品生效日期';
comment on column ${iml_schema}.prd_insure_prod.prod_invalid_dt is '产品失效日期';
comment on column ${iml_schema}.prd_insure_prod.add_flg is '增加标志';
comment on column ${iml_schema}.prd_insure_prod.dir_insure_prod_id is '定向保险产品编号';
comment on column ${iml_schema}.prd_insure_prod.reptac_days is '反悔天数';
comment on column ${iml_schema}.prd_insure_prod.ctrl_flg_comb is '控制标志组合';
comment on column ${iml_schema}.prd_insure_prod.risk_level_cd is '风险等级代码';
comment on column ${iml_schema}.prd_insure_prod.resv_1 is '备用1';
comment on column ${iml_schema}.prd_insure_prod.resv_2 is '备用2';
comment on column ${iml_schema}.prd_insure_prod.resv_3 is '备用3';
comment on column ${iml_schema}.prd_insure_prod.resv_4 is '备用4';
comment on column ${iml_schema}.prd_insure_prod.indv_min_permium_amt is '个人最小保费金额';
comment on column ${iml_schema}.prd_insure_prod.org_min_permium_amt is '机构最小保费金额';
comment on column ${iml_schema}.prd_insure_prod.indv_max_permium_amt is '个人最大保费金额';
comment on column ${iml_schema}.prd_insure_prod.org_max_permium_amt is '机构最大保费金额';
comment on column ${iml_schema}.prd_insure_prod.indv_min_permium_corp is '个人最小保费单位';
comment on column ${iml_schema}.prd_insure_prod.org_min_permium_corp is '机构最小保费单位';
comment on column ${iml_schema}.prd_insure_prod.create_dt is '创建日期';
comment on column ${iml_schema}.prd_insure_prod.update_dt is '更新日期';
comment on column ${iml_schema}.prd_insure_prod.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_insure_prod.id_mark is '增删标志';
comment on column ${iml_schema}.prd_insure_prod.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_insure_prod.job_cd is '任务编码';
comment on column ${iml_schema}.prd_insure_prod.etl_timestamp is 'ETL处理时间戳';
