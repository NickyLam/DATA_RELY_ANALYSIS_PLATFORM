/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_prd_sale_param
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_prd_sale_param
whenever sqlerror continue none;
drop table ${iol_schema}.fams_prd_sale_param purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_prd_sale_param(
    finprod_id varchar2(100) -- 金融产品代码
    ,prd_band varchar2(100) -- 产品品牌
    ,cyy_type varchar2(100) -- 币种汇钞标志
    ,sale_channel varchar2(1200) -- 销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选
    ,sale_area varchar2(1200) -- 销售地区，多选逗号分隔
    ,sale_max number(30,2) -- 募集上限
    ,sale_min number(30,2) -- 募集下限
    ,toff_start number(30,2) -- 认购起点
    ,lowest_amt number(30,2) -- 最少追加金额
    ,huge_red_ratio number(30,14) -- 巨额赎回比例
    ,min_paper_qty number(30,4) -- 最低账面份额
    ,min_redm_qty number(30,4) -- 最低赎回份额
    ,can_plge varchar2(100) -- 是否可质押
    ,max_plge_rate number(30,14) -- 质押率上限
    ,first_sale_vdate date -- 首次募集开始日
    ,first_sale_mdate date -- 首次募集结束日
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,consignment_flag varchar2(100) -- 是否支持代销
    ,beforeend_flag varchar2(100) -- 是否允许提前终止
    ,red_flag varchar2(100) -- 是否允许客户赎回
    ,defaultred_flag varchar2(100) -- 是否可违约赎回
    ,beforeestablish_flag varchar2(100) -- 是否可提前成立
    ,continue_flag varchar2(100) -- 是否续投
    ,raise_amt_plan number(30,2) -- 计划募集金额
    ,investor_type varchar2(100) -- 目标客户类型
    ,same_org varchar2(100) -- 同业机构
    ,buy_place varchar2(50) -- 产品销售区域
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
grant select on ${iol_schema}.fams_prd_sale_param to ${iml_schema};
grant select on ${iol_schema}.fams_prd_sale_param to ${icl_schema};
grant select on ${iol_schema}.fams_prd_sale_param to ${idl_schema};
grant select on ${iol_schema}.fams_prd_sale_param to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_prd_sale_param is '参数表';
comment on column ${iol_schema}.fams_prd_sale_param.finprod_id is '金融产品代码';
comment on column ${iol_schema}.fams_prd_sale_param.prd_band is '产品品牌';
comment on column ${iol_schema}.fams_prd_sale_param.cyy_type is '币种汇钞标志';
comment on column ${iol_schema}.fams_prd_sale_param.sale_channel is '销售渠道，多选逗号分隔，柜面、网银、直销银行、手机银行、其他电子渠道，可多选';
comment on column ${iol_schema}.fams_prd_sale_param.sale_area is '销售地区，多选逗号分隔';
comment on column ${iol_schema}.fams_prd_sale_param.sale_max is '募集上限';
comment on column ${iol_schema}.fams_prd_sale_param.sale_min is '募集下限';
comment on column ${iol_schema}.fams_prd_sale_param.toff_start is '认购起点';
comment on column ${iol_schema}.fams_prd_sale_param.lowest_amt is '最少追加金额';
comment on column ${iol_schema}.fams_prd_sale_param.huge_red_ratio is '巨额赎回比例';
comment on column ${iol_schema}.fams_prd_sale_param.min_paper_qty is '最低账面份额';
comment on column ${iol_schema}.fams_prd_sale_param.min_redm_qty is '最低赎回份额';
comment on column ${iol_schema}.fams_prd_sale_param.can_plge is '是否可质押';
comment on column ${iol_schema}.fams_prd_sale_param.max_plge_rate is '质押率上限';
comment on column ${iol_schema}.fams_prd_sale_param.first_sale_vdate is '首次募集开始日';
comment on column ${iol_schema}.fams_prd_sale_param.first_sale_mdate is '首次募集结束日';
comment on column ${iol_schema}.fams_prd_sale_param.create_user is '创建人';
comment on column ${iol_schema}.fams_prd_sale_param.create_dept is '创建部门';
comment on column ${iol_schema}.fams_prd_sale_param.create_time is '创建时间';
comment on column ${iol_schema}.fams_prd_sale_param.update_user is '更新人';
comment on column ${iol_schema}.fams_prd_sale_param.update_time is '更新时间';
comment on column ${iol_schema}.fams_prd_sale_param.consignment_flag is '是否支持代销';
comment on column ${iol_schema}.fams_prd_sale_param.beforeend_flag is '是否允许提前终止';
comment on column ${iol_schema}.fams_prd_sale_param.red_flag is '是否允许客户赎回';
comment on column ${iol_schema}.fams_prd_sale_param.defaultred_flag is '是否可违约赎回';
comment on column ${iol_schema}.fams_prd_sale_param.beforeestablish_flag is '是否可提前成立';
comment on column ${iol_schema}.fams_prd_sale_param.continue_flag is '是否续投';
comment on column ${iol_schema}.fams_prd_sale_param.raise_amt_plan is '计划募集金额';
comment on column ${iol_schema}.fams_prd_sale_param.investor_type is '目标客户类型';
comment on column ${iol_schema}.fams_prd_sale_param.same_org is '同业机构';
comment on column ${iol_schema}.fams_prd_sale_param.buy_place is '产品销售区域';
comment on column ${iol_schema}.fams_prd_sale_param.start_dt is '开始时间';
comment on column ${iol_schema}.fams_prd_sale_param.end_dt is '结束时间';
comment on column ${iol_schema}.fams_prd_sale_param.id_mark is '增删标志';
comment on column ${iol_schema}.fams_prd_sale_param.etl_timestamp is 'ETL处理时间戳';
