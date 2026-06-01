/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_fee_type_para
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_fee_type_para
whenever sqlerror continue none;
drop table ${iml_schema}.prd_fee_type_para purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_fee_type_para(
    lp_id varchar2(100) -- 法人编号
    ,fee_type_id varchar2(100) -- 费用类型编号
    ,fee_type_descb varchar2(500) -- 费用类型描述
    ,prod_group_cd varchar2(30) -- 产品组代码
    ,fee_proj_id varchar2(100) -- 费用项目编号
    ,fee_curr_cd varchar2(30) -- 费用币种代码
    ,amort_flg varchar2(10) -- 摊销标志
    ,amort_tenor_type_cd varchar2(30) -- 摊销期限类型代码
    ,fee_rat_calc_way_cd varchar2(30) -- 费率计算方式代码
    ,end_day_onl_cd varchar2(30) -- 日终联机代码
    ,charge_curr_cate_cd varchar2(30) -- 收费币种类别代码
    ,ratio_bf_convt_flg varchar2(10) -- 比率前折算标志
    ,discnt_type_cd varchar2(30) -- 折扣类型代码
    ,need_provi_flg varchar2(10) -- 需要计提标志
    ,fee_price_std_descb varchar2(4000) -- 费用价格标准描述
    ,prefr_charge_std_contn_prefr_tm_descb varchar2(4000) -- 优惠收费标准含优惠时间描述
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.prd_fee_type_para to ${icl_schema};
grant select on ${iml_schema}.prd_fee_type_para to ${idl_schema};
grant select on ${iml_schema}.prd_fee_type_para to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_fee_type_para is '费用产品信息历史';
comment on column ${iml_schema}.prd_fee_type_para.lp_id is '法人编号';
comment on column ${iml_schema}.prd_fee_type_para.fee_type_id is '费用类型编号';
comment on column ${iml_schema}.prd_fee_type_para.fee_type_descb is '费用类型描述';
comment on column ${iml_schema}.prd_fee_type_para.prod_group_cd is '产品组代码';
comment on column ${iml_schema}.prd_fee_type_para.fee_proj_id is '费用项目编号';
comment on column ${iml_schema}.prd_fee_type_para.fee_curr_cd is '费用币种代码';
comment on column ${iml_schema}.prd_fee_type_para.amort_flg is '摊销标志';
comment on column ${iml_schema}.prd_fee_type_para.amort_tenor_type_cd is '摊销期限类型代码';
comment on column ${iml_schema}.prd_fee_type_para.fee_rat_calc_way_cd is '费率计算方式代码';
comment on column ${iml_schema}.prd_fee_type_para.end_day_onl_cd is '日终联机代码';
comment on column ${iml_schema}.prd_fee_type_para.charge_curr_cate_cd is '收费币种类别代码';
comment on column ${iml_schema}.prd_fee_type_para.ratio_bf_convt_flg is '比率前折算标志';
comment on column ${iml_schema}.prd_fee_type_para.discnt_type_cd is '折扣类型代码';
comment on column ${iml_schema}.prd_fee_type_para.need_provi_flg is '需要计提标志';
comment on column ${iml_schema}.prd_fee_type_para.fee_price_std_descb is '费用价格标准描述';
comment on column ${iml_schema}.prd_fee_type_para.prefr_charge_std_contn_prefr_tm_descb is '优惠收费标准含优惠时间描述';
comment on column ${iml_schema}.prd_fee_type_para.start_dt is '开始时间';
comment on column ${iml_schema}.prd_fee_type_para.end_dt is '结束时间';
comment on column ${iml_schema}.prd_fee_type_para.id_mark is '增删标志';
comment on column ${iml_schema}.prd_fee_type_para.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_fee_type_para.job_cd is '任务编码';
comment on column ${iml_schema}.prd_fee_type_para.etl_timestamp is 'ETL处理时间戳';
