/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fin_trade_product_add
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fin_trade_product_add
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fin_trade_product_add purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fin_trade_product_add(
    finprod_id varchar2(50) -- 金融产品代码
    ,finprod_type varchar2(50) -- 金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层
    ,finprod_type2 varchar2(50) -- 金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层
    ,branch number(10) -- 分支序号
    ,regist_org varchar2(32) -- 登记托管机构
    ,pledge_sec_num number(10) -- 押品只数
    ,create_user varchar2(20) -- 创建人
    ,create_dept varchar2(32) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(20) -- 更新人
    ,update_time timestamp -- 更新时间
    ,exchange_pledge varchar2(50) -- 质押劵置换安排
    ,supply_clause varchar2(1000) -- 补充条款
    ,is_accr_penalty_int varchar2(50) -- 是否计提罚息
    ,penalty_base_type varchar2(50) -- 罚息计提基数
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
grant select on ${iol_schema}.fams_fin_trade_product_add to ${iml_schema};
grant select on ${iol_schema}.fams_fin_trade_product_add to ${icl_schema};
grant select on ${iol_schema}.fams_fin_trade_product_add to ${idl_schema};
grant select on ${iol_schema}.fams_fin_trade_product_add to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fin_trade_product_add is '交易类金融产品附属表';
comment on column ${iol_schema}.fams_fin_trade_product_add.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_fin_trade_product_add.finprod_type is '金融产品类型（估值核算），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_trade_product_add.finprod_type2 is '金融产品类型（投管分类），债券、理财产品、基金、理财产品模板、理财产品分层';
comment on column ${iol_schema}.fams_fin_trade_product_add.branch is '分支序号';
comment on column ${iol_schema}.fams_fin_trade_product_add.regist_org is '登记托管机构';
comment on column ${iol_schema}.fams_fin_trade_product_add.pledge_sec_num is '押品只数';
comment on column ${iol_schema}.fams_fin_trade_product_add.create_user is '创建人';
comment on column ${iol_schema}.fams_fin_trade_product_add.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fin_trade_product_add.create_time is '创建时间';
comment on column ${iol_schema}.fams_fin_trade_product_add.update_user is '更新人';
comment on column ${iol_schema}.fams_fin_trade_product_add.update_time is '更新时间';
comment on column ${iol_schema}.fams_fin_trade_product_add.exchange_pledge is '质押劵置换安排';
comment on column ${iol_schema}.fams_fin_trade_product_add.supply_clause is '补充条款';
comment on column ${iol_schema}.fams_fin_trade_product_add.is_accr_penalty_int is '是否计提罚息';
comment on column ${iol_schema}.fams_fin_trade_product_add.penalty_base_type is '罚息计提基数';
comment on column ${iol_schema}.fams_fin_trade_product_add.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fin_trade_product_add.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fin_trade_product_add.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fin_trade_product_add.etl_timestamp is 'ETL处理时间戳';
