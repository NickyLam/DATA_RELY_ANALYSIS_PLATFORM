/*
Purpose:    整合模型层-快照表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml ast_ghb_finc_prod_inpwn_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.ast_ghb_finc_prod_inpwn_info
whenever sqlerror continue none;
drop table ${iml_schema}.ast_ghb_finc_prod_inpwn_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.ast_ghb_finc_prod_inpwn_info(
    asset_id varchar2(60) -- 资产编号
    ,lp_id varchar2(60) -- 法人编号
    ,finc_prod_id varchar2(100) -- 理财产品编号
    ,finc_prod_name varchar2(300) -- 理财产品名称
    ,cap_stl_acct_num varchar2(100) -- 资金结算账号
    ,margin_acct_num varchar2(60) -- 保证金账号
    ,cap_avl_days number(38) -- 资金到帐天数
    ,value_dt date -- 起息日期
    ,exp_dt date -- 到期日期
    ,inpwn_lot number(30,2) -- 质押份额
    ,expe_yld_rat number(18,6) -- 预期收益率
    ,curr_cd varchar2(10) -- 币种代码
    ,tot_lot number(30,2) -- 总份额
    ,remark varchar2(4000) -- 备注
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
grant select on ${iml_schema}.ast_ghb_finc_prod_inpwn_info to ${icl_schema};
grant select on ${iml_schema}.ast_ghb_finc_prod_inpwn_info to ${idl_schema};
grant select on ${iml_schema}.ast_ghb_finc_prod_inpwn_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.ast_ghb_finc_prod_inpwn_info is '本行理财产品质押信息';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.asset_id is '资产编号';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.lp_id is '法人编号';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.finc_prod_id is '理财产品编号';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.finc_prod_name is '理财产品名称';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.cap_stl_acct_num is '资金结算账号';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.margin_acct_num is '保证金账号';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.cap_avl_days is '资金到帐天数';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.value_dt is '起息日期';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.exp_dt is '到期日期';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.inpwn_lot is '质押份额';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.expe_yld_rat is '预期收益率';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.curr_cd is '币种代码';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.tot_lot is '总份额';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.remark is '备注';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.create_dt is '创建日期';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.update_dt is '更新日期';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.id_mark is '增删标志';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.src_table_name is '源表名称';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.job_cd is '任务编码';
comment on column ${iml_schema}.ast_ghb_finc_prod_inpwn_info.etl_timestamp is 'ETL处理时间戳';
