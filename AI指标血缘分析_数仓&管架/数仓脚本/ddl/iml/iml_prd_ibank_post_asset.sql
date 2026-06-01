/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml prd_ibank_post_asset
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.prd_ibank_post_asset
whenever sqlerror continue none;
drop table ${iml_schema}.prd_ibank_post_asset purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.prd_ibank_post_asset(
    prod_id varchar2(60) -- 产品编号
    ,lp_id varchar2(60) -- 法人编号
    ,prod_type_cd varchar2(60) -- 产品类型代码
    ,prod_cd varchar2(60) -- 产品代码
    ,prod_name varchar2(300) -- 产品名称
    ,effect_dt date -- 生效日期
    ,ftp_int_rat number(18,8) -- ftp利率
    ,remark varchar2(1500) -- 备注
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,rgst_type_cd varchar2(10) -- 登记类型代码
    ,proj varchar2(45) -- 项目
    ,risk_wt varchar2(45) -- 风险权重
    ,risk_asset_tot number(30,2) -- 风险资产总额
    ,rgst_dt date -- 登记日期
    ,market_inst varchar2(90) -- MARKET_INST
    ,customer_manager varchar2(60) -- 客户经理编号
    ,asset_type_cd varchar2(30) -- 资产类型代码
    ,market_type_cd varchar2(30) -- 市场类型代码
    ,vch_accti_obj_id varchar2(60) -- 券核算对象编号
    ,amt number(38,8) -- 金额
    ,effect_flg varchar2(10) -- 生效标志
    ,margin_amt number(38,8) -- 保证金金额
    ,dep_rcpt_amt number(38,8) -- 存单金额
    ,cfb_amt number(38,8) -- 财富宝金额
    ,tbond_amt number(38,8) -- 国债金额
    ,pb_amt number(38,8) -- 政策性银行金额
    ,pub_dept_enty_amt number(38,8) -- 公共部门实体金额
    ,other_amt number(38,8) -- 其他金额
    ,acvmnt_belong_emply_id varchar2(100) -- 业绩归属员工编号
    ,acvmnt_belong_hq_emply_id varchar2(100) -- 业绩归属总行员工编号
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
grant select on ${iml_schema}.prd_ibank_post_asset to ${icl_schema};
grant select on ${iml_schema}.prd_ibank_post_asset to ${idl_schema};
grant select on ${iml_schema}.prd_ibank_post_asset to ${iel_schema};

-- comment
comment on table ${iml_schema}.prd_ibank_post_asset is '同业持仓资产';
comment on column ${iml_schema}.prd_ibank_post_asset.prod_id is '产品编号';
comment on column ${iml_schema}.prd_ibank_post_asset.lp_id is '法人编号';
comment on column ${iml_schema}.prd_ibank_post_asset.prod_type_cd is '产品类型代码';
comment on column ${iml_schema}.prd_ibank_post_asset.prod_cd is '产品代码';
comment on column ${iml_schema}.prd_ibank_post_asset.prod_name is '产品名称';
comment on column ${iml_schema}.prd_ibank_post_asset.effect_dt is '生效日期';
comment on column ${iml_schema}.prd_ibank_post_asset.ftp_int_rat is 'ftp利率';
comment on column ${iml_schema}.prd_ibank_post_asset.remark is '备注';
comment on column ${iml_schema}.prd_ibank_post_asset.value_dt is '起息日期';
comment on column ${iml_schema}.prd_ibank_post_asset.exp_dt is '到期日期';
comment on column ${iml_schema}.prd_ibank_post_asset.rgst_type_cd is '登记类型代码';
comment on column ${iml_schema}.prd_ibank_post_asset.proj is '项目';
comment on column ${iml_schema}.prd_ibank_post_asset.risk_wt is '风险权重';
comment on column ${iml_schema}.prd_ibank_post_asset.risk_asset_tot is '风险资产总额';
comment on column ${iml_schema}.prd_ibank_post_asset.rgst_dt is '登记日期';
comment on column ${iml_schema}.prd_ibank_post_asset.market_inst is 'MARKET_INST';
comment on column ${iml_schema}.prd_ibank_post_asset.customer_manager is '客户经理编号';
comment on column ${iml_schema}.prd_ibank_post_asset.asset_type_cd is '资产类型代码';
comment on column ${iml_schema}.prd_ibank_post_asset.market_type_cd is '市场类型代码';
comment on column ${iml_schema}.prd_ibank_post_asset.vch_accti_obj_id is '券核算对象编号';
comment on column ${iml_schema}.prd_ibank_post_asset.amt is '金额';
comment on column ${iml_schema}.prd_ibank_post_asset.effect_flg is '生效标志';
comment on column ${iml_schema}.prd_ibank_post_asset.margin_amt is '保证金金额';
comment on column ${iml_schema}.prd_ibank_post_asset.dep_rcpt_amt is '存单金额';
comment on column ${iml_schema}.prd_ibank_post_asset.cfb_amt is '财富宝金额';
comment on column ${iml_schema}.prd_ibank_post_asset.tbond_amt is '国债金额';
comment on column ${iml_schema}.prd_ibank_post_asset.pb_amt is '政策性银行金额';
comment on column ${iml_schema}.prd_ibank_post_asset.pub_dept_enty_amt is '公共部门实体金额';
comment on column ${iml_schema}.prd_ibank_post_asset.other_amt is '其他金额';
comment on column ${iml_schema}.prd_ibank_post_asset.acvmnt_belong_emply_id is '业绩归属员工编号';
comment on column ${iml_schema}.prd_ibank_post_asset.acvmnt_belong_hq_emply_id is '业绩归属总行员工编号';
comment on column ${iml_schema}.prd_ibank_post_asset.create_dt is '创建日期';
comment on column ${iml_schema}.prd_ibank_post_asset.update_dt is '更新日期';
comment on column ${iml_schema}.prd_ibank_post_asset.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.prd_ibank_post_asset.id_mark is '增删标志';
comment on column ${iml_schema}.prd_ibank_post_asset.src_table_name is '源表名称';
comment on column ${iml_schema}.prd_ibank_post_asset.job_cd is '任务编码';
comment on column ${iml_schema}.prd_ibank_post_asset.etl_timestamp is 'ETL处理时间戳';
