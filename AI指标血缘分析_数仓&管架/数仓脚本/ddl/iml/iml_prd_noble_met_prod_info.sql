/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_noble_met_prod_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_noble_met_prod_info
whenever sqlerror continue none;
drop table ${iml_schema}.prd_noble_met_prod_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_noble_met_prod_info(
    prod_id varchar2(250) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,ser_num varchar2(100) -- 序列号
    ,merchd_id varchar2(100) -- 商品编号
    ,std_prod_id varchar2(100) -- 标准产品编号
    ,merchd_name varchar2(750) -- 商品名称
    ,merchd_brand varchar2(750) -- 商品品牌
    ,provi_name varchar2(750) -- 供应商名称
    ,merchd_type_cd varchar2(500) -- 商品类型代码
    ,merchd_cls_cd varchar2(30) -- 商品分类代码
    ,goods_id varchar2(100) -- 货品编号
    ,prod_fine varchar2(750) -- 产品成色
    ,prod_gold_ct varchar2(750) -- 产品含金量
    ,prod_artm_ct varchar2(750) -- 产品含银量
    ,prod_matrl varchar2(750) -- 产品材质
    ,craft varchar2(750) -- 工艺
    ,weight_corp varchar2(45) -- 重量单位
    ,weight varchar2(150) -- 重量
    ,measure varchar2(150) -- 尺寸
    ,prod_price number(30,2) -- 产品单价
    ,prod_qtty number(30,2) -- 产品数量
    ,prod_comm_fee_rule varchar2(45) -- 产品手续费规则
    ,sell_lmt_qtty number(10) -- 销售限制数量
    ,prod_status_cd varchar2(30) -- 产品状态代码
    ,grounding_tm date -- 上架时间
    ,under_carige_tm date -- 下架时间
    ,prod_info_create_tm date -- 产品信息创建时间
    ,prod_info_update_tm date -- 产品信息更新时间
    ,addit_data_1 varchar2(150) -- 附加数据1
    ,addit_data_2 varchar2(150) -- 附加数据2
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
grant select on ${iml_schema}.prd_noble_met_prod_info to ${icl_schema};
grant select on ${iml_schema}.prd_noble_met_prod_info to ${idl_schema};
grant select on ${iml_schema}.prd_noble_met_prod_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_noble_met_prod_info is '贵金属产品信息';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_id is '产品编号';
comment on column ${iml_schema}.prd_noble_met_prod_info.lp_id is '法人编号';
comment on column ${iml_schema}.prd_noble_met_prod_info.ser_num is '序列号';
comment on column ${iml_schema}.prd_noble_met_prod_info.merchd_id is '商品编号';
comment on column ${iml_schema}.prd_noble_met_prod_info.std_prod_id is '标准产品编号';
comment on column ${iml_schema}.prd_noble_met_prod_info.merchd_name is '商品名称';
comment on column ${iml_schema}.prd_noble_met_prod_info.merchd_brand is '商品品牌';
comment on column ${iml_schema}.prd_noble_met_prod_info.provi_name is '供应商名称';
comment on column ${iml_schema}.prd_noble_met_prod_info.merchd_type_cd is '商品类型代码';
comment on column ${iml_schema}.prd_noble_met_prod_info.merchd_cls_cd is '商品分类代码';
comment on column ${iml_schema}.prd_noble_met_prod_info.goods_id is '货品编号';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_fine is '产品成色';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_gold_ct is '产品含金量';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_artm_ct is '产品含银量';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_matrl is '产品材质';
comment on column ${iml_schema}.prd_noble_met_prod_info.craft is '工艺';
comment on column ${iml_schema}.prd_noble_met_prod_info.weight_corp is '重量单位';
comment on column ${iml_schema}.prd_noble_met_prod_info.weight is '重量';
comment on column ${iml_schema}.prd_noble_met_prod_info.measure is '尺寸';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_price is '产品单价';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_qtty is '产品数量';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_comm_fee_rule is '产品手续费规则';
comment on column ${iml_schema}.prd_noble_met_prod_info.sell_lmt_qtty is '销售限制数量';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_status_cd is '产品状态代码';
comment on column ${iml_schema}.prd_noble_met_prod_info.grounding_tm is '上架时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.under_carige_tm is '下架时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_info_create_tm is '产品信息创建时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.prod_info_update_tm is '产品信息更新时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.addit_data_1 is '附加数据1';
comment on column ${iml_schema}.prd_noble_met_prod_info.addit_data_2 is '附加数据2';
comment on column ${iml_schema}.prd_noble_met_prod_info.start_dt is '开始时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.end_dt is '结束时间';
comment on column ${iml_schema}.prd_noble_met_prod_info.id_mark is '增删标志';
comment on column ${iml_schema}.prd_noble_met_prod_info.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_noble_met_prod_info.job_cd is '任务编码';
comment on column ${iml_schema}.prd_noble_met_prod_info.etl_timestamp is 'ETL处理时间戳';
