/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbsharedtlfund
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbsharedtlfund
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbsharedtlfund purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbsharedtlfund(
    comp_date number(22,0) -- 下发日期
    ,in_client_no varchar2(30) -- 内部客户号
    ,ta_code varchar2(14) -- ta代码
    ,asset_acc varchar2(30) -- 理财账户
    ,bank_no varchar2(3) -- 银行编号
    ,client_no varchar2(36) -- 客户号
    ,bank_acc varchar2(48) -- 银行账号
    ,ta_client varchar2(48) -- ta账号
    ,prd_code varchar2(30) -- 产品代码
    ,vol number(18,3) -- 产品份额
    ,frozen_vol number(18,3) -- 冻结份额
    ,long_frozen_vol number(18,3) -- 长期冻结份额
    ,group_vol number(18,3) -- 组合投资份额
    ,pre_red_date number(22,0) -- 上一可赎回日期
    ,ta_vol number(18,3) -- ta端总份额
    ,ta_available_vol number(18,3) -- ta端可用份额
    ,ta_frozen_vol number(18,3) -- ta端冻结份额
    ,detail_flag varchar2(2) -- 明细标志 1
    ,allow_red_date number(22,0) -- 可赎回日期
    ,seller_code varchar2(14) -- 销售商代码
    ,branch_no varchar2(24) -- 网点代码
    ,serial_no varchar2(48) -- 申请流水号
    ,cfm_date number(22,0) -- 确认日期
    ,cfm_no varchar2(48) -- 确认流水号
    ,tot_back_fee number(18,3) -- 交易后端收费总额
    ,share_class varchar2(2) -- 收费类别
    ,account_status varchar2(2) -- 账户状态
    ,register_date number(22,0) -- 份额注册日期
    ,unmonetary_income number(18,3) -- 货币基金未付收益金额
    ,unmonetary_flag varchar2(2) -- 货币基金未付收益金额正付
    ,source_flag varchar2(2) -- 份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整
    ,div_mode varchar2(2) -- 默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送
    ,guaranteed_amount number(18,3) -- 剩余保本金额
    ,int1 number(22,0) -- 整型备用1
    ,int2 number(22,0) -- 整型备用2
    ,amt1 number(18,3) -- 金额1
    ,amt2 number(18,3) -- 金额2
    ,reserve1 varchar2(375) -- 备用1
    ,reserve2 varchar2(375) -- 备用2
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
grant select on ${iol_schema}.ifms_tbsharedtlfund to ${iml_schema};
grant select on ${iol_schema}.ifms_tbsharedtlfund to ${icl_schema};
grant select on ${iol_schema}.ifms_tbsharedtlfund to ${idl_schema};
grant select on ${iol_schema}.ifms_tbsharedtlfund to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbsharedtlfund is '持有期份额明细表';
comment on column ${iol_schema}.ifms_tbsharedtlfund.comp_date is '下发日期';
comment on column ${iol_schema}.ifms_tbsharedtlfund.in_client_no is '内部客户号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.ta_code is 'ta代码';
comment on column ${iol_schema}.ifms_tbsharedtlfund.asset_acc is '理财账户';
comment on column ${iol_schema}.ifms_tbsharedtlfund.bank_no is '银行编号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.client_no is '客户号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.bank_acc is '银行账号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.ta_client is 'ta账号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.prd_code is '产品代码';
comment on column ${iol_schema}.ifms_tbsharedtlfund.vol is '产品份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.frozen_vol is '冻结份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.long_frozen_vol is '长期冻结份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.group_vol is '组合投资份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.pre_red_date is '上一可赎回日期';
comment on column ${iol_schema}.ifms_tbsharedtlfund.ta_vol is 'ta端总份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.ta_available_vol is 'ta端可用份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.ta_frozen_vol is 'ta端冻结份额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.detail_flag is '明细标志 1';
comment on column ${iol_schema}.ifms_tbsharedtlfund.allow_red_date is '可赎回日期';
comment on column ${iol_schema}.ifms_tbsharedtlfund.seller_code is '销售商代码';
comment on column ${iol_schema}.ifms_tbsharedtlfund.branch_no is '网点代码';
comment on column ${iol_schema}.ifms_tbsharedtlfund.serial_no is '申请流水号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.cfm_date is '确认日期';
comment on column ${iol_schema}.ifms_tbsharedtlfund.cfm_no is '确认流水号';
comment on column ${iol_schema}.ifms_tbsharedtlfund.tot_back_fee is '交易后端收费总额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.share_class is '收费类别';
comment on column ${iol_schema}.ifms_tbsharedtlfund.account_status is '账户状态';
comment on column ${iol_schema}.ifms_tbsharedtlfund.register_date is '份额注册日期';
comment on column ${iol_schema}.ifms_tbsharedtlfund.unmonetary_income is '货币基金未付收益金额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.unmonetary_flag is '货币基金未付收益金额正付';
comment on column ${iol_schema}.ifms_tbsharedtlfund.source_flag is '份额来源 0认购所得 1申购所得 2分红再投所得 3产品转换 4 非交易过户 5-转托管 6-强行调整 7-客户赎回 8 强制赎回 9-对账调整';
comment on column ${iol_schema}.ifms_tbsharedtlfund.div_mode is '默认分红方式 0红利再投 1-现金分红 2-利得现金增值再投资 3-增值现金利得再投资 4-部分再投资 5-赠送';
comment on column ${iol_schema}.ifms_tbsharedtlfund.guaranteed_amount is '剩余保本金额';
comment on column ${iol_schema}.ifms_tbsharedtlfund.int1 is '整型备用1';
comment on column ${iol_schema}.ifms_tbsharedtlfund.int2 is '整型备用2';
comment on column ${iol_schema}.ifms_tbsharedtlfund.amt1 is '金额1';
comment on column ${iol_schema}.ifms_tbsharedtlfund.amt2 is '金额2';
comment on column ${iol_schema}.ifms_tbsharedtlfund.reserve1 is '备用1';
comment on column ${iol_schema}.ifms_tbsharedtlfund.reserve2 is '备用2';
comment on column ${iol_schema}.ifms_tbsharedtlfund.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbsharedtlfund.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbsharedtlfund.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbsharedtlfund.etl_timestamp is 'ETL处理时间戳';
