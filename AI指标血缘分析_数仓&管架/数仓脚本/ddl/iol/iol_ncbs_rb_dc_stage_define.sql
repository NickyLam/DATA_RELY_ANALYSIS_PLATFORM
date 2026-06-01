/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_define(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,back_status varchar2(1) -- 额度回收状态
    ,company varchar2(20) -- 法人
    ,error_desc varchar2(3000) -- 错误描述
    ,int_calc_type varchar2(1) -- 计息类型
    ,issue_year varchar2(5) -- 发行年度
    ,operate_method varchar2(2) -- 配额类型
    ,part_withdraw_num number(5) -- 部提次数
    ,pay_int_type varchar2(3) -- 付息方式
    ,pre_withdraw_flag varchar2(1) -- 是否允许提前支取
    ,ration_type varchar2(1) -- 配售方式
    ,redemption_flag varchar2(1) -- 是否可赎回
    ,reset_int_freq varchar2(5) -- 利率重置频率
    ,sale_type varchar2(1) -- 销售方式
    ,stage_code varchar2(50) -- 期次代码
    ,stage_code_desc varchar2(200) -- 期次描述
    ,stage_limit_class varchar2(10) -- 额度扣减类型
    ,stage_prod_class varchar2(5) -- 期次产品分类
    ,stage_status varchar2(2) -- 期次状态
    ,transfer_flag varchar2(1) -- 转账标志
    ,issue_end_date date -- 发行终止日期
    ,issue_start_date date -- 发行起始日期
    ,precontract_end_time varchar2(26) -- 预约结束时间
    ,precontract_start_time varchar2(26) -- 预约开始时间
    ,sale_end_time varchar2(26) -- 止售时间
    ,sale_start_time varchar2(26) -- 起售时间
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,distribute_limit number(17,2) -- 已分配额度
    ,get_int_freq varchar2(5) -- 取息频率
    ,holding_limit number(17,2) -- 已占用额度
    ,leave_limit number(17,2) -- 剩余额度
    ,stage_max_amt number(17,2) -- 期次最大购买金额
    ,stage_min_amt number(17,2) -- 期次起存金额
    ,stage_remark varchar2(600) -- 期次详细备注
    ,total_limit number(17,2) -- 总额度
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,white_sell_flag varchar2(1) -- 是否白名单发售
    ,issue_end_time varchar2(20) -- 发行终止时间
    ,issue_start_time varchar2(20) -- 发行起始时间
    ,allow_buy_way_cd varchar2(1) -- 支持组合购买方式
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_define is '期次定义表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.term is '存期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.back_status is '额度回收状态';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.int_calc_type is '计息类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.issue_year is '发行年度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.operate_method is '配额类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.part_withdraw_num is '部提次数';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.pay_int_type is '付息方式';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.pre_withdraw_flag is '是否允许提前支取';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.ration_type is '配售方式';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.redemption_flag is '是否可赎回';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.reset_int_freq is '利率重置频率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.sale_type is '销售方式';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_code_desc is '期次描述';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_limit_class is '额度扣减类型';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_prod_class is '期次产品分类';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_status is '期次状态';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.transfer_flag is '转账标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.issue_end_date is '发行终止日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.issue_start_date is '发行起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.precontract_end_time is '预约结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.precontract_start_time is '预约开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.sale_end_time is '止售时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.sale_start_time is '起售时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.distribute_limit is '已分配额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.get_int_freq is '取息频率';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.holding_limit is '已占用额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.leave_limit is '剩余额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_max_amt is '期次最大购买金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_min_amt is '期次起存金额';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.stage_remark is '期次详细备注';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.total_limit is '总额度';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.white_sell_flag is '是否白名单发售';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.issue_end_time is '发行终止时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.issue_start_time is '发行起始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.allow_buy_way_cd is '支持组合购买方式';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_define.etl_timestamp is 'ETL处理时间戳';
