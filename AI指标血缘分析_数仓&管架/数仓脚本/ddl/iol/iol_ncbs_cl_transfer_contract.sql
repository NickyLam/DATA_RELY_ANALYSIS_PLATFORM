/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_transfer_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_transfer_contract
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_transfer_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_transfer_contract(
    ccy varchar2(3) -- 币种
    ,prod_type varchar2(12) -- 产品编号
    ,user_id varchar2(8) -- 交易柜员编号
    ,appr_flag varchar2(1) -- 复核标志
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,last_change_date date -- 最后修改日期
    ,pack_date date -- 资产证券化封包日期
    ,redeem_date date -- 资产赎回日期
    ,redeem_int_date date -- 赎回起息日期
    ,sale_date date -- 重空出票日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,appr_user_id varchar2(8) -- 复核柜员
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,profit_loss_calc_method varchar2(1) -- 损益计算方式
    ,amortized_int number(17,2) -- 已摊销利息
    ,asset_transfer_type varchar2(1) -- 资产包转让类型
    ,asset_contract_id varchar2(50) -- 资产证券化资产包编号
    ,asset_contract_type varchar2(3) -- 资产包合同类型
    ,asset_contract_no varchar2(50) -- 资产包合同号
    ,sale_tran_timestamp varchar2(26) -- 发行交易时间戳
    ,asset_int_flag varchar2(1) -- 资产证券化利息拆分标识
    ,sale_cancel_date date -- 资产发行撤销日期
    ,asset_contract_amt number(17,2) -- 资产包金额
    ,pack_tran_timestamp varchar2(26) -- 封包交易时间戳
    ,sale_float_amount number(17,2) -- 发行折溢价
    ,asset_contract_status varchar2(2) -- 资产包合同状态
    ,asset_contract_name varchar2(200) -- 资产证券化资产包名称
    ,asset_odi_flag varchar2(1) -- 资产证券化复利转出标识
    ,asset_odp_flag varchar2(1) -- 资产证券化罚息转出标识
    ,pack_cancel_date date -- 撤包日期
    ,asset_contract_seq_no varchar2(50) -- 资产包合同序号
    ,redeem_float_amount number(17,2) -- 赎回折溢价
    ,is_bad varchar2(1) -- 资产证券化合同表
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
grant select on ${iol_schema}.ncbs_cl_transfer_contract to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_contract to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_contract to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_transfer_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_transfer_contract is '资产证券化合同表';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.appr_flag is '复核标志';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.company is '法人';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.pack_date is '资产证券化封包日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.redeem_date is '资产赎回日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.redeem_int_date is '赎回起息日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.sale_date is '重空出票日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.profit_loss_calc_method is '损益计算方式';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.amortized_int is '已摊销利息';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_transfer_type is '资产包转让类型';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_id is '资产证券化资产包编号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_type is '资产包合同类型';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_no is '资产包合同号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.sale_tran_timestamp is '发行交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_int_flag is '资产证券化利息拆分标识';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.sale_cancel_date is '资产发行撤销日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_amt is '资产包金额';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.pack_tran_timestamp is '封包交易时间戳';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.sale_float_amount is '发行折溢价';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_status is '资产包合同状态';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_name is '资产证券化资产包名称';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_odi_flag is '资产证券化复利转出标识';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_odp_flag is '资产证券化罚息转出标识';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.pack_cancel_date is '撤包日期';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.asset_contract_seq_no is '资产包合同序号';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.redeem_float_amount is '赎回折溢价';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.is_bad is '资产证券化合同表';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_transfer_contract.etl_timestamp is 'ETL处理时间戳';
