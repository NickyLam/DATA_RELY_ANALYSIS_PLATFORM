/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_abs_prod_tranch_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_abs_prod_tranch_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.prd_abs_prod_tranch_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_abs_prod_tranch_info_h(
    tranch_id varchar2(100) -- 分档编号
    ,lp_id varchar2(60) -- 法人编号
    ,abs_prod_id varchar2(100) -- ABS产品编号
    ,tranch_type_cd varchar2(30) -- 分档类型代码
    ,tranch_name varchar2(750) -- 分档名称
    ,curr_cd varchar2(30) -- 币种代码
    ,tranch_amt_pct number(18,6) -- 分档金额占比
    ,tranch_amt number(30,8) -- 分档金额
    ,self_hold_ratio number(18,6) -- 自持比例
    ,rating_cd_1 varchar2(30) -- 评级代码1
    ,rating_org_id_1 varchar2(100) -- 评级机构编号1
    ,rating_cd_2 varchar2(30) -- 评级代码2
    ,rating_org_id_2 varchar2(100) -- 评级机构编号2
    ,exch_serv_fee number(30,8) -- 兑换服务费
    ,ts_flg varchar2(10) -- 暂存标志
    ,effect_dt date -- 生效日期
    ,exp_dt date -- 到期日期
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by range (end_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values less than (to_date('20991231','yyyymmdd'))
        ,subpartition p_default_20991231 values less than (maxvalue)
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_abs_prod_tranch_info_h to ${icl_schema};
grant select on ${iml_schema}.prd_abs_prod_tranch_info_h to ${idl_schema};
grant select on ${iml_schema}.prd_abs_prod_tranch_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_abs_prod_tranch_info_h is '资产证券化产品分档信息历史';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.tranch_id is '分档编号';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.abs_prod_id is 'ABS产品编号';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.tranch_type_cd is '分档类型代码';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.tranch_name is '分档名称';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.curr_cd is '币种代码';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.tranch_amt_pct is '分档金额占比';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.tranch_amt is '分档金额';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.self_hold_ratio is '自持比例';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.rating_cd_1 is '评级代码1';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.rating_org_id_1 is '评级机构编号1';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.rating_cd_2 is '评级代码2';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.rating_org_id_2 is '评级机构编号2';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.exch_serv_fee is '兑换服务费';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.ts_flg is '暂存标志';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.prd_abs_prod_tranch_info_h.etl_timestamp is 'ETL处理时间戳';
