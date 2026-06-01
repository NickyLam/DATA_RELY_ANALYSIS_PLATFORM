/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_accounting_entry_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_accounting_entry_def
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_accounting_entry_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_accounting_entry_def(
    as_id varchar2(45) -- 序号
    ,acting_entry_name_1 varchar2(383) -- 一级科目名称
    ,acting_entry_name_2 varchar2(383) -- 二级科目名称
    ,acting_entry_name_3 varchar2(383) -- 三级科目名称
    ,acting_code varchar2(150) -- 核算码
    ,property varchar2(45) -- 科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类
    ,entry_direction varchar2(15) -- 科目方向 1：借 2：贷 0：未知
    ,acting_entry_code_1 varchar2(75) -- 一级科目
    ,acting_entry_code_2 varchar2(75) -- 二级科目
    ,acting_entry_code_3 varchar2(75) -- 三级科目
    ,entry_type_3 varchar2(15) -- 0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目
    ,entry_type varchar2(45) -- 分录类型
    ,entry_type_1 varchar2(15) -- 00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外
    ,entry_type_2 varchar2(15) -- -1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目
    ,entry_type_4 varchar2(15) -- 00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外
    ,entry_type_5 varchar2(15) -- 会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)
    ,gzb_type varchar2(15) -- 0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，x其他
    ,acting_entry_name_4 varchar2(383) -- 四级科目名称
    ,acting_entry_name_5 varchar2(383) -- 五级科目名称
    ,acting_entry_code_4 varchar2(75) -- 四级科目
    ,acting_entry_code_5 varchar2(75) -- 五级科目
    ,entry_type_6 varchar2(300) -- 
    ,entry_type_7 varchar2(30) -- 0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品
    ,property_m varchar2(45) -- 科目类型,数据标准落标,触发器添加
    ,entry_direction_m varchar2(15) -- 科目方向,数据标准落标,触发器添加
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
grant select on ${iol_schema}.ibms_ttrd_accounting_entry_def to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_entry_def to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_entry_def to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_accounting_entry_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_accounting_entry_def is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.as_id is '序号';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_name_1 is '一级科目名称';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_name_2 is '二级科目名称';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_name_3 is '三级科目名称';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_code is '核算码';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.property is '科目属性 1 资产 2 负债 3_0 共同类(可供出售类债券投资公允价值变动) 3_1 实收资本金 3_2 平准金或未分配利润 5 损益类';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_direction is '科目方向 1：借 2：贷 0：未知';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_code_1 is '一级科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_code_2 is '二级科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_code_3 is '三级科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_3 is '0 - 默认值，其他科目，11 - 利息收入增值税，12 - 买卖损益增值税，13 - 利息收入增值税附加税，14 - 买卖损益增值税附加税，21 - 利息收入增值税，22 - 买卖损益增值税，23 - 利息收入增值税附加税，24 - 买卖损益增值税附加税, 131 - 利息收入增值税城建附加税，132 - 利息收入增值税中央教育附加税，133 - 利息收入增值税地方教育附加税，141 - 买卖损益增值税城建附加税，142 - 买卖损益增值税中央教育附加税，143 — 买卖损益增值税地方教育附加税， 231 - 利息收入增值税城建附加税，232 - 利息收入增值税中央教育附加税，233 - 利息收入增值税地方教育附加税，241 - 买卖损益增值税城建附加税，242 - 买卖损益增值税中央教育附加税，243 - 买卖损益增值税地方教育附加税；其中1开头为计税科目，2开头为缴纳科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type is '分录类型';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_1 is '00 - 默认值，11 - 银行表内，12 - 银行表外，21 - 理财表内，22 - 理财表外';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_2 is '-1：默认值，0：汇兑损益科目，1：货币型科目，2：非货币型科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_4 is '00 - 默认值，11 - 管理账表内，12 - 管理账表外，21 - 核心账表内，22 - 核心账表外';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_5 is '会计账户类别默认0, 1:交易类(fvtpl), 2:持有到期类(amc)';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.gzb_type is '0默认值，1成本，2利息调整，3利息，3.1应计利息，3.2预收利息，4估值，4.1估值资产，4.2估值负债，5损益，5.1利息收入，5.1.1计提利息收入，5.1.2摊销收入，5.2价差， 5.2.1价差收入，5.2.2已实现估值损益，5.3估值损益，5.4费用损益，5.5重分类损益，5.6重分类利息收入，6费用成本，7无负债结算，8税，9资金，x其他';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_name_4 is '四级科目名称';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_name_5 is '五级科目名称';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_code_4 is '四级科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.acting_entry_code_5 is '五级科目';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_6 is '';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_type_7 is '0  默认值 ；  1_s 期限品种 空头；1_l 期限品种 多头；2 子产品';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.property_m is '科目类型,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.entry_direction_m is '科目方向,数据标准落标,触发器添加';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_accounting_entry_def.etl_timestamp is 'ETL处理时间戳';
