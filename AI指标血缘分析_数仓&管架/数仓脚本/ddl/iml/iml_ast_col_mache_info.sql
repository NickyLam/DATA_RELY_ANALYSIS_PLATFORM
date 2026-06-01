/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_col_mache_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_col_mache_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_col_mache_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_col_mache_info(
    asset_id varchar2(100) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,equip_id varchar2(250) -- 设备铭牌编号
    ,house_used_flg varchar2(10) -- 一手二手标志
    ,local_prov_cd varchar2(100) -- 所在省代码
    ,local_city_cd varchar2(100) -- 所在市代码
    ,equip_type_cd varchar2(30) -- 设备类型代码
    ,equip_cls_cd varchar2(100) -- 设备分类代码
    ,equip_model varchar2(100) -- 设备型号
    ,prod_manuf varchar2(375) -- 生产厂商
    ,leave_factory_dt date -- 出厂日期
    ,use_exp_dt date -- 使用到期日期
    ,prod_qual_cert_flg varchar2(10) -- 有产品合格证标志
    ,inv_id varchar2(250) -- 发票编号
    ,inv_dt date -- 发票日期
    ,inv_amt number(30,8) -- 发票金额
    ,curr_cd varchar2(30) -- 币种代码
    ,descb varchar2(4000) -- 描述
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
grant select on ${iml_schema}.ast_col_mache_info to ${icl_schema};
grant select on ${iml_schema}.ast_col_mache_info to ${idl_schema};
grant select on ${iml_schema}.ast_col_mache_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_col_mache_info is '押品机器设备信息';
comment on column ${iml_schema}.ast_col_mache_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_col_mache_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_col_mache_info.equip_id is '设备铭牌编号';
comment on column ${iml_schema}.ast_col_mache_info.house_used_flg is '一手二手标志';
comment on column ${iml_schema}.ast_col_mache_info.local_prov_cd is '所在省代码';
comment on column ${iml_schema}.ast_col_mache_info.local_city_cd is '所在市代码';
comment on column ${iml_schema}.ast_col_mache_info.equip_type_cd is '设备类型代码';
comment on column ${iml_schema}.ast_col_mache_info.equip_cls_cd is '设备分类代码';
comment on column ${iml_schema}.ast_col_mache_info.equip_model is '设备型号';
comment on column ${iml_schema}.ast_col_mache_info.prod_manuf is '生产厂商';
comment on column ${iml_schema}.ast_col_mache_info.leave_factory_dt is '出厂日期';
comment on column ${iml_schema}.ast_col_mache_info.use_exp_dt is '使用到期日期';
comment on column ${iml_schema}.ast_col_mache_info.prod_qual_cert_flg is '有产品合格证标志';
comment on column ${iml_schema}.ast_col_mache_info.inv_id is '发票编号';
comment on column ${iml_schema}.ast_col_mache_info.inv_dt is '发票日期';
comment on column ${iml_schema}.ast_col_mache_info.inv_amt is '发票金额';
comment on column ${iml_schema}.ast_col_mache_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_col_mache_info.descb is '描述';
comment on column ${iml_schema}.ast_col_mache_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_col_mache_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_col_mache_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_col_mache_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_col_mache_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_col_mache_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_col_mache_info.etl_timestamp is 'ETL处理时间戳';
