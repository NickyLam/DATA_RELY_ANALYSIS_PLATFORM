/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nfss_tbgrpproduct
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nfss_tbgrpproduct
whenever sqlerror continue none;
drop table ${iol_schema}.nfss_tbgrpproduct purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbgrpproduct(
    group_code varchar2(48) -- 分组代码
    ,group_name varchar2(384) -- 分组名称
    ,group_max_buy_amt number(18,2) -- 累计最大购买金额
    ,group_max_redeem_amt number(18,2) -- 累计最大赎回金额
    ,status varchar2(2) -- 状态
    ,close_time number(38) -- 闭市时间
    ,open_time number(38) -- 开市时间
    ,yield number(18,8) -- 七日年化收益率
    ,income_unit number(22,12) -- 万份收益
    ,remark varchar2(1500) -- 备注
    ,first_limit_amount number(18,2) -- 策略转入基准金额
    ,append_amount number(18,2) -- 追加投资金额
    ,pmin_invest_amt number(38,2) -- 个人最低定投金额
    ,product_risk number(22,0) -- 产品风险等级
    ,strategy_mode varchar2(48) -- 策略模式:0：黑盒策略 1：白盒cppi策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略
    ,create_date number(38) -- 创建日期
    ,create_time varchar2(30) -- 创建时间戳
    ,modi_date number(38) -- 最后修改日期
    ,modi_time number(38) -- 最后修改时间
    ,channels varchar2(75) -- 开放渠道:允许渠道组
    ,template_code varchar2(6) -- 模板编码:产品模板
    ,model_type varchar2(3) -- 模块类型（参数设置用）
    ,liqu_mode varchar2(2) -- 账务模式:[k_zwms] 0-转账 1-冻结
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
grant select on ${iol_schema}.nfss_tbgrpproduct to ${iml_schema};
grant select on ${iol_schema}.nfss_tbgrpproduct to ${icl_schema};
grant select on ${iol_schema}.nfss_tbgrpproduct to ${idl_schema};
grant select on ${iol_schema}.nfss_tbgrpproduct to ${iel_schema};

-- comment
comment on table ${iol_schema}.nfss_tbgrpproduct is '组合产品表';
comment on column ${iol_schema}.nfss_tbgrpproduct.group_code is '分组代码';
comment on column ${iol_schema}.nfss_tbgrpproduct.group_name is '分组名称';
comment on column ${iol_schema}.nfss_tbgrpproduct.group_max_buy_amt is '累计最大购买金额';
comment on column ${iol_schema}.nfss_tbgrpproduct.group_max_redeem_amt is '累计最大赎回金额';
comment on column ${iol_schema}.nfss_tbgrpproduct.status is '状态';
comment on column ${iol_schema}.nfss_tbgrpproduct.close_time is '闭市时间';
comment on column ${iol_schema}.nfss_tbgrpproduct.open_time is '开市时间';
comment on column ${iol_schema}.nfss_tbgrpproduct.yield is '七日年化收益率';
comment on column ${iol_schema}.nfss_tbgrpproduct.income_unit is '万份收益';
comment on column ${iol_schema}.nfss_tbgrpproduct.remark is '备注';
comment on column ${iol_schema}.nfss_tbgrpproduct.first_limit_amount is '策略转入基准金额';
comment on column ${iol_schema}.nfss_tbgrpproduct.append_amount is '追加投资金额';
comment on column ${iol_schema}.nfss_tbgrpproduct.pmin_invest_amt is '个人最低定投金额';
comment on column ${iol_schema}.nfss_tbgrpproduct.product_risk is '产品风险等级';
comment on column ${iol_schema}.nfss_tbgrpproduct.strategy_mode is '策略模式:0：黑盒策略 1：白盒cppi策略 2：白盒金字塔策略 3：白盒二八轮动策略 4：自定义组合策略 5：公募投顾策略';
comment on column ${iol_schema}.nfss_tbgrpproduct.create_date is '创建日期';
comment on column ${iol_schema}.nfss_tbgrpproduct.create_time is '创建时间戳';
comment on column ${iol_schema}.nfss_tbgrpproduct.modi_date is '最后修改日期';
comment on column ${iol_schema}.nfss_tbgrpproduct.modi_time is '最后修改时间';
comment on column ${iol_schema}.nfss_tbgrpproduct.channels is '开放渠道:允许渠道组';
comment on column ${iol_schema}.nfss_tbgrpproduct.template_code is '模板编码:产品模板';
comment on column ${iol_schema}.nfss_tbgrpproduct.model_type is '模块类型（参数设置用）';
comment on column ${iol_schema}.nfss_tbgrpproduct.liqu_mode is '账务模式:[k_zwms] 0-转账 1-冻结';
comment on column ${iol_schema}.nfss_tbgrpproduct.start_dt is '开始时间';
comment on column ${iol_schema}.nfss_tbgrpproduct.end_dt is '结束时间';
comment on column ${iol_schema}.nfss_tbgrpproduct.id_mark is '增删标志';
comment on column ${iol_schema}.nfss_tbgrpproduct.etl_timestamp is 'ETL处理时间戳';
